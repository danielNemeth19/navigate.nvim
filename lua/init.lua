local M = {}

function all_classes()
  local parser = vim.treesitter.get_parser(0, nil, { error = false })
  if not parser then
    print('no parser created')
    return
  end
  local tree = parser:parse()[1]
  local root = tree:root()
  local classes = {}
  local qs = "(function_definition name: (identifier) @type)"
  local query = vim.treesitter.query.parse(parser:lang(), qs)
  for _, node in query:iter_captures(root, 0) do
    local current_class = vim.treesitter.get_node_text(node, 0)
    table.insert(classes, current_class)
  end
  return classes
end

function M.setup(opts)
  vim.keymap.set('n', "sc", function()
    local klasses = all_classes()
    P(klasses)
  end)
  vim.keymap.set('n', "sm", function()
    local klasses = all_classes()
    P(klasses)
  end)
end

return M
