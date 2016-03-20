-- Copyright (C) Charles Leasure, Mark Dietzer, and Michael Johnson d.b.a SpaceAge - All Rights Reserved
-- See LICENSE file for more information.

-- Called every time that an entity is created
function HOOKS:OnEntityCreated(ent)
	-- Initialize SpaceAge-specific members
	ent:InitializeSpaceAge()
end

-- Called whenever a player spawns and is ready to receive their loadout
function HOOKS:PlayerLoadout(ply)
	-- Take over the player hooks with our own
	-- We do this here instead of in PlayerSpawn because sandbox will override
	-- us if we do it in PlayerSpawn
	player_manager.SetPlayerClass(ply, "player_spaceage")

	-- Give them a physgun
	ply:Give("weapon_physgun")

	-- Give them a tool gun
	ply:Give("gmod_tool")

	-- Start with physgun selected
	ply:SelectWeapon("weapon_physgun")

	return true -- prevent the default loadout
end
