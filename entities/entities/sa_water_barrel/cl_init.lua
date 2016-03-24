include("info.lua")
include("shared.lua")

ENT.RenderPosition = Vector(20, -11.6, 26)

function ENT:GetPanelPos()
	local pos = self:LocalToWorld(self.RenderPosition)
	local ang = self:GetAngles()
	return pos, Angle(ang[1], ang[2] + 90, ang[3] + 90), 0.13
end

function ENT:CreatePanel()

	local displayContainer = vgui.Create("DPanel")
	displayContainer:SetSize(182, 182)
	displayContainer:SetPos(0, 0)
	displayContainer:SetPaintBackground(false)

	local waterLabel = vgui.Create("DPanel", displayContainer)
	waterLabel.Paint = function()
		draw.SimpleTextOutlined("Water", "DermaDefault", 91, 20, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255))
	end

	local waterCountLabel = vgui.Create("DPanel", displayContainer)
	waterCountLabel.Paint = function()
		draw.SimpleTextOutlined(self:GetWater(), "DermaDefault", 91, 35, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255))
	end

	local waterStorageLabel = vgui.Create("DPanel", displayContainer)
	waterStorageLabel.Paint = function()
		draw.SimpleTextOutlined("Maxium Storage", "DermaDefault", 91, 115, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255))
	end

	local waterStorageCountLabel = vgui.Create("DPanel", displayContainer)
	waterStorageCountLabel.Paint = function()
		draw.SimpleTextOutlined(self.ResourceStorage.Water, "DermaDefault", 91, 130, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255))
	end

	return displayContainer
end
