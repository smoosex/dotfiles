local colors = require("colors")
local icons = require("icons")
local animations = require("animations")
local settings = require("settings")

local popup_width = 200

local volume_slider = Sbar.add("slider", "volume.slider", 0, {
  width = 0,
	position = "right",
	slider = {
		highlight_color = colors.theme.c9,
		background = {
			height = 10,
			corner_radius = 6,
			color = colors.theme.c4,
		},
		knob = {
			drawing = false,
		},
	},
	padding_left = -5,
	padding_right = -5,
	click_script = 'osascript -e "set volume output volume $PERCENTAGE"',
	background = {
		shadow = {
			drawing = false,
		},
	},
})

local volume_icon = Sbar.add("item", "volume", {
	position = "right",
	icon = {
		drawing = true,
		color = colors.theme.c9,
		padding_left = 0,
		padding_right = 0,
	},
	label = {
		drawing = false,
	},
	padding_left = 0,
	padding_right = 0,
	background = {
		shadow = {
			drawing = false,
		},
	},
})

Sbar.add("item", {
	position = "popup." .. volume_icon.name,
	drawing = false,
})

volume_icon:subscribe("volume_change", function(env)
	local icon = icons.volume._0
	local volume = tonumber(env.INFO)
	if volume > 60 then
		icon = icons.volume._100
	elseif volume > 30 then
		icon = icons.volume._66
	elseif volume > 10 then
		icon = icons.volume._33
	elseif volume > 0 then
		icon = icons.volume._10
	end

	volume_icon:set({ icon = icon })
	volume_slider:set({ slider = { percentage = volume } })
end)

local function volume_collapse_details()
	local drawing = volume_icon:query().popup.drawing == "on"
	if not drawing then
		return
	end
	volume_icon:set({ popup = { drawing = false } })
	Sbar.remove("/volume.device\\.*/")
end

local current_audio_device = "None"
local function volume_toggle_details(env)
	if env.BUTTON == "right" then
		Sbar.exec("open /System/Library/PreferencePanes/Sound.prefpane")
		return
	end

	local should_draw = volume_icon:query().popup.drawing == "off"
	if should_draw then
		volume_icon:set({ popup = { drawing = true } })
		Sbar.exec("SwitchAudioSource -t output -c", function(result)
			current_audio_device = result:sub(1, -2)
			Sbar.exec("SwitchAudioSource -a -t output", function(available)
				local current = current_audio_device
				local color = colors.theme.fg
				local counter = 0

				for device in string.gmatch(available, "[^\r\n]+") do
					if current == device then
						color = colors.theme.c9
					end
					Sbar.add("item", "volume.device." .. counter, {
						position = "popup." .. volume_icon.name,
						width = popup_width,
						align = "left",
						label = {
							string = device,
							color = color,
						},
						background = { drawing = false },
						click_script = 'SwitchAudioSource -s "'
							.. device
							.. '" && sketchybar --set /volume.device\\.*/ label.color='
							.. colors.theme.c9
							.. " --set $NAME label.color="
							.. colors.theme.c9,
					})
					counter = counter + 1
				end
			end)
		end)
	else
		volume_collapse_details()
	end
end

volume_icon:subscribe("mouse.clicked", function(env)
	local slider_width = volume_slider:query().slider.width
	local begin_set = { width = 0, slider = { width = 0 } }
	local end_set = { width = 60, slider = { width = 50 } }
	if tonumber(slider_width) > 0 then
		begin_set, end_set = end_set, begin_set
	end
	animations.custom_animaiton(volume_slider, settings.base_animation, 20, begin_set, end_set)
  volume_toggle_details(env)
end)

return volume_icon
