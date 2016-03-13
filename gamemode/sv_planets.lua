local SB_PLANET1_HABITAT = bit.lshift(1, 1)
local SB_PLANET1_UNSTABLE = bit.lshift(1, 2)
local SB_PLANET1_SUNBURN = bit.lshift(1, 3)

local function getPlanetV1(logicKV)
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

		radius = tonumber(logicKV["Case02"]),
		gravity = tonumber(logicKV["Case03"]),
		atmosphere = math.Clamp(tonumber(logicKV["Case04"]), 0, 1),

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
		print("WARNING: Unknown planet type: " .. tostring(planetVersion))
		return nil
	end

	planetValues.position = logicCase:GetPos()
	planetValues.angle = logicCase:GetAngles()

	return planetValues
end

function GM:CreatePlanets()
	local logicCases = ents.FindByClass("logic_case")
	for _, ent in ipairs(logicCases) do
		local planetValues = getPlanetValues(ent)
		if planetValues == nil then
			continue
		end

		local planet = ents.Create("sa_planet")

		if not planet:IsValid() then
			print("Failed to create planet for " .. tostring(planetValues.name))
			continue
		end

		planet:SetPos(planetValues.position)
		planet:SetAngles(planetValues.angle)

		planet:Spawn()

		planet:SetPlanetName(planetValues.name)
		planet:SetPlanetRadius(planetValues.radius)
		planet:SetPlanetGravity(planetValues.gravity)

		-- TODO: set additional planet values

		print("Created planet for " .. tostring(planetValues.name))
		PrintTable(planetValues)
	end
end
