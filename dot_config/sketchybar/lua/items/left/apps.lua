local socket = require("socket")
local aerospace_server = Sbar.aerospace
local colors = require("colors")
local animations = require("animations")
local cjson = require("cjson")
local app_icons = require("helpers.icon_map")

local json = cjson.new()

local apps = {}
local icon_cache = {}
local function getIconForApp(appName)
	if icon_cache[appName] then
		return icon_cache[appName]
	end
	local lookup = app_icons[appName]
	local icon = ((lookup == nil) and app_icons["Default"] or lookup)
	icon_cache[appName] = icon
	return icon
end

local draw_apps = function(workspace)
	local windows = aerospace_server:list_windows(workspace)
	local windows_table = json.decode(windows)
	for _, w in ipairs(windows_table) do
		local unique_id = w["app-name"] .. "-" .. w["window-id"]
		local app = Sbar.add("item", unique_id, {
			icon = { drawing = false },
			label = {
				string = getIconForApp(w["app-name"]),
				font = "sketchybar-app-font:Regular:14.0",
				highlight = false,
				highlight_color = colors.theme.c8,
			},
			click_script = "aerospace focus --window-id " .. math.floor(w["window-id"]),
		})
		apps[unique_id] = app
		app:subscribe("mouse.clicked", function()
			animations.base_click_animation(app)
		end)
	end
end

local highlight_app = function(window)
	if window == nil or window == "" then
		return
	end
	local focused_windows_table = json.decode(window)
	local focused_app_unique_id = focused_windows_table[1]["app-name"] .. "-" .. focused_windows_table[1]["window-id"]
	for k, app in pairs(apps) do
		if k == focused_app_unique_id then
			app:set({ label = { highlight = true } })
		else
			app:set({ label = { highlight = false } })
		end
	end
end

-- init
local focused_space = aerospace_server:list_current()
draw_apps(focused_space)
local focused_windows = aerospace_server:focused_window()
highlight_app(focused_windows)
-- end init

local apps_subscriber = Sbar.add("item", {
	drawing = false,
	updates = true,
})

apps_subscriber:subscribe("aerospace_workspace_change", function(env)
	for _, app in pairs(apps) do
		Sbar.remove(app.name)
		apps = {}
	end
	draw_apps(env.FOCUSED_WORKSPACE)
end)

apps_subscriber:subscribe("aerospace_focus_change", function()
	socket.sleep(0.01)
	local current_space = aerospace_server:list_current()
	local windows = aerospace_server:list_windows(current_space)
	local windows_table = json.decode(windows)
	local update_apps = {}
	for _, w in ipairs(windows_table) do
		local unique_id = w["app-name"] .. "-" .. w["window-id"]

		update_apps[unique_id] = true
		if apps[unique_id] == nil then
			local app = Sbar.add("item", unique_id, {
				icon = { drawing = false },
				label = {
					string = getIconForApp(w["app-name"]),
					font = "sketchybar-app-font:Regular:14.0",
					highlight = false,
					highlight_color = colors.theme.c8,
				},
				click_script = "aerospace focus --window-id " .. math.floor(w["window-id"]),
			})
			apps[unique_id] = app
		end
	end
	for k, _ in pairs(apps) do
		if update_apps[k] == nil then
			Sbar.remove(k)
			apps[k] = nil
		end
	end

	local current_windows = aerospace_server:focused_window()
	highlight_app(current_windows)
end)
