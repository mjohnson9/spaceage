include("info.lua")
include("shared.lua")

ENT.RenderPosition = Vector(-9, 9.1, 66)

function ENT:GetPanelPos()
	local pos = self:LocalToWorld(self.RenderPosition)
	local ang = self:GetAngles()
	return pos, ang, 0.1
end

function ENT:CreatePanel()

	local displayContainer = vgui.Create("DPanel")
	displayContainer:SetSize(182, 182)
	displayContainer:SetPos(0, 0)
	displayContainer:SetPaintBackground(false)

	local energyLabel = vgui.Create("DPanel", displayContainer)
	energyLabel.Paint = function()
		draw.SimpleTextOutlined("Energy", "DermaDefault", 91, 40, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255))
	end
	local energyCountLabel = vgui.Create("DPanel", displayContainer)
			energyCountLabel.Paint = function()
		draw.SimpleTextOutlined(self:GetEnergy(), "DermaDefault", 91, 55, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255))
	end
	local energyStorageLabel = vgui.Create("DPanel", displayContainer)
	energyStorageLabel.Paint = function()
		draw.SimpleTextOutlined("Maxium Storage", "DermaDefault", 91, 90, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255))
	end
	local energyStorageCountLabel = vgui.Create("DPanel", displayContainer)
			energyStorageCountLabel.Paint = function()
		draw.SimpleTextOutlined(self.ResourceStorage.Energy, "DermaDefault", 91, 105, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255))
	end

	return displayContainer
end
