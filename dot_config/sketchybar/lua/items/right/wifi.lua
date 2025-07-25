local icons = require("icons")
local colors = require("colors")
local animations = require("animations")
local settings = require("settings")

local popup_width = 250

local wifi = Sbar.add("item", "left.wifi", {
	position = "right",
	icon = {
		color = colors.theme.c8,
	},
	label = { drawing = false },
	padding_right = 0,
	padding_left = 0,
	background = {
		shadow = {
			drawing = false,
		},
	},
})

local ip = Sbar.add("item", {
	position = "popup." .. wifi.name,
	icon = {
		align = "left",
		string = "IP:",
		width = popup_width / 2,
	},
	label = {
		string = "???.???.???.???",
		width = popup_width / 2,
		align = "right",
	},
	background = { drawing = false },
})

local mask = Sbar.add("item", {
	position = "popup." .. wifi.name,
	icon = {
		align = "left",
		string = "Subnet mask:",
		width = popup_width / 2,
	},
	label = {
		string = "???.???.???.???",
		width = popup_width / 2,
		align = "right",
	},
	background = { drawing = false },
})

local router = Sbar.add("item", {
	position = "popup." .. wifi.name,
	icon = {
		align = "left",
		string = "Router:",
		width = popup_width / 2,
	},
	label = {
		string = "???.???.???.???",
		width = popup_width / 2,
		align = "right",
	},
	background = { drawing = false },
})

wifi:subscribe({ "wifi_change", "system_woke" }, function()
	Sbar.exec([[ipconfig getsummary en0 | awk -F ' SSID : '  '/ SSID : / {print $2}']], function(wifi_name)
		local connected = not (wifi_name == "")
		wifi:set({
			icon = {
				string = connected and icons.wifi.connected or icons.wifi.disconnected,
			},
		})

		-- VPN icon
		Sbar.exec([[sleep 2; scutil --nwi | grep -m1 'utun' | awk '{ print $1 }']], function(vpn)
			local vpnconnected = not (vpn == "")

			if vpnconnected then
				Wifi_icon = icons.wifi.vpn
				Wifi_color = colors.green
			end

			wifi:set({
				icon = {
					string = Wifi_icon,
					color = Wifi_color,
				},
			})
		end)
	end)
end)

local function hide_details()
	wifi:set({ popup = { drawing = false } })
end

local function toggle_details()
  local begin_set = { y_offset = -2 }
	local end_set = { y_offset = 0 }
	animations.custom_animaiton(wifi, settings.base_animation, settings.base_animation_duration, begin_set, end_set)
	local should_draw = wifi:query().popup.drawing == "off"
	if should_draw then
		wifi:set({ popup = { drawing = true } })
		Sbar.exec("ipconfig getifaddr en0", function(result)
			ip:set({ label = result })
		end)
		Sbar.exec("networksetup -getinfo Wi-Fi | awk -F 'Subnet mask: ' '/^Subnet mask: / {print $2}'", function(result)
			mask:set({ label = result })
		end)
		Sbar.exec("networksetup -getinfo Wi-Fi | awk -F 'Router: ' '/^Router: / {print $2}'", function(result)
			router:set({ label = result })
		end)
	else
		hide_details()
	end
end

wifi:subscribe("mouse.clicked", toggle_details)
wifi:subscribe("mouse.exited.global", hide_details)

local function copy_label_to_clipboard(env)
	local label = Sbar.query(env.NAME).label.value
	Sbar.exec('echo "' .. label .. '" | pbcopy')
	Sbar.set(env.NAME, { label = { string = icons.clipboard, align = "center" } })
	Sbar.delay(1, function()
		Sbar.set(env.NAME, { label = { string = label, align = "right" } })
	end)
end

ip:subscribe("mouse.clicked", copy_label_to_clipboard)
mask:subscribe("mouse.clicked", copy_label_to_clipboard)
router:subscribe("mouse.clicked", copy_label_to_clipboard)

return wifi
