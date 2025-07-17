local M = {}

local home_dir = os.getenv("HOME")

M.get_matheme_list = function()
  local cmd = home_dir .. "/.config/sketchybar/bin/matheme ls"
	local handle = io.popen(cmd)
	if not handle then
		error("无法执行命令: " .. cmd)
	end

	local output = handle:read("*a")
	handle:close()

	-- 将每一行拆分并过滤
	local themes = {}
	for line in output:gmatch("[^\r\n]+") do
		-- 忽略空行、提示信息行和标题行
		if line ~= "" then
			themes[#themes + 1] = line
		end
	end

	return themes
end

M.switch_theme = function(theme)
	local cmd = home_dir .. "/.config/sketchybar/bin/matheme sw -t " .. theme
	os.execute(cmd)
end

return M
