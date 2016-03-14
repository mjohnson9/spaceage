module("resource_network")

local mt = {}
mt.__index = mt


function new()
	local network = {}

	setmetatable(network, mt)

	return network
end
