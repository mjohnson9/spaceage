-- Copyright (C) Charles Leasure, Mark Dietzer, and Michael Johnson d.b.a SpaceAge - All Rights Reserved
-- See LICENSE file for more information.

AddCSLuaFile("player_cl.lua")
AddCSLuaFile("player_sh.lua")

include("player_sh.lua")

include("plifo.lua")

local PLAYER = FindMetaTable("Player")

local function planetCompare(planet1, planet2)
	if planet1:GetPlanetPriority() < planet2:GetPlanetPriority() then
		return true
	end

	return planet1:EntIndex() < planet2:EntIndex()
end

function PLAYER:InitializeSpaceAge()
	self.planets = plifo.new(planetCompare)
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
