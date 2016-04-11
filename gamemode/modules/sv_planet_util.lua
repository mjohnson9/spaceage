module("planet_util")

local function compare(planet1, planet2)
	local priority1 = planet1:GetPlanetPriority()
	local priority2 = planet2:GetPlanetPriority()
	if priority1 ~= priority2 then
		return priority1 < priority2
	end

	return planet1:EntIndex() < planet2:EntIndex()
end

return {
	compare = compare
}
