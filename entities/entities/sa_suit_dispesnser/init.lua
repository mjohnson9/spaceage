AddCSLuaFile("cl_init.lua")
AddCSLuaFile("info.lua")
AddCSLuaFile("shared.lua")

include("info.lua")
include("shared.lua")

-- cache global variables
local IsValid = IsValid
local FrameTime = FrameTime
local mathMin = math.min

function ENT:Use(ply)
	if not IsValid(ply) then
		-- we don't work for invalid entities
		return
	end

	if not ply:IsPlayer() then
		-- we only work for players
		return
	end

	local frameTime = FrameTime()

	local neededEnergy = 100 - ply:GetEnergy()
	local energyAmount = mathMin(10 * frameTime, neededEnergy)
	if neededEnergy > 0 and self:RawConsumeResource("Energy", energyAmount) then
		ply:SetEnergy(ply:GetEnergy() + energyAmount)
	end

	local neededOxygen = 100 - ply:GetOxygen()
	local oxygenAmount = mathMin(10 * frameTime, neededOxygen)
	if neededOxygen > 0 and self:RawConsumeResource("Oxygen", oxygenAmount) then
		ply:SetOxygen(ply:GetOxygen() + oxygenAmount)
	end

	local neededCoolant = 100 - ply:GetCoolant()
	local coolantAmount = mathMin(10 * frameTime, neededCoolant)
	if neededCoolant > 0 and self:RawConsumeResource("Coolant", coolantAmount) then
		ply:SetCoolant(ply:GetCoolant() + coolantAmount)
	end
end

function ENT:ServerInitialize()
	self:SetUseType(CONTINUOUS_USE)

	self.BaseClass.ServerInitialize(self)
end
