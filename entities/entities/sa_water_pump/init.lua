AddCSLuaFile("cl_init.lua")
AddCSLuaFile("info.lua")
AddCSLuaFile("shared.lua")

include("info.lua")
include("shared.lua")

function ENT:Think()
	self:CalcThinkTime()
	if not self:ConsumeResource("Energy", 250) then
		return
	end

	self:GenerateResource("Water", 100)
end
