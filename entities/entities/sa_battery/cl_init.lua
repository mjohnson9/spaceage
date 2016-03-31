include("info.lua")
include("shared.lua")

ENT.RenderPosition = Vector(-9, 9, 66)

function ENT:GetPanelPos()
	local pos = self:LocalToWorld(self.RenderPosition)
	local ang = self:GetAngles()
	return pos, ang, 0.2
end

function ENT:CreatePanel()

	local displayContainer = vgui.Create("DPanel")
	displayContainer:SetSize(90, 90)
	displayContainer:SetPos(0, 0)
	displayContainer:SetPaintBackground(false)

	local energyLabel = vgui.Create("DLabel", displayContainer)
	energyLabel:SetText("Energy")
	energyLabel:SetContentAlignment(5) -- middle center
	energyLabel:Dock(TOP)

	local energyCountLabel = vgui.Create("DLabel", displayContainer)
	energyCountLabel:SetText("0")
	energyCountLabel:SetContentAlignment(5) -- middle center
	energyCountLabel:Dock(TOP)
	self.energyCountLabel = energyCountLabel

		local maxStorageCountLabel = vgui.Create("DLabel", displayContainer)
	maxStorageCountLabel:SetText(self.ResourceStorage.Energy)
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
	self.energyCountLabel:SetText(mathRound(self:GetEnergy()))
end
