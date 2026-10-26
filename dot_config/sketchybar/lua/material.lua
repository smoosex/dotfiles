local M = { mode = "solid" }
local file = io.open(os.getenv("HOME") .. "/.local/state/matheme/material", "r")
if file then
	M.mode = file:read("*l")
	file:close()
end
M.glass = M.mode == "glass"
M.blur_radius = M.glass and 20 or 0

function M.background(color)
	if not M.glass then
		return color
	end
	return (color & 0x00ffffff) | (math.floor(0.72 * 255) << 24)
end

return M
