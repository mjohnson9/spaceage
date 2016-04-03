-- Copyright (C) Charles Leasure, Mark Dietzer, and Michael Johnson d.b.a SpaceAge - All Rights Reserved
-- See LICENSE file for more information.

--[[local SB_PLANET1_HABITAT = bit.lshift(1, 1)
local SB_PLANET1_UNSTABLE = bit.lshift(1, 2)
local SB_PLANET1_SUNBURN = bit.lshift(1, 3)]]

-- use customPlanets to manually add planets to maps
local customPlanets = {
	sb_gooniverse_v4 = {
		{
			name = "Spawn Room",
			priority = 10240,

			position = Vector(-10524.900391, -5780.000000, -9453.000000),
			shape = "cube",
			radius = 350,

			gravity = 1,
			atmosphere = 1,
		}
	}
}

local function getPlanetV1()
	-- TODO: add support for version 1 planets
	error("Version 1 planets are not yet supported")
end

local SB_PLANET2_UNSTABLE = bit.lshift(1, 1)
local SB_PLANET2_SUNBURN = bit.lshift(1, 2)

local function getPlanetV2(logicKV)
	local flags = tonumber(logicKV["Case08"])
	if flags == nil then
		flags = 0
	end

	return {
		name = tostring(logicKV["Case13"]),

		priority = 5120 / tonumber(logicKV["Case02"]),

		radius = tonumber(logicKV["Case02"]),
		gravity = tonumber(logicKV["Case03"]),
		atmosphere = math.Clamp(tonumber(logicKV["Case04"]), 0, 1),

		shape = "sphere",

		flags = {
			unstable = bit.band(SB_PLANET2_UNSTABLE, flags) == SB_PLANET2_UNSTABLE,
			sunburn = bit.band(SB_PLANET2_SUNBURN, flags) == SB_PLANET2_SUNBURN,
		},
	}
end

local function getPlanetValues(logicCase)
	local kv = logicCase:GetKeyValues()

	local planetVersion = kv["Case01"]

	local planetValues

	if planetVersion == "planet" then -- pre SB2.5 planet
		planetValues = getPlanetV1(kv)
	elseif planetVersion == "planet2" then
		planetValues = getPlanetV2(kv)
	else
		ErrorNoHalt("WARNING: Unknown planet type: " .. tostring(planetVersion) .. "\n")
		return nil
	end

	planetValues.position = logicCase:GetPos()
	planetValues.angle = logicCase:GetAngles()

	return planetValues
end

local function createPlanet(planetValues)
	local planet = ents.Create("sa_planet")

	if not planet:IsValid() then
		error("failed to create planet entity")
	end

	planet:SetPos(planetValues.position)

	if planetValues.angle ~= nil then
		planet:SetAngles(planetValues.angle)
	end

	if planetValues.name ~= nil then
		planet:SetPlanetName(planetValues.name)
	end

	if planetValues.radius ~= nil then
		planet:SetPlanetRadius(planetValues.radius)
	end

	if planetValues.gravity ~= nil then
		planet:SetPlanetGravity(planetValues.gravity)
	end

	if planetValues.priority ~= nil then
		planet:SetPlanetPriority(planetValues.priority)
	end

	if planetValues.shape ~= nil then
		planet:SetPlanetShape(planetValues.shape)
	end

	planet:Spawn()

	print("Created planet for " .. tostring(planetValues.name))
end

local function createPlanets()
	local logicCases = ents.FindByClass("logic_case")
	for _, ent in ipairs(logicCases) do
		local planetValues = getPlanetValues(ent)
		if planetValues ~= nil then
			createPlanet(planetValues)
		end
	end

	local overridePlanets = customPlanets[game.GetMap()]
	if overridePlanets ~= nil then
		for _, overridePlanet in ipairs(overridePlanets) do
			createPlanet(overridePlanet)
		end
	end
end

function HOOKS:InitPostEntity()
	createPlanets()
end

-- Called after the map is cleaned up.
function HOOKS:PostCleanupMap()
	-- Reset everyone's planet list
	for _, ply in ipairs(player.GetAll()) do
		ply.planets:clear()
	end

	-- Recreate the planets because they've now been removed
	createPlanets()
end
