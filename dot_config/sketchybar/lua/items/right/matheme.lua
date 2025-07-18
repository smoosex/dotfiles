local icons = require("icons")
local colors = require("colors")
local settings = require("settings")
local animations = require("animations")
local theme_utils = require("helpers.theme.utils")

local theme_list = theme_utils.get_matheme_list()

local popup_width = 150
local pop_items = {} -- 存放 popup 子项的引用

local matheme = Sbar.add("item", "left.matheme", {
	position = "right",
	icon = {
		string = icons.palette,
		color = colors.theme.c7,
	},
	label = { drawing = false },
})

local function switch_theme(env)
	theme_utils.switch_theme(env.NAME)
end

local function on_hover_item(env)
	pop_items[env.NAME]:set({
		background = {
			color = colors.theme.c3,
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
			corner_radius = 3,
			height = 30,
			drawing = false,
		},
	})
	pop_item:subscribe("mouse.clicked", switch_theme)
	pop_item:subscribe("mouse.entered", on_hover_item)
	pop_item:subscribe("mouse.exited", on_hover_leave_item)
  pop_items[theme_list[i]] = pop_item
end
