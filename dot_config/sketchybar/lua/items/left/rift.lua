local icons = require("icons")
local colors = require("colors")
local animations = require("animations")
local settings = require("settings")
local utils = require("utils")

local spaces = {}
local apps = {}
local updating = false
local pending = false
local cli = "/opt/homebrew/bin/rift-cli"

Sbar.add("event", "rift_update")

local function sync(workspaces)
	local current_spaces = {}
	local current_windows = {}
	local order = {}

	for _, workspace in ipairs(workspaces) do
		local name = "rift.space." .. workspace.index
		current_spaces[name] = true
		if not spaces[name] then
			local item = Sbar.add("item", name, {
				position = "left",
				icon = {
					font = {
						family = settings.font.text,
						style = settings.font.style_map["Bold"],
						size = settings.font.size,
					},
				},
				label = { drawing = false },
				background = { color = colors.transparent, shadow = { drawing = false } },
				padding_left = 0,
				padding_right = 0,
				click_script = cli .. " execute workspace switch " .. workspace.index,
			})
			item:subscribe("mouse.clicked", function()
				animations.custom_animaiton(
					item,
					settings.base_animation,
					settings.base_animation_duration,
					{ y_offset = -2 },
					{ y_offset = 0 }
				)
			end)
			item:subscribe("mouse.entered", function()
				animations.base_hover_animation(item)
			end)
			item:subscribe("mouse.exited", function()
				animations.base_leave_hover_animation(item)
			end)
			spaces[name] = item
		end
		spaces[name]:set({
			icon = {
				string = workspace.is_active and icons.focused_space or icons.space,
				color = workspace.is_active and colors.theme.c8 or colors.theme.fg,
			},
		})
		order[#order + 1] = "--move " .. name .. " before space.padding.left"

		if workspace.is_active then
			for _, window in ipairs(workspace.windows) do
				local id = window.id
				local window_name = "rift.app." .. id.pid .. "." .. id.idx
				current_windows[window_name] = true
				if not apps[window_name] then
					local item = Sbar.add("item", window_name, {
						position = "left",
						icon = { drawing = false },
						label = {
							string = utils.get_app_icon(window.app_name),
							font = "sketchybar-app-font:Regular:14.0",
							highlight_color = colors.theme.c8,
						},
						click_script = cli .. " execute window focus --window-id '{\"pid\":"
							.. id.pid .. ",\"idx\":" .. id.idx .. "}'",
					})
					item:subscribe("mouse.clicked", function()
						animations.base_click_animation(item)
					end)
					apps[window_name] = item
				end
				apps[window_name]:set({ label = { highlight = window.is_focused } })
			end
		end
	end

	for name in pairs(spaces) do
		if not current_spaces[name] then
			Sbar.remove(name)
			spaces[name] = nil
		end
	end
	for name in pairs(apps) do
		if not current_windows[name] then
			Sbar.remove(name)
			apps[name] = nil
		end
	end
	if #order > 0 then
		Sbar.exec("/opt/homebrew/bin/sketchybar " .. table.concat(order, " "))
	end
end

local refresh
refresh = function()
	-- Serialize queries so an older workspace response cannot overwrite a newer one.
	if updating then
		pending = true
		return
	end
	updating = true
	Sbar.exec(cli .. " query workspaces", function(result, code)
		if code == 0 and type(result) == "table" then
			sync(result)
		end
		updating = false
		if pending then
			pending = false
			refresh()
		end
	end)
end

local subscriber = Sbar.add("item", "rift.subscriber", {
	drawing = false,
	updates = true,
	update_freq = 30,
})
subscriber:subscribe({ "rift_update", "space_change", "display_change", "system_woke", "routine", "forced" }, refresh)
refresh()
