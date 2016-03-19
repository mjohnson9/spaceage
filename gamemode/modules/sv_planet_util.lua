module("planet_util")

function compare(planet1, planet2)
	if planet1:GetPlanetPriority() < planet2:GetPlanetPriority() then
		return true
	end

	return planet1:EntIndex() < planet2:EntIndex()
end
