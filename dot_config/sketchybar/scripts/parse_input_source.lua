local M = {}

local popen = io.popen
local match = string.match
local gsub  = string.gsub
local cjson_ok, cjson = pcall(require, "cjson")

local function trim(s)
  return (gsub(s, "^%s*(.-)%s*$", "%1"))
end

local function parse_with_regex()
  local cmd = [[defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleSelectedInputSources 2>/dev/null]]
  local h = popen(cmd)
  if not h then return "" end
  local txt = h:read("*a")
  h:close()

  local mode = match(txt, '"Input Mode"%s*=%s*"com%.apple%.inputmethod%.SCIM%.([^"]+)"')
           or match(txt, '"KeyboardLayout Name"%s*=%s*"?([^";]-)"?;')
  return mode and trim(mode) or ""
end

function M.parse_input_source()
  if not cjson_ok then
    return parse_with_regex()
  end

  local cmd = [[plutil -convert json -o - ~/Library/Preferences/com.apple.HIToolbox.plist 2>&1]]
  local proc = popen(cmd)
  if not proc then
    return parse_with_regex()
  end

  local raw = proc:read("*a")
  proc:close()

  if raw:match("invalid object in plist") then
    return parse_with_regex()
  end

  local ok, data = pcall(cjson.decode, raw)
  if not ok or type(data) ~= "table" then
    return parse_with_regex()
  end

  local sources = data.AppleSelectedInputSources
  if type(sources) ~= "table" then
    return parse_with_regex()
  end

  for _, entry in ipairs(sources) do
    if entry["Input Mode"] then
      local m = entry["Input Mode"]:match("com%.apple%.inputmethod%.SCIM%.(.+)")
      if m and #m > 0 then
        return trim(m)
      end
    elseif entry["KeyboardLayout Name"] then
      return trim(entry["KeyboardLayout Name"])
    end
  end

  return ""
end

return M
