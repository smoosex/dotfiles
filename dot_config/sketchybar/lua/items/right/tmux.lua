local settings = require("settings")
local icons = require("icons")
local colors = require("colors")
local tmux = require("tmux")

local num_2_icon = {
	[1] = icons.number.one,
	[2] = icons.number.two,
	[3] = icons.number.three,
	[4] = icons.number.four,
	[5] = icons.number.five,
	[6] = icons.number.six,
	[7] = icons.number.seven,
	[8] = icons.number.eight,
	[9] = icons.number.nine,
}

local windows_items = {}

local get_current_session = function()
	local sessions = tmux.get_sessions()
	if sessions == nil then
		return nil
	end
	local current_session = {}
	for _, session in ipairs(sessions) do
		if session.attached == "1" then
			current_session = session
			break
		end
	end
	return current_session
end

local clear_tmux_items = function(window_items)
	Sbar.remove("bracket.tmux.padding.right")
	Sbar.remove("bracket.tmux")
	Sbar.remove("tmux.session")
	Sbar.remove("tmux.divider")
	for k, _ in pairs(window_items) do
		Sbar.remove("tmux.window." .. k)
		window_items[k] = nil
	end
end

local draw_tmux = function()
	Sbar.add("item", "bracket.tmux.padding.right", {
		position = "right",
		width = settings.group_paddings,
    icon = { drawing = false },
    label = { drawing = false },
    background = { drawing = false },
	})

	local current_session = get_current_session()
	if current_session == nil then
		return
	end
	local tmux_windows = tmux.get_windows(current_session.name)
	if tmux_windows == nil then
		return
	end
	for i = tonumber(current_session.windows), 1, -1 do
		local w = tmux_windows[tostring(i)]
		local label = current_session.active_window ~= w.index and w.index or w.name
		local is_show_lable = current_session.active_window == w.index and true or false
		local hightlight = current_session.active_window == w.index and true or false
		local w_item = Sbar.add("item", "tmux.window." .. w.index, {
			position = "right",
			icon = {
				string = num_2_icon[i],
				font = {
					family = settings.font.text,
					style = settings.font.style_map["Bold"],
					size = settings.font.size + 4,
				},
				highlight = hightlight,
			},
			label = {
				drawing = is_show_lable,
				string = label,
				y_offset = 1,
			},
			background = {
				shadow = {
					drawing = false,
				},
				color = colors.theme.c4,
			},
			-- padding_left = 0,
			padding_right = 0,
		})
		windows_items[w.index] = w_item
	end

	local divider = Sbar.add("item", "tmux.divider", {
		position = "right",
		icon = {
			string = "",
			font = {
				size = settings.font.size + 2,
			},
		},
		label = {
			drawing = false,
		},
		background = {
			shadow = {
				drawing = false,
			},
		},
		padding_right = 0,
		padding_left = 0,
	})

	local session_item = Sbar.add("item", "tmux.session", {
		position = "right",
		icon = {
			string = icons.tmux,
			color = colors.theme.c0,
		},
		label = {
			string = current_session.name,
			y_offset = 1,
			color = colors.theme.c0,
		},
		background = {
			shadow = {
				drawing = false,
			},
			color = colors.theme.c8,
		},
		padding_right = 0,
		padding_left = 0,
	})

	local bracket_members = { session_item.name, divider.name }
	for _, v in pairs(windows_items) do
		table.insert(bracket_members, v.name)
	end
	Sbar.add("bracket", "bracket.tmux", bracket_members, {
		background = { color = colors.theme.c2, shadow = { drawing = false } },
	})
end

local tmux_subscriber = Sbar.add("item", "tmux.subscriber", {
	drawing = false,
	updates = true,
})

tmux_subscriber:subscribe("tmux_event", function()
	clear_tmux_items(windows_items)
	draw_tmux()
end)

draw_tmux()
