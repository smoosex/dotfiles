local icons = require("icons")
local colors = require("colors")
local settings = require("settings")
local animations = require("animations")
local theme_utils = require("helpers.theme.utils")

local theme_list = theme_utils.get_matheme_list()

local popup_width = 160
local pop_items = {} -- 存放 popup 子项的引用

local matheme = Sbar.add("item", "matheme", {
	position = "right",
	background = { padding_left = 0, padding_right = 0 },
	icon = {
		width = settings.item_height,
		align = "center",
		padding_left = 0,
		padding_right = 0,
		string = icons.palette,
		color = colors.theme.c6,
	},
	label = { drawing = false },
})

matheme:set({ padding_left = settings.group_paddings, padding_right = settings.group_paddings })

local function toggle_theme_picker()
	animations.base_click_animation(matheme)
	local drawing = matheme:query().popup.drawing
	matheme:set({ popup = { drawing = (drawing == "off" and true or false) } })
end

local function on_hover_theme_picker()
	Sbar.animate(settings.base_animation, settings.base_animation_duration, function()
		matheme:set({ icon = { color = colors.theme.c0 }, background = { color = colors.surface.c9 } })
	end)
end

local function on_hover_leave_theme_picker()
	Sbar.animate(settings.base_animation, settings.base_animation_duration, function()
		matheme:set({ icon = { color = colors.theme.c6 }, background = { color = colors.surface.c2 } })
	end)
end

matheme:subscribe("mouse.entered", on_hover_theme_picker)
matheme:subscribe("mouse.exited", on_hover_leave_theme_picker)
matheme:subscribe("mouse.clicked", toggle_theme_picker)

local function switch_theme(env)
	toggle_theme_picker()
	theme_utils.switch_theme(env.NAME)
end

local function on_hover_item(env)
	pop_items[env.NAME]:set({
		background = {
			color = colors.surface.c3,
		},
	})
end

local function on_hover_leave_item(env)
	pop_items[env.NAME]:set({
		background = {
			drawing = false,
		},
	})
end

for i = 1, #theme_list do
	local pop_item = Sbar.add("item", theme_list[i], {
		position = "popup." .. matheme.name,
		icon = {
			string = icons.palette,
		},
		label = {
			string = theme_list[i],
			font = {
				style = settings.font.style_map["Bold"],
			},
		},
		scroll_texts = true,
		width = popup_width,
		background = {
			corner_radius = 8,
			height = 30,
			drawing = false,
		},
	})
	pop_item:subscribe("mouse.clicked", switch_theme)
	pop_item:subscribe("mouse.entered", on_hover_item)
	pop_item:subscribe("mouse.exited", on_hover_leave_item)
	pop_items[theme_list[i]] = pop_item
end
