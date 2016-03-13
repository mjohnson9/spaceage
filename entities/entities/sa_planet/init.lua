-- Copyright (C) Charles Leasure, Mark Dietzer, and Michael Johnson d.b.a SpaceAge - All Rights Reserved
-- See LICENSE file for more information.

include("info.lua")

function ENT:Initialize()
	self.BaseClass.Initialize(self)

	self:SetSolid(SOLID_BBOX)
	self:SetCollisionBounds(Vector(-1, -1, -1), Vector(1, 1, 1))
	self:SetTrigger(true)

	self.planetInfo = {
		name = "",

		gravity = 1,
		priority = 1,
		radius = 1,
	}
end

function ENT:SetPlanetName(name)
	self.planetInfo.name = name
end

function ENT:GetPlanetName()
	return self.planetInfo.name
end

function ENT:SetPlanetRadius(radius)
	self.planetInfo.radius = radius

	local negRadius = -radius
	self:SetCollisionBounds(Vector(negRadius, negRadius, negRadius), Vector(radius, radius, radius))
end

function ENT:GetPlanetRadius()
	return self.planetInfo.radius
end

function ENT:SetPlanetGravity(gravity)
	self.planetInfo.gravity = gravity
end

function ENT:GetPlanetGravity()
	return self.planetInfo.gravity
end

function ENT:SetPlanetPriority(priority)
	self.planetInfo.priority = priority
end

function ENT:GetPlanetPriority()
	return self.planetInfo.priority
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
