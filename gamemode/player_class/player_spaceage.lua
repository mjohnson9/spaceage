DEFINE_BASECLASS("player_sandbox")

local PLAYER = {}

function PLAYER:SetupDataTables()
	BaseClass.SetupDataTables(self)
	self.Player:NetworkVar("String", 0, "AreaName")
end

player_manager.RegisterClass("player_spaceage", PLAYER, "player_sandbox")
