local colors = require("colors")

local icons = require("icons")
local animations = require("animations")
local settings = require("settings")
local sw_bar_position = require("sw_bar_position")

local current_bar_position = settings.bar_position

local switch_bar = Sbar.add("item", "switch_bar", {
	position = "right",
	icon = {
		string = icons.switch_bar,
		color = colors.theme.c6,
	},
	label = {
		drawing = false,
	},
})

switch_bar:subscribe("mouse.clicked", function()
	animations.base_click_animation(switch_bar)
	sw_bar_position.switch_sketchybar_bar_position(current_bar_position)
	sw_bar_position.switch_rift_bar_position(current_bar_position)
	Sbar.exec("chezmoi apply ~/.config/sketchybar/lua/bar_position.lua ~/.config/rift/config.toml"
		.. " && rift-cli execute config reload && sketchybar --reload")
end)
switch_bar:subscribe("mouse.entered", function()
	animations.base_hover_animation(switch_bar)
end)
switch_bar:subscribe("mouse.exited", function()
	animations.base_leave_hover_animation(switch_bar)
end)
