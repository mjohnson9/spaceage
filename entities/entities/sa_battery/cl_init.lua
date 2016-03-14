include("info.lua")
include("shared.lua")

ENT.RenderPosition = Vector(-9, 9.1, 66)

function ENT:GetPanelPos()
	local pos = self:LocalToWorld(self.RenderPosition)
	local ang = self:GetAngles()
	return pos, ang, 0.1
end

function ENT:CreatePanel()
	local primaryPanel = vgui.Create("DPanel")

	primaryPanel:SetPos(0, 0)
	primaryPanel:SetSize(182, 182)

	local DLabel = vgui.Create("DLabel", primaryPanel)
	DLabel:SetPos(10, 10)
	DLabel:SetText("Hello, world!")
	DLabel:SizeToContents()
	DLabel:SetDark(1)

	return primaryPanel
end
