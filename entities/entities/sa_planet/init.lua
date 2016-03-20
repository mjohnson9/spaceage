-- Copyright (C) Charles Leasure, Mark Dietzer, and Michael Johnson d.b.a SpaceAge - All Rights Reserved
-- See LICENSE file for more information.

include("info.lua")

function ENT:Initialize()
	self.BaseClass.Initialize(self)

	local radius = self.planetInfo.radius
	local negRadius = -radius

	local mins = Vector(negRadius, negRadius, negRadius)
	local maxs = Vector(radius, radius, radius)
	if self.planetInfo.cube then
		self:PhysicsInitBox(mins, maxs)
	else
		-- TODO: I'm not actually sure if this is working or not. It needs more
		-- research.

		self:PhysicsInitSphere(radius, "default_silent")
		--MsgN("Spherical planets are presently represented by cubes due to limitations in Garry's Mod.")
	end

	self:SetCollisionBounds(mins, maxs)

	self:SetMoveType(MOVETYPE_NONE) -- planets should never move

	self:SetTrigger(true)
end

function ENT:CheckPlanetInfo()
	if self.planetInfo == nil then
		self.planetInfo = {
			name = "",

			cube = false,

			gravity = 1,
			priority = 1,
			radius = 1,
		}
	end
end

function ENT:SetPlanetName(name)
	self:CheckPlanetInfo()
	self.planetInfo.name = name
end

function ENT:GetPlanetName()
	return self.planetInfo.name
end

function ENT:SetPlanetShape(shape)
	self:CheckPlanetInfo()

	if shape == "sphere" then
		self.planetInfo.cube = false
	elseif shape == "cube" then
		self.planetInfo.cube = true
	else
		error("unknown planet shape: " .. tostring(shape))
	end
end

function ENT:SetPlanetRadius(radius)
	self:CheckPlanetInfo()
	self.planetInfo.radius = radius

	--local negRadius = -radius
	--self:SetCollisionBounds(Vector(negRadius, negRadius, negRadius), Vector(radius, radius, radius))
end

function ENT:GetPlanetRadius()
	return self.planetInfo.radius
end

function ENT:SetPlanetGravity(gravity)
	self:CheckPlanetInfo()
	self.planetInfo.gravity = gravity
end

function ENT:GetPlanetGravity()
	return self.planetInfo.gravity
end

function ENT:SetPlanetPriority(priority)
	self:CheckPlanetInfo()
	self.planetInfo.priority = priority
end

function ENT:GetPlanetPriority()
	return self.planetInfo.priority
end

function ENT:StartTouch(otherEnt)
	otherEnt:EnteredPlanet(self)
end

function ENT:EndTouch(otherEnt)
	otherEnt:ExitedPlanet(self)
end

-- Prevent player interaction

function ENT:CanTool()
	return false
end

function ENT:GravGunPunt()
	return false
end

function ENT:GravGunPickupAllowed()
	return false
end
