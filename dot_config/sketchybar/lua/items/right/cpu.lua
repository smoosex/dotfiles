local icons = require("icons")
local colors = require("colors")
local settings = require("settings")
local animations = require("animations")

-- Execute the event provider binary which provides the event "cpu_update" for
-- the cpu load data, which is fired every 2.0 seconds.
Sbar.exec("killall cpu_load >/dev/null; $CONFIG_DIR/helpers/event_providers/cpu_load/bin/cpu_load cpu_update 2.0")

local cpu = Sbar.add("item", "left.cpu", {
	position = "right",
	icon = {
		string = icons.cpu,
		color = colors.theme.c8,
		background = { color = colors.theme.c3, height = settings.item_height, border_width = 0, corner_radius = 6 },
	},
	label = {
		string = "??%",
		font = {
			size = 12.0,
		},
	},
})


cpu:subscribe("cpu_update", function(env)
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

	cpu:set({
		icon = {
			color = color,
		},
		label = {
			string = ration * 100 .. "%",
		},
	})
end)

cpu:subscribe("mouse.clicked", function()
  animations.base_click_animation(cpu)
	Sbar.exec("open -a 'Activity Monitor'")
end)

-- sbar.add("alias", "WeChat,Item-0", {
-- 	position = "right",
-- 	alias = { color = colors.tundra.c2 },
-- 	-- background = { color = colors.tundra.c0, height = 20, border_width = 0 },
-- })
