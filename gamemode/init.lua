-- clientside resource includes
include("sv_resources.lua")

-- metatable includes
include("metatables/player_sv.lua")

-- shared include
include("shared.lua")

-- misc includes
include("sv_planets.lua")

function GM:InitPostEntity()
	self.BaseClass.InitPostEntity(self)

	self:CreatePlanets()
end

function GM:PlayerSpawn(ply)
	self.BaseClass.PlayerSpawn(self, ply)

	player_manager.SetPlayerClass(ply, "player_spaceage")
end
