-- Copyright (C) Charles Leasure, Mark Dietzer, and Michael Johnson d.b.a SpaceAge - All Rights Reserved
-- See LICENSE file for more information.

loader = {}

-- localize commonly used functions
local include = include
local AddCSLuaFile = AddCSLuaFile

-- store the old require function
local oldRequire = require

-- override require with a new version that searches our gamemode's modules
-- folder
function require(name, ...)
	local modulePath = (GM or GAMEMODE).FolderName .. "/gamemode/modules"

	local sharedPath = modulePath .. "/sh_" .. name .. ".lua"
	if file.Exists(sharedPath, "LUA") then
		include(sharedPath)
		return package.loaded[name]
	end

	local contextPath
	if SERVER then
		contextPath = modulePath .. "/sv_" .. name .. ".lua"
	else
		contextPath = modulePath .. "/cl_" .. name .. ".lua"
	end

	if file.Exists(contextPath, "LUA") then
		include(contextPath)
		return package.loaded[name]
	end

	return oldRequire(name, ...)
end

local hooksMT = {}

hooksMT.__index = hooksMT

local gmHooks = {}

-- We need to have access to the Sandbox gamemode in order to call it as a base
-- class
local sandboxGM = baseclass.Get("gamemode_sandbox")

-- cache because we're calling it on every hook return
local unpack = unpack

local function createGMHook(hookName)
	local baseFunc = sandboxGM[hookName]
	return function(...)
		for _, f in pairs(gmHooks[hookName]) do
			local retVals = {f(...)}
			if #retVals > 0 then
				local shouldReturn = false
				for _, v in ipairs(retVals) do
					if v ~= nil then
						shouldReturn = true
						break
					end
				end

				if shouldReturn then
					return unpack(retVals)
				end
			end
		end

		if baseFunc ~= nil then
			return baseFunc(...)
		end
	end
end

-- adds a hook to the GAMEMODE table
local function addGMHook(hookName, func)
	local hookTable = gmHooks[hookName]

	if hookTable == nil then
		hookTable = {}
		gmHooks[hookName] = hookTable
	end

	if GM[hookName] == nil then
		GM[hookName] = createGMHook(hookName)
	end

	hookTable[#hookTable + 1] = func
end

-- by virtue of an index being set in the HOOKS table, adds a hook to the
-- GAMEMODE table
function hooksMT:__newindex(hookName, func)
	assert(type(func) == "function", "HOOKS can only accept functions")

	addGMHook(hookName, func)
end

---
-- loadExtension does the necessary setup to load an extension before actually
-- including it and applying changes to support it
-- @param the path to the extension
local function loadExtension(path)
	HOOKS = {
		_fileName = path
	}
	setmetatable(HOOKS, hooksMT)

	include(path)

	HOOKS = nil
end

---
-- Loads all extensions starting with prefix_ in alphabetical order.
-- @param context either "client" or "server". Will load modules accordingly.
function loader.loadExtensions(context)
	if context ~= "server" and context ~= "client" then
		error("context must be \"server\" or \"client\"")
	end

	local server = (context == "server")

	-- this is the folder where all of our extensions are
	local extensionFolder = GM.FolderName .. "/gamemode/extensions"

	local _, extensionFolders = file.Find(extensionFolder .. "/*", "LUA")

	local prefix
	if server then
		prefix = "sv"
	else
		prefix = "cl"
	end

	local thirdpartyFolder = GM.FolderName .. "/gamemode/lib"

	for _, thirdpartyFile in SortedPairs(file.Find(thirdpartyFolder .. "/sh_*.lua", "LUA"), true) do
		MsgN("[LOADER] Loading third party library: " .. thirdpartyFile)
		include(thirdpartyFolder .. "/" .. thirdpartyFile)
	end

	for _, thirdpartyFile in SortedPairs(file.Find(thirdpartyFolder .. "/" .. prefix .. "_*.lua", "LUA"), true) do
		MsgN("[LOADER] Loading third party library: " .. thirdpartyFile)
		include(thirdpartyFolder .. "/" .. thirdpartyFile)
	end

	for _, folder in SortedPairs(extensionFolders, true) do
		MsgN("[LOADER] Loading extension \"" .. folder .. "\"")

		-- always load shared modules first
		for _, sharedFile in SortedPairs(file.Find(extensionFolder .. "/" .. folder .. "/sh_*.lua", "LUA"), true) do
			MsgN("\t" .. sharedFile)
			loadExtension(extensionFolder .. "/" .. folder .. "/" .. sharedFile)
		end

		-- now load based on context
		for _, contextFile in SortedPairs(file.Find(extensionFolder .. "/" .. folder .. "/" .. prefix .. "_*.lua", "LUA"), true) do
			MsgN("\t" .. contextFile)
			loadExtension(extensionFolder .. "/" .. folder .. "/" .. contextFile)
		end
	end

	local playerClassFolder = GM.FolderName .. "/gamemode/player_class"

	for _, playerClass in SortedPairs(file.Find(playerClassFolder .. "/*.lua", "LUA"), true) do
		MsgN("Loading player class: " .. playerClass)
		include(playerClassFolder .. "/" .. playerClass)
	end

	local metatablesFolder = GM.FolderName .. "/gamemode/metatables"

	for _, metatableFile in SortedPairs(file.Find(metatablesFolder .. "/sh_*.lua", "LUA"), true) do
		MsgN("[LOADER] Loading metatable: " .. metatableFile)
		include(metatablesFolder .. "/" .. metatableFile)
	end

	for _, metatableFile in SortedPairs(file.Find(metatablesFolder .. "/" .. prefix .. "_*.lua", "LUA"), true) do
		MsgN("[LOADER] Loading metatable: " .. metatableFile)
		include(metatablesFolder .. "/" .. metatableFile)
	end
end

---
-- Adds all clientside files as resources
function loader.addClientFiles()
	-- TODO: Remove this once the author of the EVE model pack fixes their addon
	-- See: https://steamcommunity.com/sharedfiles/filedetails/comments/148070174
	resource.AddWorkshop("148070174") -- EVE Online ls3 addon

	-- this is the folder where all of our extensions are
	local extensionFolder = GM.FolderName .. "/gamemode/extensions"

	local _, extensionFolders = file.Find(extensionFolder .. "/*", "LUA")

	for _, folder in SortedPairs(extensionFolders, true) do
		MsgN("[LOADER] Adding client extension: " .. folder)
		-- add shared files first
		for _, sharedFile in SortedPairs(file.Find(extensionFolder .. "/" .. folder .. "/sh_*.lua", "LUA"), true) do
			AddCSLuaFile(extensionFolder .. "/" .. folder .. "/" .. sharedFile)
			MsgN("\t" .. sharedFile)
		end

		-- add client files second
		for _, contextFile in SortedPairs(file.Find(extensionFolder .. "/" .. folder .. "/cl_*.lua", "LUA"), true) do
			AddCSLuaFile(extensionFolder .. "/" .. folder .. "/" .. contextFile)
			MsgN("\t" .. contextFile)
		end
	end

	local playerClassFolder = GM.FolderName .. "/gamemode/player_class"

	for _, playerClass in SortedPairs(file.Find(playerClassFolder .. "/*.lua", "LUA"), true) do
		local path = playerClassFolder .. "/" .. playerClass
		AddCSLuaFile(path)
		MsgN("[LOADER] Client file added: " .. path)
	end

	local modulesFolder = GM.FolderName .. "/gamemode/modules"

	for _, moduleFile in SortedPairs(file.Find(modulesFolder .. "/sh_*.lua", "LUA"), true) do
		local path = modulesFolder .. "/" .. moduleFile
		AddCSLuaFile(path)
		MsgN("[LOADER] Client file added: " .. path)
	end

	for _, moduleFile in SortedPairs(file.Find(modulesFolder .. "/cl_*.lua", "LUA"), true) do
		local path = modulesFolder .. "/" .. moduleFile
		AddCSLuaFile(path)
		MsgN("[LOADER] Client file added: " .. path)
	end

	local metatablesFolder = GM.FolderName .. "/gamemode/metatables"

	for _, metatableFile in SortedPairs(file.Find(metatablesFolder .. "/sh_*.lua", "LUA"), true) do
		local path = metatablesFolder .. "/" .. metatableFile
		AddCSLuaFile(path)
		MsgN("[LOADER] Client file added: " .. path)
	end

	for _, metatableFile in SortedPairs(file.Find(metatablesFolder .. "/cl_*.lua", "LUA"), true) do
		local path = metatablesFolder .. "/" .. metatableFile
		AddCSLuaFile(path)
		MsgN("[LOADER] Client file added: " .. path)
	end

	local thirdpartyFolder = GM.FolderName .. "/gamemode/lib"

	for _, thirdpartyFile in SortedPairs(file.Find(thirdpartyFolder .. "/sh_*.lua", "LUA"), true) do
		local path = thirdpartyFolder .. "/" .. thirdpartyFile
		AddCSLuaFile(path)
		MsgN("[LOADER] Client file added: " .. path)
	end

	for _, thirdpartyFile in SortedPairs(file.Find(thirdpartyFolder .. "/cl_*.lua", "LUA"), true) do
		local path = thirdpartyFolder .. "/" .. thirdpartyFile
		AddCSLuaFile(path)
		MsgN("[LOADER] Client file added: " .. path)
	end
end
