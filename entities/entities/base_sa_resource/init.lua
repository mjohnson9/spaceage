AddCSLuaFile("cl_init.lua")
AddCSLuaFile("info.lua")
AddCSLuaFile("shared.lua")

include("info.lua")
include("shared.lua")

function ENT:ServerInitialize()
	self:PhysicsInit(SOLID_VPHYSICS)
end

function ENT:GetResourceNetwork()
	return self.resourceNetwork
end

function ENT:IsInNetwork(target)
	return self.resourceNetwork ~= nil and self.resourceNetwork == target.resourceNetwork
end

local function resourceEntityCompare(ent1, ent2)
	return ent1:EntIndex() < ent2:EntIndex()
end

local function newNetwork()
	local network = {
		members = sorted_set.new(resourceEntityCompare)
	}

	-- TODO: Replace this ugly hack with some better way of generating network IDs
	network.id = tonumber(string.sub(tostring(network), 7)) -- use the network's memory location to generate its ID

	return network
end

function ENT:ResourceLink(target)
	if self.resourceNetwork == nil and target.resourceNetwork == nil then
		-- neither resource has a network, create a new network

		local network = newNetwork()

		self:JoinNetwork(network)
		target:JoinNetwork(network)

		return
	end

	error("not yet implemented")
end

function ENT:JoinNetwork(network)
	if self.resourceNetwork ~= nil then
		self.resourceNetwork.members:remove(self)
	end

	if network == nil then
		self.resourceNetwork = nil
		self:SetNetworkID(0)
		return
	end

	self.resourceNetwork = network
	self.resourceNetwork.members:insert(self)

	self:SetNetworkID(self.resourceNetwork.id)
end
