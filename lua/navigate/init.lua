local M = {}
local default_opts = require("navigate.config")
local navigate = require("navigate.navigate")

M.options = vim.deepcopy(default_opts)

-- TODO: check if older also works with lazy false
-- even better check if original code works with ft=python from lazy's side
function M.setup(opts)
   M.options = vim.tbl_deep_extend("force", {}, default_opts, opts or {} )
end

function M.attach(buf)
  local n = navigate:new(M.options)
  for symbol, keymap in pairs(n.opts.keymaps) do
    vim.keymap.set("n", keymap, function ()
     n:navigate_symbols(symbol)
    end, { buffer = buf})
  end
end

return M
