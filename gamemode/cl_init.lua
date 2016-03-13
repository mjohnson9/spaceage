-- metatable includes
include("metatables/player_cl.lua")

-- shared include
include("shared.lua")

-- misc includes
include("cl_hud.lua")

function GM:Initialize()
	self.BaseClass.Initialize(self)
end

function GM:InitPostEntity()
	self.BaseClass.InitPostEntity(self)

	self.LocalPlayer = LocalPlayer()
end

function GM:OnEntityCreated(ent)
	self.BaseClass.OnEntityCreated(ent)

	if ent:IsPlayer() then
		-- hotfix for https://github.com/Facepunch/garrysmod-issues/issues/892
		ent:InstallDataTable()
		player_manager.RunClass(ent, "SetupDataTables")
	end
end
