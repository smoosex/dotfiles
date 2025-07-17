package.path = package.path .. ";./lua/?.lua" .. ";./lua/?/init.lua" .. ";./scripts/?.lua"

local Aerospace = require("helpers.aerospace.aerospace")
local aerospace = Aerospace.new() -- it finds the socket on its own
while not aerospace:is_initialized() do
	os.execute("sleep 0.1") -- wait for connection, not the best workaround
end

-- Require the sketchybar module
Sbar = require("sketchybar")
Sbar.aerospace = aerospace

-- Set the bar name, if you are using another bar instance than sketchybar
-- sbar.set_bar_name("bottom_bar")

-- Bundle the entire initial configuration into a single message to sketchybar
Sbar.begin_config()
Sbar.hotload(true)
require("bar")
require("default")
require("items")
Sbar.end_config()

-- Run the event loop of the sketchybar module (without this there will be no
-- callback functions executed in the lua module)
Sbar.event_loop()
