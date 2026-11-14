local M = {}

local function color_of(group, attr, fallback)
  local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
  return hl[attr] or fallback
end

function M.apply()
  vim.api.nvim_set_hl(0, "NavigateBorder", {
    fg = color_of("Function", 'fg'),
    default = true
  })
  vim.api.nvim_set_hl(0, "NavigateTitle", {
    fg = color_of("Normal", 'bg'),
    bg = color_of("Function", 'fg'),
    default = true
  })

end

return M
