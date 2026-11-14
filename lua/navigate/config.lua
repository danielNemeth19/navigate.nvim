---@class navigate.window_config
---@field relative string
---@field width integer
---@field height integer
---@field style string
---@field border string|table
---@field title string|table
---@field title_pos "left"|"right"|"center"
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

return window_config
