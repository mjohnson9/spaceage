include("sv_resources.lua")

include("shared.lua")

include("sv_planets.lua")

function GM:InitPostEntity()
	GAMEMODE:CreatePlanets()
end
