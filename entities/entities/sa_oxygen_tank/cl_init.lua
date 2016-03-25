include("info.lua")
include("shared.lua")

ENT.RenderPosition = Vector(-8.7, 9.5, 39.8)

function ENT:GetPanelPos()
	local pos = self:LocalToWorld(self.RenderPosition)
	local ang = self:GetAngles()
	return pos, ang, 0.13
end

function ENT:CreatePanel()

	local displayContainer = vgui.Create("DPanel")
	displayContainer:SetSize(135, 139.5)
	displayContainer:SetPos(0, 0)
	displayContainer:SetPaintBackground(false)

	local oxygenLabel = vgui.Create("DLabel", displayContainer)
	oxygenLabel:SetText("Oxygen")
	oxygenLabel:SetContentAlignment(5) -- middle center
	oxygenLabel:Dock(TOP)

	local oxygenCountLabel = vgui.Create("DLabel", displayContainer)
	oxygenCountLabel:SetText("0")
	oxygenCountLabel:SetContentAlignment(5) -- middle center
	oxygenCountLabel:Dock(TOP)
	self.oxygenCountLabel = oxygenCountLabel

	local maxStorageCountLabel = vgui.Create("DLabel", displayContainer)
	maxStorageCountLabel:SetText(self.ResourceStorage.Oxygen)
	maxStorageCountLabel:SetContentAlignment(5) -- middle center
	maxStorageCountLabel:Dock(BOTTOM)

	local maxStorageLabel = vgui.Create("DLabel", displayContainer)
	maxStorageLabel:SetText("Maximum Storage")
	maxStorageLabel:SetContentAlignment(5) -- middle center
	maxStorageLabel:Dock(BOTTOM)

	return displayContainer
end

function ENT:UpdatePanel()
	self.oxygenCountLabel:SetText(self:GetOxygen())
end
