local settings = require("settings")

require("items.left.logo")

Sbar.add("item", "logo.padding.left", {
	position = "left",
	width = settings.group_paddings,
	icon = { drawing = false },
	label = { drawing = false },
	background = { drawing = false },
})

-- require("items.left.aerospace_sapce")
require("items.left.yabai_space")

Sbar.add("item", "space.padding.left", {
	position = "left",
	width = settings.group_paddings,
	icon = { drawing = false },
	label = { drawing = false },
	background = { drawing = false },
})

-- require("items.left.asrospace_apps")
require("items.left.yabai_apps")
