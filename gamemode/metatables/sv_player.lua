-- Copyright (C) Charles Leasure, Mark Dietzer, and Michael Johnson d.b.a SpaceAge - All Rights Reserved
-- See LICENSE file for more information.

local planet_util = require("planet_util")
local sorted_set = require("sorted_set")

local PLAYER = FindMetaTable("Player")

function PLAYER:InitializeSpaceAge()
	self.planets = sorted_set.new(planet_util.compare)
end

function PLAYER:EnteredPlanet(planet)
	self.planets:insert(planet)

	self:ApplyPlanet(self.planets[#self.planets])

	hook.Run("PlayerEneteredPlanet", self)
end

function PLAYER:ExitedPlanet(planet)
	self.planets:remove(planet)

	self:ApplyPlanet(self.planets[#self.planets])

	hook.Run("PlayerExitedPlanet", self)
end

-- if a player's gravity is set to 0, the engine converts it to 1
local PLAYER_NOGRAVITY = 0.00001

function PLAYER:ApplyPlanet(planet)
	if not self.SetAreaName then
		-- the player just joined and hasn't fully initialized yet
		-- mark them dirty and PLAYER:SpaceAgeSpawned will try again after they've initialized
		self.planetDirty = true
		return
	end

	if planet == nil then
		self:SetGravity(PLAYER_NOGRAVITY)
		self:SetInSpace(true)
		self:SetAreaName("Space")
		return
	end

	local gravity = planet:GetPlanetGravity()
	if gravity == 0 then
		self:SetGravity(PLAYER_NOGRAVITY)
	else
		self:SetGravity(gravity)
	end

	self:SetInSpace(false)
	self:SetAreaName(planet:GetPlanetName())
end
