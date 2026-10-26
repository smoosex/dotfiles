local colors = require("colors")
local settings = require("settings")
local names = {}

return function(displays)
	for i = #names, 1, -1 do
		Sbar.remove(names[i])
	end
	names = {}
	if settings.bar_position ~= "top" then
		return
	end

	local moves = {}
	for _, display in ipairs(displays) do
		local prefix = "display.bg." .. display.id .. "."
		local function anchor(name, position, padding)
			local full_name = prefix .. name
			Sbar.add("item", full_name, {
				display = display.id,
				position = position,
				width = padding and "dynamic" or 0,
				padding_left = 0,
				padding_right = padding or 0,
				icon = { drawing = false },
				label = { drawing = false },
				background = { drawing = false },
			})
			names[#names + 1] = full_name
			moves[#moves + 1] = "--move " .. full_name .. " before logo"
		end
		local function background(name, first, last)
			local full_name = prefix .. name
			Sbar.add("bracket", full_name, { prefix .. first, prefix .. last }, {
				blur_radius = require("material").blur_radius,
				background = {
					drawing = true,
					color = colors.surface.bg,
					height = settings.bar_height,
					corner_radius = settings.bar_corner_radius,
					border_width = 0,
					shadow = { drawing = false, color = colors.transparent, distance = 0 },
				},
			})
			names[#names + 1] = full_name
			moves[#moves + 1] = "--move " .. full_name .. " before logo"
		end

		anchor("left.edge", "left")
		if display.notch_width > 0 then
			anchor("left.notch", "q")
			anchor("right.padding", "right", 4)
			anchor("right.notch.padding", "e", -3)
			anchor("right.notch", "e")
		end
		anchor("right.edge", "right")

		if display.notch_width > 0 then
			background("left", "left.edge", "left.notch")
			background("right", "right.notch", "right.edge")
		else
			background("full", "left.edge", "right.edge")
		end
	end
	if #moves > 0 then
		Sbar.exec("sketchybar " .. table.concat(moves, " "))
	end
end
