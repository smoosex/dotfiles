local wallpaper = assert(arg[1], "wallpaper is required")
local home_dir = os.getenv("HOME")
local wallpaper_file = home_dir .. "/.config/matheme/wallpaper/" .. wallpaper

local raw_osascript = string.format([[
osascript -e "tell application \"Finder\" to set desktop picture to POSIX file \"%s\""
]], wallpaper_file)

os.execute(raw_osascript)

