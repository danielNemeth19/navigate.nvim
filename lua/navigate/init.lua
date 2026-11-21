local M = {}
local default_opts = require("navigate.config")
local navigate = require("navigate.navigate")


function M.setup(opts)
  local options = vim.tbl_deep_extend("force", {}, default_opts, opts or {} )
  vim.api.nvim_create_autocmd("FileType", {
    pattern = navigate.supported_languages(),
    group = vim.api.nvim_create_augroup("navigate", { clear = true }),
    callback = function(args)
      local n = navigate:new(options)
      for symbol, keymap in pairs(n.opts.keymaps) do
        vim.keymap.set("n", keymap, function()
          n:navigate_symbols(symbol)
        end, {buffer = args.buf})
      end
    end
  })
end

return M
