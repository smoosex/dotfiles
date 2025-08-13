local bar_position = require("bar_position")
local utils = require("utils")

local common_settings = {
	paddings = 4,
	group_paddings = 4,
	bar_height = 30,
	item_height = 22,

	base_animation = "sin",
	base_animation_duration = 8,

	font = {
		text = "Maple Mono NF CN", -- Used for text
		numbers = "Maple Mono NF CN", -- Used for numbers
		size = 14.0,
		style_map = {
			["Regular"] = "Regular",
			["Semibold"] = "Medium",
			["Bold"] = "SemiBold",
			["Heavy"] = "Bold",
			["Black"] = "ExtraBold",
		},
	},
}

local top_bar_settings_addon = {
  bar_height = 30,
	item_height = 22,

	bar_position = "top",
	bar_margin = 8,
	bar_y_offset = 4,

	calendar_position = "right",

	popup_y_offset = 4,
}

local bottom_bar_settings_addon = {
  bar_height = 30,
	item_height = 22,

	bar_position = "bottom",
	bar_margin = 200,
	bar_y_offset = 2,

	calendar_position = "center",

	popup_y_offset = -4,
}

local top_bar_settings = utils.merge_table(common_settings, top_bar_settings_addon)
local bottom_bar_settings = utils.merge_table(common_settings, bottom_bar_settings_addon)

return bar_position == "top" and top_bar_settings or bottom_bar_settings
