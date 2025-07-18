local theme_name = arg[1]
local home_dir = os.getenv("HOME") or os.getenv("USERPROFILE")
local info = dofile(home_dir .. "/.config/matheme/themes/" .. theme_name .. ".lua")
local base_16 = info.base_16

local format = function(lines, color, name)
	table.insert(lines, string.format("  %s = 0xff%s,", name, color:sub(2)))
end

-- stylua: ignore start
local palette_order = {
	"base00", "base01", "base02", "base03", "base04", "base05", "base06", "base07",
	"base08", "base09", "base0A", "base0B", "base0C", "base0D", "base0E", "base0F"
}
-- stylua: ignore end

local lines = {}

table.insert(lines, "return {")
for i = 0, 15 do
  format(lines, base_16[palette_order[i + 1]], "c" .. i)
end
format(lines, base_16["base00"], "bg")
format(lines, base_16["base05"], "fg")
table.insert(lines, "}")

os.execute("mkdir -p /tmp/matheme")
local fp, err = io.open("/tmp/matheme/sketchybar_theme.lua", "w")
if not fp then
	error("Cannot open file for writing: " .. err)
end
fp:write(table.concat(lines, "\n"))
fp:close()
