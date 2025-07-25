local theme_name = assert(arg[1], "theme is required")
local home_dir = os.getenv("HOME")
local thmeme_dir = home_dir .. "/.config/matheme/themes"
local info = dofile(thmeme_dir .. "/" .. theme_name .. ".lua")
local is_dark_mode = info.type == "dark" and "yes" or "no"

local raw_osascript = string.format([[
osascript -e "tell application \"System Events\" to tell appearance preferences to set dark mode to %s"
]], is_dark_mode)

os.execute(raw_osascript)
