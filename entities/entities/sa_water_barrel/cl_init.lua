include("info.lua")
include("shared.lua")

ENT.RenderPosition = Vector(20, -8.8, 24)

function ENT:GetPanelPos()
	local pos = self:LocalToWorld(self.RenderPosition)
	local ang = self:GetAngles()
	ang:RotateAroundAxis(ang:Up(), 90)
	ang:RotateAroundAxis(ang:Forward(), 90)
	return pos, ang, 0.13
end

function ENT:CreatePanel()

	local displayContainer = vgui.Create("DPanel")
	displayContainer:SetSize(135, 130)
	displayContainer:SetPos(0, 0)
	displayContainer:SetPaintBackground(false)

	local waterLabel = vgui.Create("DLabel", displayContainer)
	waterLabel:SetText("Water")
	waterLabel:SetContentAlignment(5) -- middle center
	waterLabel:Dock(TOP)

	local waterCountLabel = vgui.Create("DLabel", displayContainer)
	waterCountLabel:SetText("0")
	waterCountLabel:SetContentAlignment(5) -- middle center
	waterCountLabel:Dock(TOP)
	self.waterCountLabel = waterCountLabel

	local maxStorageCountLabel = vgui.Create("DLabel", displayContainer)
	maxStorageCountLabel:SetText(self.ResourceStorage.Water)
	maxStorageCountLabel:SetContentAlignment(5) -- middle center
	maxStorageCountLabel:Dock(BOTTOM)

	local maxStorageLabel = vgui.Create("DLabel", displayContainer)
	maxStorageLabel:SetText("Maximum Storage")
	maxStorageLabel:SetContentAlignment(5) -- middle center
	maxStorageLabel:Dock(BOTTOM)

	return displayContainer
end

local mathRound = math.Round

function ENT:UpdatePanel()
	self.waterCountLabel:SetText(mathRound(self:GetWater()))
end
