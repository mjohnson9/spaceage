local class = require("middleclass")

local mathFloor = math.floor
local pairs = pairs
local setmetatable = setmetatable


module("resource_network")

local tableIsEmpty

local ResourceNetwork = class("ResourceNetwork")

local currentID = 1

function ResourceNetwork:initialize()
	self.id = currentID
	currentID = currentID + 1

	self.members = {}
	self.resources = {}
end

function ResourceNetwork:addResource(ent)
	self.members[ent:EntIndex()] = true
	self:_addResourceStorage(ent)
end

function ResourceNetwork:_addResourceStorage(ent)
	for resourceType, availableStorage in pairs(ent.ResourceStorage) do
		local resourceTable = self.resources[resourceType]

		if resourceTable == nil then
			resourceTable = {
				storageEnts = {},
			}

			self.resources[resourceType] = resourceTable
		end

		resourceTable.storageEnts[ent:EntIndex()] = true
	end
end

function ResourceNetwork:removeResource(ent)
	self.members[ent:EntIndex()] = nil
	self:_removeResourceStorage(ent)
end

function ResourceNetwork:_removeResourceStorage(ent)
	for resourceType, availableStorage in pairs(ent.ResourceStorage) do
		local resourceTable = self.resources[resourceType]

		if resourceTable ~= nil then
			resourceTable.storageEnts[ent:EntIndex()] = nil
		end

		if tableIsEmpty(resourceTable) then
			self.resources[resourceType] = nil
		end
	end
end

---
-- Injects a resource into the network
-- @param resourceType the type of resource to inject
-- @param amount how much of the resource to inject
-- @return the amount of the resource actually injected - will be 0 < n ≤ amount
function ResourceNetwork:injectResource(resourceType, amount)
	local resourceTable = self.resources[resourceType]

	if resourceTable == nil then
		return 0
	end

	amount = mathFloor(amount)
	local totalStored = 0

	for entID in pairs(resourceTable.storageEnts) do
		local ent = ents.GetByIndex(entID)

		local stored = ent:StoreResource(resourceType, amount)
		totalStored = totalStored + stored
		amount = amount - stored

		if amount <= 0 then
			break
		end
	end

	return totalStored
end

local function tableIsEmpty(t)
	return next(t) ~= nil
end

return ResourceNetwork
