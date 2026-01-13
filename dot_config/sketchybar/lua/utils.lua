local app_icons = require("helpers.icon_map")

local M = {}

M.merge_table = function(...)
	local tables = { ... }
	assert(#tables > 1, "Need at least two tables to merge")

	local result = {}
	for idx, t in ipairs(tables) do
		assert(type(t) == "table", string.format("Parameter #%d is not a table", idx))
		for k, v in pairs(t) do
			if type(k) == "number" then
				error(
					string.format(
						"Parameter #%d contains numeric key %s; only k=v tables are allowed",
						idx,
						tostring(k)
					)
				)
			end
			result[k] = v
		end
	end

	return result
end

M.get_app_icon = function(appName)
	local lookup = app_icons[appName]
	local icon = ((lookup == nil) and app_icons["Default"] or lookup)
	return icon
end

return M
