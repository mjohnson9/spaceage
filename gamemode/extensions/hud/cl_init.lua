-- Copyright (C) Charles Leasure, Mark Dietzer, and Michael Johnson d.b.a SpaceAge - All Rights Reserved
-- See LICENSE file for more information.

-- Cache the hud backgrounds to prevent call them every frame
local hudBackground = Material("spaceage/hud_background.png")
local hudDrain = Material("spaceage/hud_drain.png")

-- localize functions to prevent global table lookups every frame
local ScrH = ScrH
local mathMax = math.max
local mathMin = math.min

local colorEnvironment = Color(255, 255, 255)
local colorHealth = Color(214, 0, 3)
local colorEnergy = Color(71, 230, 0)
local colorOxygen = Color(255, 255, 255)
local colorCoolant = Color(0, 180, 231)
local colorBlack = Color(0, 0, 0)

local localPlayer = LocalPlayer() -- save for later so that we aren't calling LocalPlayer every frame

function HOOKS:InitPostEntity()
	localPlayer = LocalPlayer()
end

function HOOKS:HUDPaint()
	-- Local Variables
	local playerArea   = localPlayer:GetAreaName()
	local playerHealthText = mathMax(localPlayer:Health(), 0)
	local playerHealthPercent = mathMin(playerHealthText, 100)
	local playerEnergyText = mathMax(localPlayer:Armor(), 0)
	local playerEnergyPercent = mathMin(playerEnergyText, 100)
	local playerOxygen = 60
	local playerCoolant = 20
	local screenHeight = ScrH()

	-- Local Functions
	local playerHealthAdjust = (62) * ((100 - playerHealthPercent) / 100)
	local playerEnergyAdjust = (62) * ((100 - playerEnergyPercent) / 100)
	local playerOxygenAdjust = (62) * ((100 - playerOxygen) / 100)
	local playerCoolantAdjust = (62) * ((100 - playerCoolant) / 100)

	-- Draw Base HUD
	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(hudBackground)
	surface.DrawTexturedRect(5, screenHeight - 122, 306, 111)

	-- Draw Environment Name
	draw.SimpleTextOutlined(playerArea, "DermaDefaultBold", 70, screenHeight - 113, colorEnvironment, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, colorBlack)

	-- Draw Health Bar
	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(hudDrain)
	surface.DrawTexturedRect(138, screenHeight - 94, 27, playerHealthAdjust)
	-- Draw Health Percent
	draw.SimpleTextOutlined(playerHealthText, "DermaDefaultBold", 151, screenHeight - 31, colorHealth, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, colorBlack)

	-- Draw Energy Bar
	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(hudDrain)
	surface.DrawTexturedRect(184, screenHeight - 94, 27, playerEnergyAdjust)
	-- Draw Energy Percent
	draw.SimpleTextOutlined(playerEnergyText, "DermaDefaultBold", 197, screenHeight - 31, colorEnergy, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, colorBlack)

	-- Draw Oxygen Bar
	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(hudDrain)
	surface.DrawTexturedRect(230, screenHeight - 94, 27, playerOxygenAdjust)
	-- Draw Oxygen Percent
	draw.SimpleTextOutlined(playerOxygen, "DermaDefaultBold", 243, screenHeight - 31, colorOxygen, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, colorBlack)

	-- Draw Coolant Bar
	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(hudDrain)
	surface.DrawTexturedRect(276, screenHeight - 94, 27, playerCoolantAdjust)
	-- Draw Coolant Percent
	draw.SimpleTextOutlined(playerCoolant, "DermaDefaultBold", 290, screenHeight - 31, colorCoolant, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, colorBlack)
end

function HOOKS:HUDShouldDraw(name)
	if	name == "CHudHealth" or
		name == "CHudBattery" or
		name == "CHudAmmo" or
		name == "CHudSecondaryAmmo" then
		return false
	end

	return true
end
