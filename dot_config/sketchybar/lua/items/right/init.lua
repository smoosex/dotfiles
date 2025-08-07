local colors = require("colors")
local settings = require("settings")

require("items.right.calendar")

local battery = require("items.right.battery")
local volume = require("items.right.volume")
local wifi = require("items.right.wifi")
Sbar.add("bracket", "bracket.battery.volume.wifi", {
	battery.name,
	volume.name,
	wifi.name,
}, {
	background = { color = colors.theme.c2 },
})

Sbar.add("item", "bracket.battery.volume.wifi.padding.left", {
	position = "right",
	width = settings.group_paddings,
	icon = { drawing = false },
	label = { drawing = false },
	background = { drawing = false },
})

require("items.right.cpu")
require("items.right.matheme")
require("items.right.switch_bar")
require("items.right.tmux")
