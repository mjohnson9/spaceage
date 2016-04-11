AddCSLuaFile("cl_init.lua")
AddCSLuaFile("info.lua")
AddCSLuaFile("shared.lua")

include("info.lua")
include("shared.lua")

local resource_network = require("resource_network")

function ENT:ServerInitialize()
	self:PhysicsInit(SOLID_VPHYSICS)
end

function ENT:GenerateResource(name, amtPerSec)
	local amt = amtPerSec * self.thinkTime
	return self:RawGenerateResource(name, amt)
end

function ENT:RawGenerateResource(name, amount)
	local ourNetwork = self:GetNetwork()
	if ourNetwork == nil then
		return
	end

	return ourNetwork:injectResource(name, amount)
end

function ENT:ConsumeResource(name, amtPerSec)
	local amt = amtPerSec * self.thinkTime
	return self:RawConsumeResource(name, amt)
end

function ENT:RawConsumeResource(name, amount)
	local ourNetwork = self:GetNetwork()
	if ourNetwork == nil then
		return false
	end

	return ourNetwork:consumeResource(name, amount)
end

-- cache for performance
local mathMin = math.min

function ENT:StoreResource(resourceType, amount)
	local currentlyStored = self["Get" .. resourceType](self)

	local willStore = mathMin(self.ResourceStorage[resourceType] - currentlyStored, amount)
	self["Set" .. resourceType](self, currentlyStored + willStore)

	return willStore
end

function ENT:PullResource(resourceType, amount)
	local currentlyStored = self["Get" .. resourceType](self)

	local willConsume = mathMin(currentlyStored, amount)
	self["Set" .. resourceType](self, currentlyStored - willConsume)

	return willConsume
end

function ENT:IsInNetwork(target)
	local network = self:GetNetwork()
	return network ~= nil and network == target:GetNetwork()
end

function ENT:ResourceLink(target)
	local ourNetwork = self:GetNetwork()
	local targetNetwork = target:GetNetwork()

	if ourNetwork == nil and targetNetwork == nil then
		-- neither resource has a network, create a new network and add a link
		ourNetwork = resource_network:new(self)
		ourNetwork:addLink(self, target)
		return
	end

	if ourNetwork == nil and targetNetwork ~= nil then
		-- the target has a network and we don't, just link into their network
		targetNetwork:addLink(target, self)
		return
	end

	if ourNetwork ~= nil and targetNetwork == nil then
		-- we have a network and the target doesn't, just add them to ours
		ourNetwork:addLink(self, target)
		return
	end

	-- both entities have networks, merge the two
	ourNetwork:addLink(self, target)
end

function ENT:SetNetwork(network)
	self._resourceNetwork = network

	if network == nil then
		self:SetNetworkID(0)
		return
	end

	self:SetNetworkID(network.id)
end

function ENT:GetNetwork()
	return self._resourceNetwork
end

function ENT:OnRemove()
	local ourNetwork = self:GetNetwork()
	if ourNetwork ~= nil then
		ourNetwork:entityRemoved(self) -- leave our current network
	end
end
