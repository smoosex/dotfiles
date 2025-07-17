local icons = require("icons")
local colors = require("colors")
local settings = require("settings")
local animations = require("animations")
local theme_utils = require("helpers.theme.utils")

local theme_list = theme_utils.get_matheme_list()

local popup_width = 150
local popup_height = 20
local visible_count = 7 -- 同时显示 5 行
local scroll_index = 1 -- 滚动起始索引
local pop_items = {} -- 存放 popup 子项的引用

local matheme = Sbar.add("item", "left.matheme", {
	position = "right",
	icon = {
		string = icons.palette,
		color = colors.theme.c7,
	},
	label = { drawing = false },
})

local function update_popup()
	-- 限定最小最大范围
	local max_start = #theme_list - visible_count + 1
	scroll_index = math.max(1, math.min(scroll_index, max_start))

	for i, item in ipairs(pop_items) do
		local idx = scroll_index + i - 1
		local theme = theme_list[idx] or ""
		-- 更新 label 文本
		item:set({
			label = {
				string = theme,
			},
		})
		-- 如果越界可以隐藏该行（可选）
		item:set({ drawing = (theme ~= "" and true or false) })
	end
end

-- 滚动事件
local function on_scroll(env)
	local delta = env.INFO.delta or 0
	-- 根据你的鼠标滚动方向增减索引（正负符号可以根据实际测试调整）
	if delta < 0 then
		scroll_index = scroll_index + 1
	elseif delta > 0 then
		scroll_index = scroll_index - 1
	end
	update_popup()
end

local function split(str, sep)
	local t = {}
	for part in string.gmatch(str, "([^" .. sep .. "]+)") do
		table.insert(t, part)
	end
	return t
end

-- 切换主题
local function switch_theme(env)
	local id = split(env.NAME, ".")[2]
	local theme = theme_list[scroll_index + tonumber(id) - 1]
	theme_utils.switch_theme(theme)
end

-- hover 事件
local function on_hover(env)
	local id = split(env.NAME, ".")[2]
	pop_items[tonumber(id)]:set({
		background = {
			color = colors.theme.c3,
		},
	})
end

-- hover leave
local function on_hover_leave(env)
	local id = split(env.NAME, ".")[2]
	pop_items[tonumber(id)]:set({
		background = {
			drawing = false,
		},
	})
end

local function toggle_theme_picker()
	animations.base_click_animation(matheme)
	local drawing = matheme:query().popup.drawing
	matheme:set({ popup = { drawing = (drawing == "off" and true or false) } })
end

local function on_hover_theme_picker()
	Sbar.animate(settings.base_animation, settings.base_animation_duration, function()
		matheme:set({ background = { color = colors.theme.c9 } })
	end)
end

local function on_hover_leave_theme_picker()
	Sbar.animate(settings.base_animation, settings.base_animation_duration, function()
		matheme:set({ background = { color = colors.theme.c2 } })
	end)
end

matheme:subscribe("mouse.entered", on_hover_theme_picker)
matheme:subscribe("mouse.exited", on_hover_leave_theme_picker)
matheme:subscribe("mouse.clicked", toggle_theme_picker)

for i = 1, visible_count do
	local id = "pop_item." .. i
	local pop_item = Sbar.add("item", id, {
		position = "popup." .. matheme.name,
		icon = {
			string = icons.palette,
		},
		label = {
			string = theme_list[scroll_index + i - 1] or "",
			font = {
				style = settings.font.style_map["Bold"],
			},
		},
		scroll_texts = true,
		width = popup_width,
		background = {
			corner_radius = 3,
			height = 30,
			drawing = false,
		},
	})
	pop_item:subscribe("mouse.scrolled", on_scroll)
	pop_item:subscribe("mouse.clicked", switch_theme)
	pop_item:subscribe("mouse.entered", on_hover)
	pop_item:subscribe("mouse.exited", on_hover_leave)
	table.insert(pop_items, pop_item)
end
