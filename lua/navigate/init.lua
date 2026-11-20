local M = {}
local navigate = require("navigate.navigate")

function M.setup(opts)
  local n = navigate:new()
  vim.api.nvim_create_autocmd("Filetype", {
    pattern = "python",
    callback = function()
      vim.keymap.set("n", "sc", function()
        n:navigate_symbols("class")
      end, { buffer = true })
    end
  })
  vim.api.nvim_create_autocmd("Filetype", {
    pattern = "python",
    callback = function()
      vim.keymap.set("n", "sf", function()
        n:navigate_symbols("func")
      end, { buffer = true })
    end
  })
  vim.api.nvim_create_autocmd("Filetype", {
    pattern = "python",
    callback = function()
      vim.keymap.set("n", "sm", function()
        n:navigate_symbols("method")
      end, { buffer = true })
    end
  })
end

return M
