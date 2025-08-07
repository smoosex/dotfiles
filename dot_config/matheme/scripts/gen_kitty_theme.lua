local theme_name = arg[1]
local home_dir = os.getenv("HOME") or os.getenv("USERPROFILE")
local info = dofile(home_dir .. "/.config/matheme/themes/" .. theme_name .. ".lua")
local base_16 = info.base_16

local format = function(lines, color, name)
	table.insert(lines, string.format("%s %s", name, color))
end

-- stylua: ignore start
local palette_order = {
	"base01", "base08", "base0B", "base0A", "base0D", "base0E", "base0C", "base05",
	"base03", "base08", "base0B", "base0A", "base0D", "base0E", "base0C", "base06",
}
-- stylua: ignore end

local lines = {}
for i = 0, 15 do
  format(lines, base_16[palette_order[i + 1]], "color" .. i)
end
format(lines, base_16["base00"], "background")
format(lines, base_16["base05"], "foreground")
format(lines, base_16["base05"], "cursor")
format(lines, base_16["base00"], "cursor_text")

os.execute("mkdir -p /tmp/matheme")
local fp, err = io.open("/tmp/matheme/kitty_theme", "w")
if not fp then
	error("Cannot open file for writing: " .. err)
end
fp:write(table.concat(lines, "\n"))
