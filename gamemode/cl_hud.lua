-- Copyright (C) Charles Leasure, Mark Dietzer, and Michael Johnson d.b.a SpaceAge - All Rights Reserved
-- See LICENSE file for more information.
	
-- Cache the hud backgrounds to prevent call them every frame
self.HudBackground = Material("spaceage/hud_background.png")
self.HudDrain = Material("spaceage/hud_drain.png")

function GM:HUDPaint()
	self.BaseClass.HUDPaint(self)

	-- Local Variables
	local playerArea   = self.LocalPlayer:GetAreaName()
	local playerHealth = self.LocalPlayer:Health()
	local playerEnergy = self.LocalPlayer:Armor()
	local playerOxygen = 60
	local playerCoolant = 20
	local screenWidth  = ScrW()
	local screenHeight = ScrH()

	-- Local Functions
	local playerHealthAdjust = (62) * ((100 - playerHealth)/100)
	local playerEnergyAdjust = (62) * ((100 - playerEnergy)/100)
	local playerOxygenAdjust = (62) * ((100 - playerOxygen)/100)
	local playerCoolantAdjust = (62) * ((100 - playerCoolant)/100)

	-- Draw Base HUD
	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(self.HudBackground)
	surface.DrawTexturedRect(5, screenHeight -122, 306, 111)

	-- Draw Environment Name
	draw.SimpleTextOutlined((playerArea), "DermaDefaultBold", 70, screenHeight - 113, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
	
	-- Draw Health Bar
	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(self.HudDrain)
	surface.DrawTexturedRect(138, screenHeight - 94, 27, playerHealthAdjust)
	-- Draw Health Percent
	draw.SimpleTextOutlined((playerHealth), "DermaDefaultBold", 151, screenHeight - 31, Color(214, 0, 3), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))

	-- Draw Energy Bar
	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(self.HudDrain)
	surface.DrawTexturedRect(184, screenHeight - 94, 27, playerEnergyAdjust)
	-- Draw Energy Percent
	draw.SimpleTextOutlined((playerEnergy), "DermaDefaultBold", 197, screenHeight - 31, Color(71, 230, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))

	-- Draw Oxygen Bar
	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(self.HudDrain)
	surface.DrawTexturedRect(230, screenHeight - 94, 27, playerOxygenAdjust)
	-- Draw Oxygen Percent
	draw.SimpleTextOutlined((playerOxygen), "DermaDefaultBold", 243, screenHeight - 31, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))

	-- Draw Coolant Bar
	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(self.HudDrain)
	surface.DrawTexturedRect(276, screenHeight - 94, 27, playerCoolantAdjust)
	-- Draw Coolant Percent
	draw.SimpleTextOutlined((playerCoolant), "DermaDefaultBold", 290, screenHeight - 31, Color(0, 180, 231), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))



end

function GM:HUDShouldDraw(name)
	if	name == 'CHudHealth' ||
		name == 'CHudBattery' ||
		name == 'CHudAmmo' ||
		name == 'CHudSecondaryAmmo'
	then
		return false
	end
	
	return true
end
