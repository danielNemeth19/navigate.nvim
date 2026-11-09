local M = {}

local queries = {
  class = "(class_definition name: (identifier) @type)",
  klass = "(class_definition name: (identifier) @class.name)",
  func = "(function_definition name: (identifier) @function.name)",
  method = "(class_definition body: (block (function_definition name: (identifier) @method.name)))"
}

---@param symbol string
function M.get_symbols(symbol)
  local parser = vim.treesitter.get_parser(0, nil, { error = false })
  if not parser then
    print('no parser created')
    return
  end
  local tree = parser:parse()[1]
  local root = tree:root()
  local symbols = {}
  local qs = queries[symbol]
  local query = vim.treesitter.query.parse(parser:lang(), qs)
  for id, node in query:iter_captures(root, 0) do
    local capture_name = query.captures[id]
    print(vim.inspect({
      capture = capture_name,
      type = node:type(),
      range = { node:range() },
      text = vim.treesitter.get_node_text(node, 0),
      sexpr = node:sexpr(),
    }))
    P(node)
    local current_class = vim.treesitter.get_node_text(node, 0)
    table.insert(symbols, current_class)
  end
  return symbols
end

function M.setup(opts)
  vim.keymap.set('n', "sc", function()
    local klasses = M.get_symbols("class")
    P(klasses)
  end)
  vim.keymap.set('n', "sk", function()
    local klasses = M.get_symbols("klass")
    P(klasses)
  end)
  vim.keymap.set('n', "sf", function()
    local klasses = M.get_symbols("func")
    P(klasses)
  end)
  vim.keymap.set('n', "sm", function()
    local methods = M.get_symbols("method")
    P(methods)
  end)
end

return M
