-- Copyright (C) Charles Leasure, Mark Dietzer, and Michael Johnson d.b.a SpaceAge - All Rights Reserved
-- See LICENSE file for more information.

include("../utilities/planet_util.lua")
include("../utilities/sorted_set.lua")

local PLAYER = FindMetaTable("Player")

function PLAYER:InitializeSpaceAge()
	self.planets = sorted_set.new(planet_util.compare)
end

-- this hook is to be called after DataTables are initialized
-- behavior when called manually is undefined
function PLAYER:DataTablesInitialized()
	if self.planetDirty then
		self:ApplyPlanet(self.planets[#self.planets])
		self.planetDirty = nil
	end
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
	if not self.SetAreaName then
		-- the player just joined and hasn't fully initialized yet
		-- mark them dirty and PLAYER:SpaceAgeSpawned will try again after they've initialized
		self.planetDirty = true
		return
	end

	if planet == nil then
		self:SetGravity(0.00001)
		self:SetAreaName("Space")
		return
	end

	self:SetGravity(planet:GetPlanetGravity())
	self:SetAreaName(planet:GetPlanetName())
end
