-- Copyright (C) Charles Leasure, Mark Dietzer, and Michael Johnson d.b.a SpaceAge - All Rights Reserved
-- See LICENSE file for more information.

-- Cache the hud backgrounds to prevent call them every frame
local hudDrain = "spaceage/hud_drain.png"

-- localize functions to prevent global table lookups every frame
local ScrH = ScrH
local mathMax = math.max
local mathMin = math.min
local mathRemap = math.Remap

local colorEnvironment = Color(255, 255, 255)
local colorHealth = Color(214, 0, 3)
local colorEnergy = Color(71, 230, 0)
local colorOxygen = Color(255, 255, 255)
local colorCoolant = Color(0, 180, 231)

local localPlayer = LocalPlayer() -- save for later so that we aren't calling LocalPlayer every frame
local screenHeight = ScrH()

-- Create HUD Container
local hudContainer = vgui.Create("DPanel")
hudContainer:SetSize(306, 111)
hudContainer:SetPos(5, screenHeight - 122)
hudContainer:SetPaintBackground(false)
hudContainer:ParentToHUD()

local hudContainerBackground = vgui.Create("DImage", hudContainer)
hudContainerBackground:SetSize(hudContainer:GetSize())
hudContainerBackground:SetImage("spaceage/hud_background.png")

-- Create Environment Label
local environmentLabel = vgui.Create("DLabel", hudContainer)
environmentLabel:SetPos(34, 5)
environmentLabel:SetContentAlignment(5)
environmentLabel:SetColor(colorEnvironment)

-- Create Resource Labels
local healthLabel = vgui.Create( "DLabel", hudContainer )
healthLabel:SetPos(115, 88)
healthLabel:SetFont("DermaDefaultBold")
healthLabel:SetContentAlignment(5)
healthLabel:SetColor(colorHealth)

local energyLabel = vgui.Create( "DLabel", hudContainer )
energyLabel:SetPos(161, 88)
energyLabel:SetFont("DermaDefaultBold")
energyLabel:SetContentAlignment(5)
energyLabel:SetColor(colorEnergy)

local oxygenLabel = vgui.Create( "DLabel", hudContainer )
oxygenLabel:SetPos(207, 88)
oxygenLabel:SetFont("DermaDefaultBold")
oxygenLabel:SetContentAlignment(5)
oxygenLabel:SetColor(colorOxygen)

local coolantLabel = vgui.Create( "DLabel", hudContainer )
coolantLabel:SetPos(253, 88)
coolantLabel:SetFont("DermaDefaultBold")
coolantLabel:SetContentAlignment(5)
coolantLabel:SetColor(colorCoolant)

-- Create Resource Bars
local healthBar = vgui.Create("DImage", hudContainer)
healthBar:SetPos(133, 28)
healthBar:SetSize(27, 0)
healthBar:SetImage(hudDrain)

local energyBar = vgui.Create("DImage", hudContainer)
energyBar:SetPos(179, 28)
energyBar:SetSize(27, 0)
energyBar:SetImage(hudDrain)

local oxygenBar = vgui.Create("DImage", hudContainer)
oxygenBar:SetPos(225, 28)
oxygenBar:SetSize(27, 0)
oxygenBar:SetImage(hudDrain)

local coolantBar = vgui.Create("DImage", hudContainer)
coolantBar:SetPos(271, 28)
coolantBar:SetSize(27, 0)
coolantBar:SetImage(hudDrain)

function HOOKS:InitPostEntity()
	localPlayer = LocalPlayer()
end

function HOOKS:HUDPaint()
	-- Local Variables
	local playerArea = localPlayer:GetAreaName()
	local playerHealthText = mathMax(localPlayer:Health(), 0)
	local playerHealthPercent = mathMin(playerHealthText, 100)
	local playerEnergyText = mathMax(math.Round(localPlayer:GetEnergy(), 0), 0)
	local playerEnergyPercent = mathMin(playerEnergyText, 100)
	local playerOxygenText = mathMax(math.Round(localPlayer:GetOxygen(), 0), 0)
	local playerOxygenPercent = mathMin(playerOxygenText, 100)
	local playerCoolantText = mathMax(math.Round(localPlayer:GetCoolant(), 0), 0)
	local playerCoolantPercent = mathMin(playerCoolantText, 100)

	-- Local Functions
	local playerHealthAdjust  = mathRemap(playerHealthPercent, 0, 100, 62, 0)
	local playerEnergyAdjust  = mathRemap(playerEnergyPercent, 0, 100, 62, 0)
	local playerOxygenAdjust  = mathRemap(playerOxygenPercent, 0, 100, 62, 0)
	local playerCoolantAdjust = mathRemap(playerCoolantPercent, 0, 100, 62, 0)

	-- Update EnvironmentLabel
	environmentLabel:SetText(playerArea)

	-- Update Resource Labels
	healthLabel:SetText(playerHealthPercent)
	energyLabel:SetText(playerEnergyPercent)
	oxygenLabel:SetText(playerOxygenPercent)
	coolantLabel:SetText(playerCoolantPercent)

	-- Update Resource Bars
	healthBar:SetSize(27, playerHealthAdjust)
	energyBar:SetSize(27, playerEnergyAdjust)
	oxygenBar:SetSize(27, playerOxygenAdjust)
	coolantBar:SetSize(27, playerCoolantAdjust)
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
