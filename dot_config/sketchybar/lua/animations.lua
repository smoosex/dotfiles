local settings = require("settings")

local M = {}

M.base_click_animation = function(item)
	Sbar.animate(settings.base_animation, settings.base_animation_duration, function()
		item:set({
			background = {
				shadow = {
					distance = 0,
				},
			},
			padding_left = 6,
			padding_right = 2,
			y_offset = -2,
		})
		item:set({
			background = {
				shadow = {
					distance = 4,
				},
			},
			padding_left = 4,
			padding_right = 4,
			y_offset = 0,
		})
	end)
end

M.base_hover_animation = function(item)
	Sbar.animate(settings.base_animation, settings.base_animation_duration, function()
		item:set({
			y_offset = 2,
		})
	end)
end

M.base_leave_hover_animation = function(item)
	Sbar.animate(settings.base_animation, settings.base_animation_duration, function()
		item:set({
			y_offset = 0,
		})
	end)
end

M.custom_animaiton = function(item, animation, duration, begin_set, end_set)
	Sbar.animate(animation, duration, function()
		item:set(begin_set)
		item:set(end_set)
	end)
end

return M
