local settings = require("settings")
local colors = require("colors")

Sbar.default({
	updates = "when_shown",
	icon = {
		font = {
			family = settings.font.text,
			style = settings.font.style_map["Bold"],
			size = settings.font.size,
		},
		color = colors.theme.c7,
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
		color = colors.theme.c2,
		corner_radius = 6,
		shadow = {
      drawing = true,
			distance = 4,
      color = colors.theme.c4,
      angle = 33,
		},
	},
	popup = {
		background = {
			border_width = 0,
			corner_radius = 6,
			border_color = colors.theme.c1,
			color = colors.theme.bg,
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
