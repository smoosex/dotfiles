local colors = require("colors")
local settings = require("settings")

local function add_anchor(name, position, spacing)
	Sbar.add("item", "notch.bg." .. name, {
		position = position,
		width = spacing and "dynamic" or 0,
		padding_left = 0,
		padding_right = spacing or 0,
		icon = { drawing = false },
		label = { drawing = false },
		background = { drawing = false },
	})
end

local function add_background(side, first, last)
	Sbar.add("bracket", "notch.bg." .. side, {
		"notch.bg." .. side .. "." .. first,
		"notch.bg." .. side .. "." .. last,
	}, {
		background = {
			drawing = true,
			color = colors.theme.bg,
			height = settings.bar_height,
			corner_radius = 8,
			shadow = { drawing = false },
		},
	})
end

add_anchor("left.edge", "left")
add_anchor("left.notch", "q")
add_anchor("right.padding", "right", 4)
add_anchor("right.notch.padding", "e", -3)
add_anchor("right.notch", "e")
add_anchor("right.edge", "right")

add_background("left", "edge", "notch")
add_background("right", "notch", "edge")
