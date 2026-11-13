local M = {}

---@class navigate.Captures
---@field capture_name string
---@field type string
---@field range string
---@field text string

local queries = {
  class = "(class_definition name: (identifier) @class.name)",
  func = "(function_definition name: (identifier) @function.name)",
  method = "(class_definition body: (block (function_definition name: (identifier) @method.name)))"
}

function M.get_coordinates()
  local center_c = vim.o.columns / 2
  local center_r = vim.o.lines / 2
  local x_col = center_c - (50 / 2)
  local y_row = center_r - (50 / 2)
  return x_col, y_row
end

---@return integer
---@return integer
function M.create_window_and_buffer()
  local col, row = M.get_coordinates()
  local bufnr = vim.api.nvim_create_buf(true, true)
  local title = "Test window"
  local opts = {
    relative = "editor",
    width = 150,
    height = 50,
    col = col,
    row = row,
    border = "single",
    title = title
  }
  opts.title_prefix = nil
  local win_id = vim.api.nvim_open_win(bufnr, true, opts)
  return bufnr, win_id
end

---@param symbol string
---@return navigate.Captures[]|nil
function M.get_symbols(symbol)
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
    local capture_info = {
      capture_name = query.captures[id],
      type = node:type(),
      range = node:range(),
      text = vim.treesitter.get_node_text(node, 0),
    }
    table.insert(captures, capture_info)
  end
  return captures
end

---@param objects navigate.Captures[]
function M.get_names(objects)
  local names = {}
  for _, class in pairs(objects or {}) do
    table.insert(names, class.text)
  end
  return names
end

function M.setup(opts)
  vim.keymap.set('n', "sc", function()
    local classes = M.get_symbols("class")
    if classes then
      local names = M.get_names(classes)
      local bufnr, _ = M.create_window_and_buffer()
      vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, names)
    end
  end)
  vim.keymap.set('n', "sf", function()
    local funcs = M.get_symbols("func")
    if funcs then
      local names = M.get_names(funcs)
      local bufnr, _ = M.create_window_and_buffer()
      vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, names)
    end
  end)
  vim.keymap.set('n', "sm", function()
    local methods = M.get_symbols("method")
    if methods then
      local names = M.get_names(methods)
      local bufnr, _ = M.create_window_and_buffer()
      vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, names)
    end
  end)
end

return M
