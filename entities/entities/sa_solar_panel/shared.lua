function ENT:Initialize()
	self:SetModel("models/hunter/geometric/hex1x1.mdl")

	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	if SERVER then
		self:ServerInitialize()
	end

	local phys = self:GetPhysicsObject()
	if IsValid(phys) then phys:Wake() end

	self:SetOverlayText("Solar Panel")
end
