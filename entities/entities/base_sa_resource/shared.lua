function ENT:Initialize()
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	if SERVER then
		self:ServerInitialize()
	end

	if CLIENT then
		self:ClientInitialize()
	end

	local phys = self:GetPhysicsObject()
	if IsValid(phys) then phys:Wake() end
end

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "NetworkID")
end
