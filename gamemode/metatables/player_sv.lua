-- Copyright (C) Charles Leasure, Mark Dietzer, and Michael Johnson d.b.a SpaceAge - All Rights Reserved
-- See LICENSE file for more information.

AddCSLuaFile("player_cl.lua")
AddCSLuaFile("player_sh.lua")

include("player_sh.lua")

local PLAYER = FindMetaTable("Player")

function PLAYER:EnteredPlanet(planet)
	self:SetGravity(planet:GetPlanetGravity())

	self:SetAreaName(planet:GetPlanetName())
end

function PLAYER:ExitedPlanet(planet)
	self:SetGravity(0.00001)

	self:SetAreaName("Space")
end
