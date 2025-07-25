local colors = require("colors")
local settings = require("settings")

-- Equivalent to the --bar domain
Sbar.bar({
  position = settings.bar_position,
	height = settings.bar_height,
	color = colors.with_alpha(colors.theme.bg, 1),
	blur_radius = 1,
	padding_right = 0,
	padding_left = 0,
	margin = settings.bar_margin,
	y_offset = settings.bar_y_offset,
	corner_radius = 8,
  topmost = "window",
})
