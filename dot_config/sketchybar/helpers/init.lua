-- Add the sketchybar module to the package cpath
package.cpath = package.cpath .. ";/Users/" .. os.getenv("USER") .. "/.local/share/sketchybar_lua/?.so"

local cache = os.getenv("HOME") .. "/.cache/sketchybar"
os.execute('mkdir -p "' .. cache .. '" && '
	.. 'if [ ! -x "' .. cache .. '/display-info" ] || [ helpers/display_info.m -nt "' .. cache .. '/display-info" ]; then '
	.. '/usr/bin/clang -fobjc-arc -framework AppKit -framework CoreGraphics helpers/display_info.m -o "'
	.. cache .. '/display-info"; fi')
