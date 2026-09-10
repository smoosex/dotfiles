local icons = require("icons")
local colors = require("colors")
local settings = require("settings")
local animations = require("animations")

-- Execute the event provider binary which provides the event "cpu_update" for
-- the cpu load data, which is fired every 2.0 seconds.
Sbar.exec("killall cpu_load >/dev/null; $CONFIG_DIR/helpers/event_providers/cpu_load/bin/cpu_load cpu_update 2.0")

Sbar.add("item", "cpu.padding.right", {
	position = "right",
	width = settings.group_paddings,
	icon = { drawing = false },
	label = { drawing = false },
	background = { drawing = false },
})

local cpu_label = Sbar.add("item", "cpu.label", {
	position = "right",
	padding_left = 0,
	padding_right = 0,
	label = {
		string = "??%",
		font = {
			size = 12.0,
		},
	},
	width = 50,
	background = { drawing = false },
})

local cpu_icon = Sbar.add("item", "cpu.icon", {
	position = "right",
	padding_left = 0,
	padding_right = 0,
	icon = {
		string = icons.cpu,
		color = colors.theme.c8,
	},
	label = { drawing = false },
	background = {
		color = colors.theme.c1,
		shadow = {
			distance = 3,
			angle = 0,
		},
	},
})

local cpu = Sbar.add("bracket", "bracket.cpu", {
	cpu_icon.name,
	cpu_label.name,
}, {
	background = { color = colors.theme.c2 },
})

Sbar.add("item", "cpu.padding.left", {
	position = "right",
	width = settings.group_paddings,
	icon = { drawing = false },
	label = { drawing = false },
	background = { drawing = false },
})

cpu_label:subscribe("cpu_update", function(env)
	local load = tonumber(env.total_load)
	local ration = load / 100.
	if ration > 1 then
		ration = 1
	end
	if ration < 0 then
		ration = 0
	end

	local color = colors.blue
	if load > 30 then
		if load < 60 then
			color = colors.yellow
		elseif load < 80 then
			color = colors.orange
		else
			color = colors.red
		end
	end

	cpu_label:set({
		icon = {
			color = color,
		},
		label = {
			string = string.format("%.2f%%", ration * 100),
		},
	})
end)

cpu:subscribe("mouse.clicked", function()
	animations.base_click_animation(cpu)
	Sbar.exec("open -a 'Activity Monitor'")
end)
