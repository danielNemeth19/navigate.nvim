---@class navigate.window_config
---@field relative string
---@field width integer
---@field height integer
---@field style string
---@field border string|table
---@field title string|table
---@field title_pos "left"|"right"|"center"

---@class navigate.keymaps
---@field class string
---@field func string
---@field method string

---@class navigate.opts
---@field window_config navigate.window_config
---@field keymaps navigate.keymaps

---@type navigate.window_config
local window_config = {
  relative = "editor",
  width = 50,
  height = 40,
  style = "minimal",
  border = {
    { '╭', 'NavigateBorder' }, { '─', 'NavigateBorder' },
    { '╮', 'NavigateBorder' }, { '│', 'NavigateBorder' },
    { '╯', 'NavigateBorder' }, { '─', 'NavigateBorder' },
    { '╰', 'NavigateBorder' }, { '│', 'NavigateBorder' },
  },
  title = { { ' ', 'NavigateBorder' }, { ' Navigate ', 'NavigateTitle' }, { ' ', 'NavigateBorder' } },
  title_pos = 'center',
  footer = { { ' q to close ', 'FloatFooter' } },
  footer_pos = 'right',
  zindex = 50,
}


---@type navigate.keymaps
local keymap_presets = {
  class = "sc",
  method = "sm",
  func = "sf",
}

---@type navigate.opts
local opts = {
  window_config = window_config,
  keymaps = keymap_presets
}

return opts
