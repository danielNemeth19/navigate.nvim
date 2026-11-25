if vim.g.loaded_navigate then
  return
end

vim.g.loaded_navigate = true

local highlights = require("navigate.highlight")
highlights.apply()

-- registering highlight's apply in case `colorscheme` command is being run
vim.api.nvim_create_autocmd('ColorScheme', {
  group = vim.api.nvim_create_augroup("NavigateHighlights", { clear = true }),
  callback = highlights.apply
})

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("navigate_start", { clear = true }),
  pattern = require("navigate.navigate").supported_languages(),
  callback = function(args)
    require("navigate").attach(args.buf)
  end
})
