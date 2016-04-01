-- Copyright (C) Charles Leasure, Mark Dietzer, and Michael Johnson d.b.a SpaceAge - All Rights Reserved
-- See LICENSE file for more information.

if _G.hud ~= nil and _G.hud:IsValid() then
	_G.hud:Remove()
end

-- cache global functions to prevent global table lookups every frame
local ScrH = ScrH

local hud = vgui.Create("SAHUD")
hud:SetPos(5, ScrH() - 122)
hud:SizeToContents()

hud:ParentToHUD()

_G.hud = hud

-- cache the local player
local localPlayer = LocalPlayer()

-- keep track of the values to minimize expensive calls to change HUD values
local curHealth = 0
local curEnergy = 0
local curOxygen = 0
local curCoolant = 0
local curEnvironment = ""

function HOOKS:HUDPaint()
	if not localPlayer:IsValid() then return end -- don't try to update if the local player isn't value

	local newHealth = localPlayer:Health()
	if newHealth ~= curHealth then
		hud:SetHealthValue(newHealth)
		curHealth = newHealth
	end

	local newEnergy = localPlayer:GetEnergy()
	if newEnergy ~= curEnergy then
		hud:SetEnergyValue(newEnergy)
		curEnergy = newEnergy
	end

	local newOxygen = localPlayer:GetOxygen()
	if newOxygen ~= curOxygen then
		hud:SetOxygenValue(newOxygen)
		curOxygen = newOxygen
	end

	local newCoolant = localPlayer:GetCoolant()
	if newCoolant ~= curCoolant then
		hud:SetCoolantValue(newCoolant)
		curCoolant = newCoolant
	end

	local newEnvironment = localPlayer:GetAreaName()
	if newEnvironment ~= curEnvironment then
		hud:SetEnvironment(newEnvironment)
		curEnvironment = newEnvironment
	end
end

function HOOKS:HUDShouldDraw(name)
	-- don't draw health or battery: we take care of that
	return not (name == "CHudHealth" or name == "CHudBattery")
end

function HOOKS:InitPostEntity()
	localPlayer = LocalPlayer()
end
