AddCSLuaFile("cl_init.lua")
AddCSLuaFile("info.lua")
AddCSLuaFile("shared.lua")

include("info.lua")
include("shared.lua")

function ENT:ServerInitialize()
	self:PhysicsInit(SOLID_VPHYSICS)
end
