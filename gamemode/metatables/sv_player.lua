-- Copyright (C) Charles Leasure, Mark Dietzer, and Michael Johnson d.b.a SpaceAge - All Rights Reserved
-- See LICENSE file for more information.

include("plifo.lua")
include("../utilities/planet_util.lua")
include("../utilities/plifo.lua")

local PLAYER = FindMetaTable("Player")

function PLAYER:InitializeSpaceAge()
	self.planets = plifo.new(planet_util.compare)
end

function PLAYER:EnteredPlanet(planet)
	self.planets:insert(planet)

	return self:ApplyPlanet(self.planets[#self.planets])
end

function PLAYER:ExitedPlanet(planet)
	self.planets:remove(planet)

	return self:ApplyPlanet(self.planets[#self.planets])
end

function PLAYER:ApplyPlanet(planet)
	if planet == nil then
		self:SetGravity(0.00001)
		self:SetAreaName("Space")
		return
	end

	self:SetGravity(planet:GetPlanetGravity())
	self:SetAreaName(planet:GetPlanetName())
end
