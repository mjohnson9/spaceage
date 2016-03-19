-- Copyright (C) Charles Leasure, Mark Dietzer, and Michael Johnson d.b.a SpaceAge - All Rights Reserved
-- See LICENSE file for more information.

-- Called every time that an entity is created
function HOOKS:OnEntityCreated(ent)
	ent:InitializeSpaceAge()
end

-- Called every time a player spawns
function HOOKS:PlayerSpawn(ply)
	-- Take over the player hooks with our own
	player_manager.SetPlayerClass(ply, "player_spaceage")
end
