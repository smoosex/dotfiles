local input_source_util = require("parse_input_source")
local icons = require("icons")
local settings = require("settings")


local input_source = input_source_util.parse_input_source()
local input_source_icon = icons.input_source[input_source]

local input_source_item = Sbar.add("item", "input_source", {
	position = "right",
	icon = {
		string = input_source_icon,
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

Sbar.add("event", "input_source_change", "AppleSelectedInputSourcesChangedNotification")
input_source_item:subscribe("input_source_change", function()
	local cur_input_source = input_source_util.parse_input_source()
	local cur_input_source_icon = icons.input_source[cur_input_source]
	 input_source_item:set({
	   icon = {
	     string = cur_input_source_icon,
	   }
	 })
end)
