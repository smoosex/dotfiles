local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local animations = require("animations")

local logo = Sbar.add("item", {
	icon = {
		string = icons.arch,
		color = colors.theme.c10,
		y_offset = 1,
		align = "center",
		font = {
			size = settings.font.size * 1.3,
		},
	},
	label = { drawing = false },
	background = {
		color = colors.theme.c2,
	},
	padding_left = settings.group_paddings,
	click_script = "$CONFIG_DIR/helpers/menus/bin/menus -s 0",
})

logo:subscribe("mouse.clicked", function()
	animations.base_click_animation(logo)
end)
