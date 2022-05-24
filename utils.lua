
function deepToString(table)
	local function deepToStringHelper(table, indent)
		local istring = string.rep("\t", indent)
		local s = ""
		if type(table) ~= "table" then
			s = s .. istring ..  tostring( table ) .. "\n"
		else
			s = s .. istring .. "{\n"
			for k,v in pairs(table) do
				s = s .. "[" .. tostring(k) .. "]\t" .. deepToStringHelper(v, indent+1, key)
			end
			s = s .. istring .. "}\n"
		end
		return s
	end
	return deepToStringHelper(table, 0)
end