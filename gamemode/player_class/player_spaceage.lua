-- Copyright (C) Charles Leasure, Mark Dietzer, and Michael Johnson d.b.a SpaceAge - All Rights Reserved
-- See LICENSE file for more information.

DEFINE_BASECLASS("player_sandbox")

local PLAYER = {}

function PLAYER:SetupDataTables()
	BaseClass.SetupDataTables(self)

	hook.Call("SetupPlayerDatatables", GAMEMODE or GM, self.Player)
	hook.Call("PostSetupPlayerDatatables", GAMEMODE or GM, self.Player)
end

player_manager.RegisterClass("player_spaceage", PLAYER, "player_sandbox")
