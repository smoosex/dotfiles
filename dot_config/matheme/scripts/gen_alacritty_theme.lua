local theme_name = arg[1]
local home_dir = os.getenv("HOME") or os.getenv("USERPROFILE")
local info = dofile(home_dir .. "/.config/matheme/themes/" .. theme_name .. ".lua")
local base_16 = info.base_16

local lines = {}

local function format(name, kvs)
	table.insert(lines, "[" .. name .. "]")
	for _, kv in ipairs(kvs) do
		local field, color_key = kv[1], kv[2]
		table.insert(lines, string.format('%s = "%s"', field, base_16[color_key]))
	end
	table.insert(lines, "")
end

format("colors.primary", {
	{ "background", "base00" },
	{ "foreground", "base05" },
	{ "dim_foreground", "base04" },
	{ "bright_foreground", "base06" },
})

format("colors.cursor", {
	{ "text", "base00" },
	{ "cursor", "base05" },
})

format("colors.vi_mode_cursor", {
	{ "text", "base00" },
	{ "cursor", "base05" },
})

format("colors.search.matches", {
	{ "foreground", "base00" },
	{ "background", "base0B" },
})

format("colors.search.focused_match", {
	{ "foreground", "base00" },
	{ "background", "base0D" },
})

format("colors.footer_bar", {
	{ "foreground", "base00" },
	{ "background", "base0B" },
})

format("colors.hints.start", {
	{ "foreground", "base00" },
	{ "background", "base0A" },
})

format("colors.hints.end", {
	{ "foreground", "base00" },
	{ "background", "base09" },
})

format("colors.selection", {
	{ "text", "base00" },
	{ "background", "base05" },
})

format("colors.normal", {
	{ "black", "base01" },
	{ "red", "base08" },
	{ "green", "base0B" },
	{ "yellow", "base0A" },
	{ "blue", "base0D" },
	{ "magenta", "base0E" },
	{ "cyan", "base0C" },
	{ "white", "base05" },
})

format("colors.bright", {
	{ "black", "base03" },
	{ "red", "base08" },
	{ "green", "base0B" },
	{ "yellow", "base0A" },
	{ "blue", "base0D" },
	{ "magenta", "base0E" },
	{ "cyan", "base0C" },
	{ "white", "base07" },
})

-- Optional indexed_colors
if base_16.base0F then
	table.insert(lines, "[[colors.indexed_colors]]")
	table.insert(lines, "index = 16")
	table.insert(lines, string.format('color = "%s"', base_16.base0F))
	table.insert(lines, "")
end

os.execute("mkdir -p /tmp/matheme")
local fp, err = io.open("/tmp/matheme/alacritty_theme.toml", "w")
if not fp then
	error("Cannot open file for writing: " .. err)
end
fp:write(table.concat(lines, "\n"))
fp:close()
