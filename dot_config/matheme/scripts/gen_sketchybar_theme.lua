local theme_name = arg[1]
local home_dir = os.getenv("HOME") or os.getenv("USERPROFILE")
local info = dofile(home_dir .. "/.config/matheme/themes/" .. theme_name .. ".lua")
local base_16 = info.base_16

local palette = {
	c0 = "base00",
	c1 = "base01",
	c2 = "base02",
	c3 = "base03",
	c4 = "base04",
	c5 = "base05",
	c6 = "base06",
	c7 = "base07",
	c8 = "base08",
	c9 = "base09",
	c10 = "base0A",
	c11 = "base0B",
	c12 = "base0C",
	c13 = "base0D",
	c14 = "base0E",
	c15 = "base0F",
	bg = "base00",
	fg = "base05",
}

local order = {
	"c0",
	"c1",
	"c2",
	"c3",
	"c4",
	"c5",
	"c6",
	"c7",
	"c8",
	"c9",
	"c10",
	"c11",
	"c12",
	"c13",
	"c14",
	"c15",
	"bg",
	"fg",
}

local lines = {}

table.insert(lines, "return {")
for _, k in pairs(order) do
	local v = palette[k]
	table.insert(lines, string.format("  %s = 0xff%s,", k, base_16[v]:sub(2)))
end
table.insert(lines, "}")

os.execute("mkdir -p /tmp/matheme")
local fp, err = io.open("/tmp/matheme/init.lua", "w")
if not fp then
	error("无法打开文件写入: " .. err)
end
fp:write(table.concat(lines, "\n"))
fp:close()

print("已生成 inti.lua")
