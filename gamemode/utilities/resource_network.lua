include("sorted_set.lua")

local setmetatable = setmetatable
local sortedSetNew = sorted_set.new

module("resource_network")

local mt = {}
mt.__index = mt

function mt:addResource(ent)
	self.members:insert(ent)
end

function mt:addResource(ent)
	self.members:remove(ent)
end

local function resourceEntityCompare(ent1, ent2)
	return ent1:EntIndex() < ent2:EntIndex()
end

local networkID = 1

function new()
	local network = {
		id = networkID,

		members = sortedSetNew(resourceEntityCompare),
		resources = {},
	}

	networkID = networkID + 1

	setmetatable(network, mt)

	return network
end
