local aerospace_server = Sbar.aerospace
local icons = require("icons")
local colors = require("colors")
local animations = require("animations")
local settings = require("settings")

local spaces = {}
local focused_space = aerospace_server:list_current()
local workspaces = aerospace_server:query_workspaces()

for _, ws in ipairs(workspaces) do
	local ws_name = ws.workspace
	local icon, color
	if ws_name == focused_space then
		icon, color = icons.focused_space, colors.theme.c8
	else
		icon, color = icons.space, colors.theme.fg
	end
	local space = Sbar.add("item", ws_name, {
		icon = {
			string = icon,
			color = color,
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
		click_script = "aerospace workspace " .. "--fail-if-noop " .. ws_name .. " 2>/dev/null",
	})
	spaces[ws_name] = space
	space:subscribe("mouse.clicked", function()
		local begin_set = {
			y_offset = -2,
		}
		local end_set = {
			y_offset = 0,
		}
		animations.custom_animaiton(
			space,
			settings.base_animation,
			settings.base_animation_duration,
			begin_set,
			end_set
		)
	end)
	space:subscribe("mouse.entered", function()
		animations.base_hover_animation(space)
	end)
	space:subscribe("mouse.exited", function()
		animations.base_leave_hover_animation(space)
	end)
end

local space_subscriber = Sbar.add("item", {
	drawing = false,
	updates = true,
})

space_subscriber:subscribe("aerospace_workspace_change", function(env)
	local current_space = env.FOCUSED_WORKSPACE
	local prev_space = env.PREV_WORKSPACE
	spaces[prev_space]:set({ icon = {
		string = icons.space,
		color = colors.theme.fg,
	} })
	spaces[current_space]:set({ icon = {
		string = icons.focused_space,
		color = colors.theme.c8,
	} })
end)
