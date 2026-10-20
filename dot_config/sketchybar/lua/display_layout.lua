local settings = require("settings")
local rebuild_backgrounds = require("items.notch_background")
local cli = "/opt/homebrew/bin/rift-cli"
local busy = false
local background_signature

local function sync_gaps(displays)
	Sbar.exec(cli .. " execute config get", function(config, code)
		if code ~= 0 or type(config) ~= "table" then
			return
		end
		local overrides = config.settings.layout.gaps.per_display or {}
		for _, display in ipairs(displays) do
			local top = settings.bar_position == "top"
				and math.max(0, settings.bar_y_offset + settings.bar_height + 6 - display.top_inset) or 8
			local bottom = settings.bar_position == "bottom"
				and settings.bar_y_offset + settings.bar_height + 8 or 8
			local current = (overrides[display.uuid] or {}).outer or {}
			if current.top ~= top or current.bottom ~= bottom or current.left ~= 8 or current.right ~= 8 then
				local value = string.format('{"top":%d,"bottom":%d,"left":8,"right":8}', top, bottom)
				Sbar.exec(cli .. " execute config set settings.layout.gaps.per_display."
					.. display.uuid .. ".outer '" .. value .. "'")
			end
		end
	end)
end

local function refresh()
	if busy then
		return
	end
	busy = true
	Sbar.exec('"' .. os.getenv("HOME") .. '/.cache/sketchybar/display-info"', function(screens, screen_code)
		if screen_code ~= 0 or type(screens) ~= "table" then
			busy = false
			return
		end
		Sbar.exec("sketchybar --query displays", function(bars, bar_code)
			if bar_code ~= 0 or type(bars) ~= "table" then
				busy = false
				return
			end
			Sbar.exec(cli .. " query displays", function(rift_displays, rift_code)
				busy = false
				if rift_code ~= 0 or type(rift_displays) ~= "table" then
					return
				end
				local displays, signature = {}, {}
				for _, screen in ipairs(screens) do
					for _, bar in ipairs(bars) do
						if bar.UUID == screen.uuid then
							for _, rift in ipairs(rift_displays) do
								if rift.uuid == screen.uuid then
									local display = {
										uuid = screen.uuid,
										id = bar["arrangement-id"],
										notch_width = screen.notch_width,
										top_inset = math.max(0, rift.frame.origin.y - screen.top),
									}
									displays[#displays + 1] = display
									signature[#signature + 1] = display.uuid .. ":" .. display.id .. ":"
										.. display.notch_width .. ":" .. bar.frame.w
								end
							end
						end
					end
				end
				local next_signature = table.concat(signature, "|")
				if next_signature ~= background_signature then
					rebuild_backgrounds(displays)
					background_signature = next_signature
				end
				sync_gaps(displays)
			end)
		end)
	end)
end

local subscriber = Sbar.add("item", "display.layout.subscriber", {
	drawing = false,
	updates = true,
	update_freq = 10,
})
subscriber:subscribe({ "display_change", "space_change", "system_woke", "routine", "forced" }, refresh)
refresh()
