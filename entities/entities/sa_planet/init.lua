include("info.lua")

function ENT:Initialize()
	self.BaseClass.Initialize(self)

	self:SetSolid(SOLID_BBOX)
	self:SetCollisionBounds(Vector(0, 0, 0), Vector(0, 0, 0))
	self:SetTrigger(true)
end

function ENT:SetPlanetName(name)
	if self.planetInfo == nil then
		self.planetInfo = {}
	end
	self.planetInfo.name = name
end

function ENT:SetPlanetRadius(radius)
	if self.planetInfo == nil then
		self.planetInfo = {}
	end
	self.planetInfo.radius = radius

	local negRadius = -radius
	self:SetCollisionBounds(Vector(negRadius, negRadius, negRadius), Vector(radius, radius, radius))
end

function ENT:StartTouch(otherEnt)
	if not otherEnt:IsPlayer() then
		return
	end

	-- TODO: inform player that it is in atmosphere
end

function ENT:EndTouch(otherEnt)
	if not otherEnt:IsPlayer() then
		return
	end

	-- TODO: inform player that it is no longer in atmosphere
end
