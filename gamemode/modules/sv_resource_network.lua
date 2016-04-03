local class = require("middleclass")

local error = error
local ipairs = ipairs
local next = next
local pairs = pairs
local tableCount = table.Count
local tableRemove = table.remove


module("resource_network")

local function tableIsEmpty(t)
	return next(t) == nil
end

local ResourceNetwork = class("ResourceNetwork")

local currentID = 1

---
-- Initializes a resource network
-- @param initialEnt the first entity in this network
-- @return a new resource network
function ResourceNetwork:initialize(initialEnt)
	self.id = currentID
	currentID = currentID + 1

	self.members = {}
	self.resources = {}

	self:_addResource(initialEnt)
end

---
-- Adds a link between two resource entities and resolves changes in the network
-- @param from the entity being linked from
-- @param to the entity being linked to
function ResourceNetwork:addLink(from, to)
	if from._resourceLinks == nil then
		from._resourceLinks = {}
	end

	if to._resourceLinks == nil then
		to._resourceLinks = {}
	end

	if self.members[from] == nil then
		error("entity in 'from' position must already be a member of this network")
	end

	from._resourceLinks[to] = true
	to._resourceLinks[from] = true

	local toNetwork = to:GetNetwork()
	if toNetwork ~= nil then
		-- we'll absorb the other network's resources
		self:_absorb(toNetwork)
	else
		-- simply add the new resource
		self:_addResource(to)
	end
end

function ResourceNetwork:removeLink(from, to)
	if from._resourceLinks[to] == nil then
		error("resources aren't linked")
	end

	from._resourceLinks[to] = nil
	to._resourceLinks[from] = nil

	local curNetworkSize = tableCount(self.members)

	local reachableTo = self:_findReachableNodes(to)
	if #reachableTo + 1 == curNetworkSize then
		-- shortcut: the network size hasn't changed, so this link removal doesn't matter
		return
	end

	if #reachableTo == 0 then
		-- shortcut: this entity has lost all links to other entities
		-- because only one link can be removed at a time, this means that there
		-- can't be a network split
		self:_removeResource(to)
		return
	end

	if #reachableTo == curNetworkSize then
		-- shortcut: the 'from' entity has been entirely removed from the network
		-- this is the same as the "entity has lost all links" case, but on the
		-- 'from' entity.
		self:_removeResource(from)
		return
	end

	-- this link removal has caused a split into two networks
	-- 'from' should keep this network (self) and we'll create a new network for
	-- 'to'

	self:_removeResource(to) -- remove it first so that the constructor doesn't attempt to absorb us
	local newNetwork = ResourceNetwork(to)

	for _, ent in ipairs(reachableTo) do
		self:_removeResource(ent) -- remove this resource from this network
		newNetwork:_addResource(ent) -- add it to its new network
	end
end

---
-- To be called whenever a network entity is being removed
-- @param ent the entity that is being removed
function ResourceNetwork:entityRemoved(from)
	for to in pairs(from._resourceLinks) do
		self:removeLink(from, to)
	end
end

function ResourceNetwork:_addResource(ent)
	self.members[ent] = true
	self:_addResourceStorage(ent)
	ent:SetNetwork(self)
end

function ResourceNetwork:_addResourceStorage(ent)
	for resourceType in pairs(ent.ResourceStorage) do
		local resourceTable = self.resources[resourceType]

		if resourceTable == nil then
			resourceTable = {
				storageEnts = {},
			}

			self.resources[resourceType] = resourceTable
		end

		resourceTable.storageEnts[ent] = true
	end
end

function ResourceNetwork:_removeResource(ent)
	self.members[ent] = nil
	self:_removeResourceStorage(ent)
	ent:SetNetwork(nil)
end

function ResourceNetwork:_removeResourceStorage(ent)
	for resourceType in pairs(ent.ResourceStorage) do
		local resourceTable = self.resources[resourceType]

		if resourceTable ~= nil then
			resourceTable.storageEnts[ent] = nil

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

	for ent in pairs(resourceTable.storageEnts) do
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

	for ent in pairs(resourceTable.storageEnts) do
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

---
-- Returns all of this network's members
function ResourceNetwork:getMembers()
	local retVal = {}

	for ent in pairs(self.members) do
		retVal[#retVal + 1] = ent
	end

	return retVal
end

---
-- Absorbs another network into this network
-- Note that the other network will be invalid after this
-- @param otherNetwork the network to absorb
function ResourceNetwork:_absorb(otherNetwork)
	local otherMembers = otherNetwork:getMembers()
	for _, ent in ipairs(otherMembers) do
		otherNetwork:_removeResource(ent)
		self:_addResource(ent)
	end
end

---
-- finds all nodes that the given node can reach
-- @param node the node for which to look
-- @return a sequential table containing all nodes that the given node can reach
-- (excluding itself)
function ResourceNetwork:_findReachableNodes(node)
	local reachable = {}

	local nodeQueue = {node}
	local checked = {}

	while #nodeQueue > 0 do
		local check = tableRemove(nodeQueue)

		for otherNode in pairs(check._resourceLinks) do
			if not checked[otherNode] then
				nodeQueue[#nodeQueue + 1] = otherNode
				reachable[#reachable + 1] = otherNode
				checked[otherNode] = true
			end
		end
	end

	return reachable
end

function ResourceNetwork:__tostring()
	return "ResourceNetwork [" .. self.id .. "]"
end

return ResourceNetwork
