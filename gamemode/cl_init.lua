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

	if not ent:IsPlayer() then
		return
	end
end
