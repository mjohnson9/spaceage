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

function ENT:SetPlanetGravity(gravity)
	if self.planetInfo == nil then
		self.planetInfo = {}
	end
	self.planetInfo.gravity = gravity
end

function ENT:StartTouch(otherEnt)
	if not otherEnt:IsPlayer() then
		return
	end

	print(otherEnt:GetName() .. " has entered the atmosphere of " .. self.planetInfo.name)

	otherEnt:SetGravity(self.planetInfo.gravity)

	-- TODO: handle edge cases
end

function ENT:EndTouch(otherEnt)
	if not otherEnt:IsPlayer() then
		return
	end

	print(otherEnt:GetName() .. " has exited the atmosphere of " .. self.planetInfo.name)

	otherEnt:SetGravity(0.00001)

	-- TODO: handle edge cases
end
