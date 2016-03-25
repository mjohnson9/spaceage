local class = require("middleclass")

local entsByID = ents.GetByIndex
local ipairs = ipairs
local mathFloor = math.floor
local next = next
local pairs = pairs
local setmetatable = setmetatable


module("resource_network")

local function tableIsEmpty(t)
	return next(t) ~= nil
end

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

			if tableIsEmpty(resourceTable) then
				self.resources[resourceType] = nil
			end
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

	local totalStored = 0

	for entID in pairs(resourceTable.storageEnts) do
		local ent = entsByID(entID)

		local stored = ent:StoreResource(resourceType, amount)
		totalStored = totalStored + stored
		amount = amount - stored

		if amount <= 0 then
			break
		end
	end

	return totalStored
end

---
-- Consumes a resource from the network
-- @param resourceType the type of resource to consume
-- @param amount how much of the resource to consume
-- @return whether or not enough resource exists to be consumed
function ResourceNetwork:consumeResource(resourceType, amount)
	local resourceTable = self.resources[resourceType]

	if resourceTable == nil then
		return false
	end

	-- check if the resource is available before consuming it
	local totalFound = 0
	local foundIn = {}

	for entID in pairs(resourceTable.storageEnts) do
		local ent = entsByID(entID)
		local currentlyStored = ent["Get" .. resourceType](ent)
		if currentlyStored > 0 then
			totalFound = totalFound + currentlyStored
			foundIn[#foundIn + 1] = ent

			if totalFound >= amount then
				break
			end
		end
	end

	if totalFound < amount then
		return false
	end

	for _, ent in ipairs(foundIn) do
		amount = amount - ent:PullResource(resourceType, amount)
		if amount <= 0 then
			return true
		end
	end

	return false
end

function ResourceNetwork:__tostring()
	return "ResourceNetwork [" .. self.id .. "]"
end

return ResourceNetwork
