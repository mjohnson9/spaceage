-- Copyright (C) Charles Leasure, Mark Dietzer, and Michael Johnson d.b.a SpaceAge - All Rights Reserved
-- See LICENSE file for more information.

DEFINE_BASECLASS("player_sandbox")

local PLAYER = {}

function PLAYER:SetupDataTables()
	BaseClass.SetupDataTables(self)

	self.Player:NetworkVar("String", 0, "AreaName")
	self.Player:NetworkVar("Bool", 0, "InSpace")

	if SERVER then
		self.Player:DataTablesInitialized()
	end
end

player_manager.RegisterClass("player_spaceage", PLAYER, "player_sandbox")
