-- Copyright (C) Charles Leasure, Mark Dietzer, and Michael Johnson d.b.a SpaceAge - All Rights Reserved
-- See LICENSE file for more information.

-- clientside resource includes
include("sv_resources.lua")

-- metatable includes
include("metatables/sv_entity.lua")
include("metatables/sv_player.lua")

-- shared include
include("shared.lua")

-- misc includes
include("sv_planets.lua")

function GM:InitPostEntity()
	self.BaseClass.InitPostEntity(self)

	self:CreatePlanets()
end

function GM:OnEntityCreated(ent)
	self.BaseClass.OnEntityCreated(ent)

	ent:InitializeSpaceAge()
end

-- Called the very first time that a player spawns
function GM:PlayerInitialSpawn(ply)
	self.BaseClass.PlayerInitialSpawn(self, ply)

	-- initialize persistent SpaceAge variables
	ply:InitializeSpaceAge()
end

-- Called every time a player spawns
function GM:PlayerSpawn(ply)
	self.BaseClass.PlayerSpawn(self, ply)

	-- Take over the player hooks with our own
	player_manager.SetPlayerClass(ply, "player_spaceage")
end

-- Called after the map is cleaned up.
function GM:PostCleanupMap()
	-- Reset everyone's planet list
	for _, ply in ipairs(player.GetAll()) do
		ply.planets:clear()
	end

	-- Recreate the planets because they've now been removed
	self:CreatePlanets()
end
