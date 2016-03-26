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

	local hydrogenLabel = vgui.Create("DLabel", displayContainer)
	hydrogenLabel:SetText("Hydrogen")
	hydrogenLabel:SetContentAlignment(5) -- middle center
	hydrogenLabel:Dock(TOP)

	local hydrogenCountLabel = vgui.Create("DLabel", displayContainer)
	hydrogenCountLabel:SetText("0")
	hydrogenCountLabel:SetContentAlignment(5) -- middle center
	hydrogenCountLabel:Dock(TOP)
	self.hydrogenCountLabel = hydrogenCountLabel

	local maxStorageCountLabel = vgui.Create("DLabel", displayContainer)
	maxStorageCountLabel:SetText(self.ResourceStorage.Hydrogen)
	maxStorageCountLabel:SetContentAlignment(5) -- middle center
	maxStorageCountLabel:Dock(BOTTOM)

	local maxStorageLabel = vgui.Create("DLabel", displayContainer)
	maxStorageLabel:SetText("Maximum Storage")
	maxStorageLabel:SetContentAlignment(5) -- middle center
	maxStorageLabel:Dock(BOTTOM)

	return displayContainer
end

function ENT:UpdatePanel()
	self.hydrogenCountLabel:SetText(self:GetHydrogen())
end
