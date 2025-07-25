local M = {}

M.switch_sketchybar_bar_position = function(bar_position)
	local home_dir = os.getenv("HOME")
	local filename = home_dir .. "/.local/share/chezmoi/dot_config/sketchybar/lua/bar_position.lua"

	local f = assert(io.open(filename, "r"), "无法打开文件读取")
	local content = f:read("*a")
	f:close()

	local new_value = (bar_position == "top") and "bottom" or "top"

	local pattern = '(local%s+bar_position%s*=%s*")[^"]+(")'
	local replaced, count = content:gsub(pattern, "%1" .. new_value .. "%2", 1)
	assert(count == 1, "替换失败：没有找到匹配项")

	local tmpfile = filename .. ".tmp"
	local fo = assert(io.open(tmpfile, "w"), "无法打开临时文件写入")
	fo:write(replaced)
	fo:close()
	os.remove(filename)
	os.rename(tmpfile, filename)
end

M.switch_aerospace_bar_position = function(bar_position)
  local contrary_bar_position = (bar_position == "top") and "bottom" or "top"
	local home_dir = os.getenv("HOME")
	local path = home_dir .. "/.local/share/chezmoi/dot_config/aerospace/examples/aerospace_" .. contrary_bar_position .. ".toml"
  Sbar.exec("cp -f " .. path .. " ~/.local/share/chezmoi/dot_config/aerospace/aerospace.toml")
end

return M
