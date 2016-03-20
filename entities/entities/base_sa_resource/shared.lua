local CurTime = CurTime

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

	self.lastThinkAt = CurTime()
	self.thinkTime = 0
end

---
-- Calculates the entity's thinkTime. thinkTime can be used similarly to
-- FrameTime to easily achieve a desired rate of change.
function ENT:CalcThinkTime()
	local t = CurTime()
	self.thinkTime = t - self.lastThinkAt
	self.lastThinkAt = t
end

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "NetworkID")

	local varNum = 1
	for resourceName, _ in SortedPairs(self.ResourceStorage, true) do
		self:NetworkVar("Int", varNum, resourceName)
		varNum = varNum + 1
	end

	self:PostSetupDataTables()
end

function ENT:PostSetupDataTables()
end
