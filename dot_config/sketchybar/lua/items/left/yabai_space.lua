local icons = require("icons")
local colors = require("colors")
local animations = require("animations")
local settings = require("settings")

local spaces = {}

local create_space = function(ws, ws_name)
	local is_focused = ws["has-focus"]
	local space = Sbar.add("item", ws_name, {
		icon = {
			string = is_focused and icons.focused_space or icons.space,
			color = is_focused and colors.theme.c8 or colors.theme.fg,
			font = {
				family = settings.font.text,
				style = settings.font.style_map["Bold"],
				size = settings.font.size,
			},
		},
		label = { drawing = false },
		background = {
			color = colors.transparent,
			shadow = {
				drawing = false,
			},
		},
		padding_left = 0,
		padding_right = 0,
		click_script = "yabai -m space --focus " .. ws.index,
	})

	space:subscribe("mouse.clicked", function()
		animations.custom_animaiton(
			space,
			settings.base_animation,
			settings.base_animation_duration,
			{ y_offset = -2 },
			{ y_offset = 0 }
		)
	end)
	space:subscribe("mouse.entered", function()
		animations.base_hover_animation(space)
	end)
	space:subscribe("mouse.exited", function()
		animations.base_leave_hover_animation(space)
	end)

	return space
end

local sync_spaces = function()
	Sbar.exec("yabai -m query --spaces", function(result, _)
		if type(result) ~= "table" then
			return
		end

		for _, ws in ipairs(result) do
			if type(ws) ~= "table" or ws.index == nil then
				goto continue
			end

			local ws_name = "yabai_space." .. tostring(ws.index)
			local space = spaces[ws_name]

			if space == nil then
				spaces[ws_name] = create_space(ws, ws_name)
			else
				space:set({
					icon = {
						string = ws["has-focus"] and icons.focused_space or icons.space,
						color = ws["has-focus"] and colors.theme.c8 or colors.theme.fg,
					},
				})
			end

			::continue::
		end
	end)
end

local space_subscriber = Sbar.add("item", {
	drawing = false,
	updates = true,
})

space_subscriber:subscribe("yabai_space_change", sync_spaces)

sync_spaces()
