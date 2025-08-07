local settings = require("settings")
local colors = require("colors")
local animations = require("animations")

local cal = Sbar.add("item", "datetime", {
	icon = {
		color = colors.theme.fg,
		font = {
			size = 12.0,
		},
	},
	label = {
		drawing = true,
		align = "right",
		font = {
			family = settings.font.text,
			size = 12.0,
		},
	},
	position = settings.calendar_position,
	update_freq = 30,
})

cal:subscribe({ "forced", "routine", "system_woke" }, function()
	cal:set({ icon = os.date("%a. %d %b."), label = os.date("%H:%M") })
end)
cal:subscribe("mouse.clicked", function()
	animations.base_click_animation(cal)
	Sbar.exec("open -a 'Calendar'")
end)

Sbar.add("item", "left.bracket.battery.volume.wifi.padding.right", {
	position = "right",
	width = settings.group_paddings,
})
