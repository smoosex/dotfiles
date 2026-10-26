local colors = require("colors")
local input_source_util = require("parse_input_source")
local icons = require("icons")
local settings = require("settings")

local input_source = input_source_util.parse_input_source()
local input_source_icon = icons.input_source[input_source]

local input_source_item = Sbar.add("item", "input_source", {
	position = "right",
	background = { padding_left = 0, padding_right = 0 },
	icon = {
		width = settings.item_height,
		align = "center",
		padding_left = 0,
		padding_right = 0,
		string = input_source_icon,
		color = colors.theme.c6,
		font = {
			family = settings.font.text,
			style = settings.font.style_map["Bold"],
			size = settings.font.size + 4,
		},
	},
	label = {
		drawing = false,
	},
})

input_source_item:set({ padding_left = settings.group_paddings, padding_right = settings.group_paddings })

Sbar.add("event", "input_source_change", "AppleSelectedInputSourcesChangedNotification")
input_source_item:subscribe("input_source_change", function()
	local cur_input_source = input_source_util.parse_input_source()
	local cur_input_source_icon = icons.input_source[cur_input_source]
	input_source_item:set({
		icon = {
			string = cur_input_source_icon,
		},
	})
end)
