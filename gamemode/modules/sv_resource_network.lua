local sorted_set = require("sorted_set")

local ipairs = ipairs
local mathFloor = math.floor
local pairs = pairs
local setmetatable = setmetatable
local sortedSetNew = sorted_set.new

module("resource_network")

local function resourceEntityCompare(ent1, ent2)
	return ent1:EntIndex() < ent2:EntIndex()
end

local mt = {}
mt.__index = mt

function mt:addResource(ent)
	self.members:insert(ent)
	self:addResourceStorage(ent)
end

function mt:removeResource(ent)
	self.members:remove(ent)
	self:removeResourceStorage(ent)
end

function mt:insertResource(resourceType, amount)
	local resourceTable = self.resources[resourceType]

	if resourceTable == nil then
		return 0
	end

	amount = mathFloor(amount)
	local totalStored = 0

	for _, ent in ipairs(resourceTable.storageEnts) do
		local stored = ent:StoreResource(resourceType, amount)
		totalStored = totalStored + stored
		amount = amount - stored

		if amount <= 0 then
			break
		end
	end

	return totalStored
end

function mt:addResourceStorage(ent)
	for resourceType, availableStorage in pairs(ent.ResourceStorage) do
		local resourceTable = self.resources[resourceType]

		if resourceTable == nil then
			resourceTable = {
				storageEnts = sortedSetNew(resourceEntityCompare),
			}

			self.resources[resourceType] = resourceTable
		end

		resourceTable.storageEnts:insert(ent)
	end
end

function mt:removeResourceStorage(ent)
	for resourceType, availableStorage in pairs(ent.ResourceStorage) do
		local resourceTable = self.resources[resourceType]

		if resourceTable ~= nil then
			resourceTable.storageEnts:remove(ent)
		end
	end
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
