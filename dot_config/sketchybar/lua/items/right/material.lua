local material = require("material")
local colors = require("colors")
local settings = require("settings")
local busy = false

local button = Sbar.add("item", "material", {
	position = "right",
	background = { padding_left = 0, padding_right = 0 },
	icon = {
		string = material.glass and "◈" or "■",
		color = colors.theme.c6,
		width = settings.item_height,
		align = "center",
		padding_left = 0,
		padding_right = 0,
	},
	label = { drawing = false },
})

button:set({ padding_left = settings.group_paddings, padding_right = settings.group_paddings })

button:subscribe("mouse.clicked", function()
	if busy then
		return
	end
	busy = true
	button:set({ icon = { string = "…" } })
	Sbar.exec('"$HOME/.local/bin/matheme-material" toggle 2>&1', function(output, code)
		busy = false
		if code ~= 0 then
			button:set({ icon = { string = "!" } })
			print(output)
		end
	end)
end)
