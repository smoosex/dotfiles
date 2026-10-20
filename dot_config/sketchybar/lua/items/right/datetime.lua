local settings = require("settings")
local colors = require("colors")
local animations = require("animations")

local dt = Sbar.add("item", "datetime", {
	icon = {
    drawing = false,
	},
	label = {
		drawing = true,
		align = "right",
		font = {
			family = settings.font.text,
			size = settings.font.size - 1,
		},
	},
	position = settings.calendar_position,
	update_freq = 30,
})

dt:subscribe({ "forced", "routine", "system_woke" }, function()
	dt:set({ label = os.date("%a %d | %H:%M") })
end)
dt:subscribe("mouse.clicked", function()
	animations.base_click_animation(dt)
	Sbar.exec("open -a 'Calendar'")
end)

Sbar.add("item", "bracket.battery.volume.wifi.padding.right", {
	position = "right",
	width = 2 * settings.group_paddings,
	icon = { drawing = false },
	label = { drawing = false },
	background = { drawing = false },
})
