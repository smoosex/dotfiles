local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

Sbar.exec(
	"killall network_load >/dev/null; $CONFIG_DIR/helpers/event_providers/network_load/bin/network_load en0 network_update 2.0"
)

local rate_font = {
	family = settings.font.numbers,
	style = settings.font.style_map["Bold"],
	size = 9.0,
}

Sbar.add("item", "network.padding.right", {
	position = "right",
	width = settings.group_paddings,
	icon = { drawing = false },
	label = { drawing = false },
	background = { drawing = false },
})

local net_up = Sbar.add("item", "network.up", {
	position = "right",
	padding_left = 0,
	padding_right = 0,
	width = 0,
	label = {
		font = rate_font,
		string = "0.0K",
		color = colors.theme.fg,
		width = 40,
		padding_left = 0,
		padding_right = 0,
	},
	y_offset = 4,
	background = { drawing = false },
})

local net_down = Sbar.add("item", "network.down", {
	position = "right",
	padding_left = 0,
	padding_right = 0,
	width = 50,
	label = {
		font = rate_font,
		string = "0.0K",
		color = colors.theme.fg,
		width = 40,
		padding_left = 0,
		padding_right = 0,
	},
	y_offset = -4,
	background = { drawing = false },
})

local net_up_down_icon = Sbar.add("item", "network.up_down", {
	position = "right",
	padding_left = 0,
	padding_right = 0,
	icon = {
		string = icons.wifi.up_down,
		color = colors.theme.c8,
	},
	label = { drawing = false },
	background = { color = colors.theme.c1, shadow = {
		distance = 3,
		angle = 0,
	} },
})

Sbar.add("bracket", "bracket.network", {
	net_up_down_icon.name,
	net_up.name,
	net_down.name,
}, {
	background = {
		color = colors.theme.c2,
	},
})

Sbar.add("item", "network.padding.left", {
	position = "right",
	width = settings.group_paddings,
	icon = { drawing = false },
	label = { drawing = false },
	background = { drawing = false },
})

net_up:subscribe("network_update", function(env)
	local idle_up = env.upload == "0.0K"
	local idle_down = env.download == "0.0K"

	net_up:set({
		label = {
			string = env.upload,
			color = idle_up and colors.theme.c5 or colors.theme.fg,
		},
	})
	net_down:set({
		label = {
			string = env.download,
			color = idle_down and colors.theme.c5 or colors.theme.fg,
		},
	})
end)
