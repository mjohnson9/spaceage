-- Copyright (C) Charles Leasure, Mark Dietzer, and Michael Johnson d.b.a SpaceAge - All Rights Reserved
-- See LICENSE file for more information.

-- Cache the hud backgrounds to prevent call them every frame
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
local environmentLabel = vgui.Create("DPanel", hudContainer)
environmentLabel:SetPos(43, 5)

-- Create Resource Labels
local healthLabel = vgui.Create( "DPanel", hudContainer )
healthLabel:SetPos( 137, 90 )

local energyLabel = vgui.Create( "DPanel", hudContainer )
energyLabel:SetPos( 183, 90 )

local oxygenLabel = vgui.Create( "DPanel", hudContainer )
oxygenLabel:SetPos( 229, 90 )

local coolantLabel = vgui.Create( "DPanel", hudContainer )
coolantLabel:SetPos( 275, 90 )

-- Create Resource Bars
local healthBar = vgui.Create("DPanel", hudContainer)
healthBar:SetPos(133, 28)
healthBar:SetSize(27, 0)

local energyBar = vgui.Create("DPanel", hudContainer)
energyBar:SetPos(179, 28)
energyBar:SetSize(27, 0)

local oxygenBar = vgui.Create("DPanel", hudContainer)
oxygenBar:SetPos(225, 28)
oxygenBar:SetSize(27, 0)

local coolantBar = vgui.Create("DPanel", hudContainer)
coolantBar:SetPos(271, 28)
coolantBar:SetSize(27, 0)

function HOOKS:InitPostEntity()
	localPlayer = LocalPlayer()
end

function HOOKS:HUDPaint()
	-- Local Variables
	local playerArea = localPlayer:GetAreaName()
	local playerHealthText = mathMax(localPlayer:Health(), 0)
	local playerHealthPercent = mathMin(playerHealthText, 100)
	local playerEnergyText = mathMax(localPlayer:Armor(), 0)
	local playerEnergyPercent = mathMin(playerEnergyText, 100)
	local playerOxygen = localPlayer:GetOxygen()
	local playerCoolant = localPlayer:GetCoolant()

	-- Local Functions
	local playerHealthAdjust = (62) * ((100 - playerHealthPercent) / 100)
	local playerEnergyAdjust = (62) * ((100 - playerEnergyPercent) / 100)
	local playerOxygenAdjust = (62) * ((100 - playerOxygen) / 100)
	local playerCoolantAdjust = (62) * ((100 - playerCoolant) / 100)

	-- Update EnvironmentLabel
	environmentLabel.Paint = function()
	 	draw.SimpleTextOutlined(playerArea, "DermaDefaultBold", 20, 0, colorEnvironment, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, colorBlack)
	 end
	-- Update Resource Labels
	healthLabel.Paint = function()
		draw.SimpleTextOutlined(playerHealthPercent, "DermaDefaultBold", 9, 0, colorHealth, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, colorBlack)
	end

	energyLabel.Paint = function()
		draw.SimpleTextOutlined(playerEnergyPercent, "DermaDefaultBold", 10, 0, colorEnergy, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, colorBlack)
	end

	oxygenLabel.Paint = function()
		draw.SimpleTextOutlined(playerOxygen, "DermaDefaultBold", 10, 0, colorOxygen, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, colorBlack)
	end

	coolantLabel.Paint = function()
		draw.SimpleTextOutlined(playerCoolant, "DermaDefaultBold", 10, 0, colorCoolant, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, colorBlack)
	end

	-- Update Resource Bars
	healthBar:SetSize(27, playerHealthAdjust)
	healthBar.Paint = function()
		surface.SetMaterial(hudDrain)
		healthBar:DrawTexturedRect()
	end

	energyBar:SetSize(27, playerEnergyAdjust)
	energyBar.Paint = function()
		surface.SetMaterial(hudDrain)
		energyBar:DrawTexturedRect()
	end

	oxygenBar:SetSize(27, playerOxygenAdjust)
	oxygenBar.Paint = function()
		surface.SetMaterial(hudDrain)
		oxygenBar:DrawTexturedRect()
	end

	coolantBar:SetSize(27, playerCoolantAdjust)
	coolantBar.Paint = function()
		surface.SetMaterial(hudDrain)
		oxygenBar:DrawTexturedRect()
	end
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
