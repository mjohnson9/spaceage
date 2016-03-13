include("info.lua")

function ENT:Initialize()
	self.BaseClass.Initialize(self)

	self:SetSolid(SOLID_BBOX)
	self:SetCollisionBounds(Vector(0, 0, 0), Vector(0, 0, 0))
	self:SetTrigger(true)

	if self.planetInfo == nil then
		self.planetInfo = {}
	end
end

function ENT:SetPlanetName(name)
	if self.planetInfo == nil then
		self.planetInfo = {}
	end
	self.planetInfo.name = name
end

function ENT:GetPlanetName()
	return self.planetInfo.name
end

function ENT:SetPlanetRadius(radius)
	if self.planetInfo == nil then
		self.planetInfo = {}
	end
	self.planetInfo.radius = radius

	local negRadius = -radius
	self:SetCollisionBounds(Vector(negRadius, negRadius, negRadius), Vector(radius, radius, radius))
end

function ENT:GetPlanetRadius()
	return self.planetInfo.radius
end

function ENT:SetPlanetGravity(gravity)
	if self.planetInfo == nil then
		self.planetInfo = {}
	end
	self.planetInfo.gravity = gravity
end

function ENT:GetPlanetGravity()
	return self.planetInfo.gravity
end

function ENT:StartTouch(otherEnt)
	if not otherEnt:IsPlayer() then
		return
	end

	print(otherEnt:GetName() .. " has entered the atmosphere of " .. self.planetInfo.name)

	otherEnt:EnteredPlanet(self)
end

function ENT:EndTouch(otherEnt)
	if not otherEnt:IsPlayer() then
		return
	end

	print(otherEnt:GetName() .. " has exited the atmosphere of " .. self.planetInfo.name)

	otherEnt:ExitedPlanet(self)
end
