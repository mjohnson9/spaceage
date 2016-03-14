function ENT:Initialize()
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	if SERVER then
		self:ServerInitialize()
	end

	local phys = self:GetPhysicsObject()
	if IsValid(phys) then phys:Wake() end
end
