local colors = require("colors")
local settings = require("settings")

local bar_properties = {
	position = settings.bar_position,
	height = settings.bar_height,
	color = settings.notch and colors.transparent or colors.theme.bg,
	blur_radius = 0,
	padding_right = 0,
	padding_left = 0,
	margin = settings.bar_margin,
	y_offset = settings.bar_y_offset,
	corner_radius = 8,
	topmost = "window",
}

if settings.notch then
	bar_properties.notch_width = settings.notch_width
	bar_properties.notch_offset = settings.notch_offset
end

Sbar.bar(bar_properties)
