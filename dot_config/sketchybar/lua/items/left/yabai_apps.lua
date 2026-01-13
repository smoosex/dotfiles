local colors = require("colors")
local animations = require("animations")
local utils = require("lua.utils")

local apps = {}

local draw_apps = function()
	Sbar.exec("sleep 0.02s && yabai -m query --windows --space", function(result, _)
		for _, w in ipairs(result) do
			if w["is-visible"] then
				local unique_id = "app-" .. tostring(w.id)
				local is_focused = w["has-focus"]
				local app = Sbar.add("item", unique_id, {
					icon = { drawing = false },
					label = {
						string = utils.get_app_icon(w.app),
						font = "sketchybar-app-font:Regular:14.0",
						highlight = is_focused,
						highlight_color = colors.theme.c8,
					},
					click_script = "yabai -m window --focus " .. w.id,
				})
				apps[unique_id] = app
				app:subscribe("mouse.clicked", function()
					animations.base_click_animation(app)
				end)
			end
		end
	end)
end

-- init
draw_apps()
-- end init

local apps_subscriber = Sbar.add("item", {
	drawing = false,
	updates = true,
})

local handle_apps_change = function()
	-- NOTE: sleep is required to avoid yabai query previous space when switching app between spaces
	Sbar.exec("sleep 0.02 && yabai -m query --windows --space", function(result, _)
		-- 0. 数据解析与安全检查
		local windows = result
		if #windows == 0 then
			for id, _ in pairs(apps) do
				Sbar.remove(id)
				apps[id] = nil
			end
		end

		-- 用于记录本次查询中存在的窗口 ID
		local current_window_ids = {}

		-- 1. 遍历新数据：更新旧的，添加新的
		for _, w in ipairs(windows) do
			if w["is-visible"] then
				local unique_id = "app-" .. tostring(w.id)
				local is_focused = w["has-focus"]

				-- 标记这个 ID 为“存活”
				current_window_ids[unique_id] = true

				if apps[unique_id] then
					-- 【情况 A：已存在】
					-- 仅更新高亮状态，不移除，这样位置就不会变
					apps[unique_id]:set({
						label = { highlight = is_focused },
					})
				else
					-- 【情况 B：新窗口】
					-- 创建新图标，默认会添加到现有列表的末尾
					local app_name = w.app or "Unknown"
					local app = Sbar.add("item", unique_id, {
						icon = { drawing = false },
						label = {
							string = utils.get_app_icon(app_name),
							font = "sketchybar-app-font:Regular:14.0",
							highlight = is_focused,
							highlight_color = colors.theme.c8,
						},
						click_script = "yabai -m window --focus " .. w.id,
					})

					apps[unique_id] = app

					app:subscribe("mouse.clicked", function()
						animations.base_click_animation(app)
					end)
				end
			end
		end

		-- 2. 清理过期数据
		-- 遍历本地缓存 apps，如果某个 ID 在刚才的 current_window_ids 里没找到，说明窗口关了
		for id, _ in pairs(apps) do
			if not current_window_ids[id] then
				Sbar.remove(id)
				apps[id] = nil -- 必须置空，从 Lua 表中移除
			end
		end
	end)
end

apps_subscriber:subscribe("yabai_window_change", function(_)
	handle_apps_change()
end)
