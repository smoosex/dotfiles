local icons = require("icons")
local colors = require("colors")
local animations = require("animations")
local settings = require("settings")

local popup_width = 200

local battery = Sbar.add("item", "battery", {
	position = "right",
	icon = {},
	label = {
		drawing = false,
	},
	update_freq = 180,
	popup = { align = "center" },
	padding_left = 0,
	padding_right = 0,
	background = {
		shadow = {
			drawing = false,
		},
	},
})

local battery_percentage = Sbar.add("item", {
	position = "popup." .. battery.name,
	icon = {
		width = popup_width / 2,
		string = "Battery:",
		align = "left",
	},
	label = {
		width = popup_width / 2,
		string = "??%",
		align = "right",
	},
	background = { drawing = false },
})

local remaining_time = Sbar.add("item", {
	position = "popup." .. battery.name,
	icon = {
		width = popup_width / 2,
		string = "Time remaining:",
		align = "left",
	},
	label = {
		width = popup_width / 2,
		string = "??:??h",
		align = "right",
	},
	background = { drawing = false },
})

battery:subscribe({ "routine", "power_source_change", "system_woke" }, function()
	Sbar.exec("pmset -g batt", function(batt_info)
		local icon = "!"
		local label = "?"

		local found, _, charge = batt_info:find("(%d+)%%")
		if found then
			charge = tonumber(charge)
			label = charge .. "%"
		end

		local color = colors.green
		local charging, _, _ = batt_info:find("AC Power")

		if charging then
			icon = icons.battery.charging
		else
			if found and charge > 80 then
				icon = icons.battery._100
			elseif found and charge > 60 then
				icon = icons.battery._75
			elseif found and charge > 40 then
				icon = icons.battery._50
			elseif found and charge > 20 then
				icon = icons.battery._25
				color = colors.orange
			else
				icon = icons.battery._0
				color = colors.red
			end
		end

		local lead = ""
		if found and charge < 10 then
			lead = "0"
		end

		battery:set({
			icon = {
				string = icon,
				color = color,
			},
		})
		battery_percentage:set({ label = { string = lead .. label } })
	end)
end)

battery:subscribe("mouse.clicked", function()
	local begin_set = { y_offset = -2 }
	local end_set = { y_offset = 0 }
	animations.custom_animaiton(battery, settings.base_animation, settings.base_animation_duration, begin_set, end_set)
	local drawing = battery:query().popup.drawing
	battery:set({ popup = { drawing = "toggle" } })

	if drawing == "off" then
		Sbar.exec("pmset -g batt", function(batt_info)
			local found, _, remaining = batt_info:find(" (%d+:%d+) remaining")
			local label = found and remaining .. "h" or "No estimate"
			remaining_time:set({ label = label })
		end)
	end
end)

battery:subscribe("mouse.exited.global", function()
	battery:set({ popup = { drawing = false } })
end)

return battery
