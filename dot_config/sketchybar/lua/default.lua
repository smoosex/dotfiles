local settings = require("settings")
local colors = require("colors")
local material = require("material")

Sbar.default({
	updates = "when_shown",
	icon = {
		font = {
			family = settings.font.text,
			style = settings.font.style_map["Bold"],
			size = settings.font.size,
		},
		color = colors.theme.c7,
    highlight_color = colors.theme.c8,
		padding_left = settings.paddings,
		padding_right = settings.paddings,
	},
	label = {
		font = {
			family = settings.font.text,
			style = settings.font.style_map["Semibold"],
			size = settings.font.size,
		},
		color = colors.theme.fg,
		padding_left = settings.paddings,
		padding_right = settings.paddings,
	},
	background = {
		height = settings.item_height,
		color = colors.surface.c2,
		corner_radius = settings.item_corner_radius,
		border_width = material.glass and 1 or 0,
		border_color = material.glass and 0x73ffffff or colors.transparent,
		shadow = {
			drawing = material.glass,
			distance = material.glass and 1 or 0,
			color = material.glass and 0x1f000000 or colors.transparent,
			angle = material.glass and 90 or 33,
		},
	},
	popup = {
		background = {
			border_width = 1,
			corner_radius = 16,
			border_color = colors.theme.c3,
			color = colors.surface.bg,
			shadow = { drawing = false },
		},
		blur_radius = 50,
		y_offset = settings.popup_y_offset,
		align = "center",
	},
	padding_left = settings.group_paddings,
	padding_right = settings.group_paddings,
	scroll_texts = true,
})
