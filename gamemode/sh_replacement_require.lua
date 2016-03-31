-- Copyright (C) Charles Leasure, Mark Dietzer, and Michael Johnson d.b.a SpaceAge - All Rights Reserved
-- See LICENSE file for more information.

local oldRequire
-- if this is a reload, use the original require function
if replacementRequire and replacementRequire.oldRequire ~= nil then
	oldRequire = replacementRequire.oldRequire
end

-- remove all of our own old loaders
if replacementRequire and replacementRequire.ourLoaders ~= nil then
	for _, v in pairs(replacementRequire.ourLoaders) do
		table.RemoveByValue(package.loaders, v)
	end
end

replacementRequire = {
	ourLoaders = {}
}

-- store the old require function
if oldRequire == nil then
	oldRequire = require
end
replacementRequire.oldRequire = oldRequire

-- override require with a new version that follows most of the Lua
-- specification
function require(name)
	if package.loaded[name] ~= nil then
		return package.loaded[name]
	end

	local loader, extraArgument
	local reasons = {}

	for _, loaderFunc in ipairs(package.loaders) do
		local thisLoader, thisArg = loaderFunc(name)
		if thisLoader ~= nil then
			if type(thisLoader) == "function" then
				loader = thisLoader
				extraArgument = thisArg
				break
			else
				reasons[#reasons + 1] = tostring(thisLoader)
			end
		end
	end

	if loader == nil then
		local errorReason = "module '" .. tostring(name) .. "' not found:" .. table.concat(reasons)

		error(errorReason)
	end

	local retVal = loader(name, extraArgument)
	if retVal ~= nil then
		package.loaded[name] = retVal
	end

	if package.loaded[name] == nil then
		package.loaded[name] = true
	end

	return package.loaded[name]
end

----- PATH LOADING -----


local function binaryModuleSearcher(name)
	-- we don't look at package.cpath for this because we have no control over
	-- the path of the binary loading

	local prefix
	if SERVER then
		prefix = "gmsv"
	elseif CLIENT then
		prefix = "gmcl"
	end

	local suffix
	if system.IsWindows() then
		suffix = "win32"
	elseif system.IsOSX() then
		suffix = "osx"
	elseif system.IsLinux() then
		suffix = "linux"
	end

	if prefix == nil then
		return "binary: unknown environment"
	elseif suffix == nil then
		return "binary: unknown operating system"
	end

	local binPath = "lua/bin/" .. prefix .. "_" .. name .. "_" .. suffix .. ".dll"
	if file.Exists(binPath, "Game") then
		return oldRequire
	end

	return "\n\tno file '" .. binPath .. "'"
end

replacementRequire.ourLoaders["binary"] = binaryModuleSearcher
table.insert(package.loaders, binaryModuleSearcher)

----- PATH LOADING -----

local defaultPath = "includes/modules/?.lua"

if package.path == nil then
	package.path = defaultPath
end

local function pathLoader(name, path)
	local ret = include(path)
	if ret ~= nil then
		return ret
	end
end

local function pathSearcher(name)
	local reasons = {}

	local paths = string.Split(package.path, ";")
	for _, path in ipairs(paths) do
		if #path == 0 then
			path = defaultPath
		end

		path = string.Replace(path, "?", name)

		if file.Exists(path, "LUA") then
			return pathLoader, path
		end

		reasons[#reasons + 1] = "no file '" .. path .. "'"
	end

	return "\n\t" .. string.Implode("\n\t", reasons)
end

replacementRequire.ourLoaders["path"] = pathSearcher
table.insert(package.loaders, pathSearcher)
