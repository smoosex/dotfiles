local colors = require("colors")
local settings = require("settings")

local bar_properties = {
	position = settings.bar_position,
	height = settings.bar_height,
	color = settings.notch and colors.transparent or colors.surface.bg,
	blur_radius = settings.notch and 0 or require("material").blur_radius,
	padding_right = 0,
	padding_left = 0,
	margin = settings.bar_margin,
	y_offset = settings.bar_y_offset,
	corner_radius = settings.bar_corner_radius,
	topmost = "window",
}

if settings.notch then
	bar_properties.notch_width = settings.notch_width
	bar_properties.notch_offset = settings.notch_offset
end

Sbar.bar(bar_properties)
