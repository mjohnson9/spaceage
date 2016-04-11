include("info.lua")
include("shared.lua")

function ENT:ClientInitialize()
	self.statusPanel = self:CreatePanel()
	if self.statusPanel ~= nil then
		self.statusPanel:SetPaintedManually(true)
	end
end

function ENT:OnRemove()
	if self.statusPanel ~= nil then
		self.statusPanel:Remove()
	end
end

function ENT:CreatePanel()
end

function ENT:UpdatePanel()
end

function ENT:GetPanelPos()
	local renderPos = self.RenderPosition
	if renderPos ~= nil then
		renderPos = self:OBBMaxs()
	end
	local pos = self:LocalToWorld(renderPos)
	local ang = self:GetAngles()
	return pos, ang, 0.25
end

function ENT:RenderPanel()
	if self.statusPanel == nil then
		return
	end

	self:UpdatePanel()

	local pos, ang, scale = self:GetPanelPos()
	vgui.Start3D2D(pos, ang, scale)
		self.statusPanel:Paint3D2D()
	vgui.End3D2D()
end

function ENT:Draw()
	self:DrawModel()
	self:RenderPanel()
end

function ENT:DrawTranslucent()
	self:DrawModel()
	self:RenderPanel()
end

function ENT:IsInNetwork(target)
	return self:GetNetworkID() ~= 0 and self:GetNetworkID() == target:GetNetworkID()
end
