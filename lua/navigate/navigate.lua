local win_config = require("navigate.config")

---@class Navigate
---@field config navigate.window_config
local Navigate = {}
Navigate.__index = Navigate

function Navigate:new()
  local instance = setmetatable({}, self)
  return instance
end

---@class navigate.Captures
---@field capture_name string
---@field type string
---@field range table
---@field text string

local queries = {
  class = "(class_definition name: (identifier) @class.name)",
  func = "(function_definition name: (identifier) @function.name)",
  method = "(class_definition body: (block (function_definition name: (identifier) @method.name)))"
}

function Navigate:get_coordinates()
  local center_c = vim.o.columns / 2
  local center_r = vim.o.lines / 2
  local x_col = center_c - (50 / 2)
  local y_row = center_r - (50 / 2)
  return x_col, y_row
end

---@return integer
---@return integer
function Navigate:create_window_and_buffer()
  local col, row = self:get_coordinates()
  local bufnr = vim.api.nvim_create_buf(true, true)

  -- local title = win_config.title_prefix .. "class"
  local opts = vim.tbl_extend("force", win_config, { col = col, row = row, title = title })
  -- opts.title_prefix = nil
  local win_id = vim.api.nvim_open_win(bufnr, true, opts)
  return bufnr, win_id
end

---@param symbol string
---@return navigate.Captures[]|nil
function Navigate:get_symbols(symbol)
  local parser = vim.treesitter.get_parser(0, nil, { error = false })
  if not parser then
    print('no parser created')
    return
  end
  local tree = parser:parse()[1]
  local root = tree:root()
  ---@type navigate.Captures
  local captures = {}
  local qs = queries[symbol]
  local query = vim.treesitter.query.parse(parser:lang(), qs)
  for id, node in query:iter_captures(root, 0) do
    local p1, p2, p3, p4 = node:range()
    local pos_info = {
      p1 = p1,
      p2 = p2,
      p3 = p3,
      p4 = p4
    }
    local capture_info = {
      capture_name = query.captures[id],
      type = node:type(),
      range = pos_info,
      text = vim.treesitter.get_node_text(node, 0),
    }
    table.insert(captures, capture_info)
  end
  return captures
end

---@param fn string
---@param objects navigate.Captures[]
function Navigate:get_quickfix_list(fn, objects)
  local qf_l = vim.tbl_map(function(item)
    return {filename = fn, lnum = item.range.p1 + 1, col = item.range.p2 + 1, text = item.text}
  end, objects)
  return qf_l
end

---@param symbol_type string
function Navigate:navigate_symbols(symbol_type)
  local fn = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
  local symbols = self:get_symbols(symbol_type)
  if symbols then
    local bufnr, win_id = self:create_window_and_buffer()
    local lines = vim.tbl_map(function(item)
      return string.format("%s: %d %d", item.text, item.range.p1, item.range.p2)
    end, symbols)
    local qf_l = self:get_quickfix_list(fn, symbols)
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
    vim.keymap.set("n", "<C-q>", function()
      vim.fn.setqflist({}, " ", { title = "Navigate results", items = qf_l })
      vim.api.nvim_win_close(win_id, true)
      vim.cmd.copen()
    end, { buffer = bufnr, desc = "Send all to quickfix" })
  end
end

return Navigate
