-- Copyright (C) Charles Leasure, Mark Dietzer, and Michael Johnson d.b.a SpaceAge - All Rights Reserved
-- See LICENSE file for more information.

loader = {}

-- localize commonly used functions
local include = include
local AddCSLuaFile = AddCSLuaFile

include("sh_replacement_require.lua")
AddCSLuaFile("sh_replacement_require.lua")

do
	local ourPaths = {
		GM.FolderName .. "/gamemode/modules/sh_?.lua",
	}

	if SERVER then
		table.insert(ourPaths, GM.FolderName .. "/gamemode/modules/sv_?.lua")
	end

	if CLIENT then
		table.insert(ourPaths, GM.FolderName .. "/gamemode/modules/cl_?.lua")
	end

	local existingPaths = string.Split(package.path, ";")

	local newPaths = ""

	for _, path in ipairs(ourPaths) do
		if not table.HasValue(existingPaths, path) then
			newPaths = newPaths .. path .. ";"
		end
	end

	package.path = newPaths .. package.path
end

local hooksMT = {}

hooksMT.__index = hooksMT

local gmHooks = {}

-- We need to have access to the Sandbox gamemode in order to call it as a base
-- class
local sandboxGM = baseclass.Get("gamemode_sandbox")

-- cache because we're calling it on every hook return
local unpack = unpack

local function hasReturnVal(t)
	for _, v in ipairs(t) do
		if v ~= nil then
			return true
		end
	end

	return false
end

local function createGMHook(hookName)
	local baseFunc = sandboxGM[hookName]
	return function(...)
		for _, f in pairs(gmHooks[hookName]) do
			local retVals = {f(...)}
			if hasReturnVal(retVals) then
				return unpack(retVals)
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

local function loadExtensions(filesToLoad)
	for _, filePath in ipairs(filesToLoad) do
		local _, fileName = string.match(filePath, "(.-)([^\\/]-%.?([^%.\\/]*))$")
		MsgN("\t" .. fileName)
		loadExtension(filePath)
	end
end

local function loadFiles(filesToLoad)
	for _, filePath in ipairs(filesToLoad) do
		MsgN("[LOADER] Loading: " .. filePath)
		include(filePath)
	end
end

---
-- Gets all autoloaded files in a given directory
-- @param directory the directory to find files in
-- @param context (optional) specifies the context to load the context files for.
-- can be "client", "server", "all", or "none". if not specified, the current Lua
-- context will be used.
-- @return a sequential table containing the loadable file paths, already in the
-- order that they should be loaded.
local function getLoadableFiles(directory, context)
	local contextPrefix

	if context ~= nil then
		if context == "server" then
			contextPrefix = "sv"
		elseif context == "client" then
			contextPrefix = "cl"
		elseif context == "all" then
			local fileNames = file.Find(directory .. "/*.lua", "LUA")
			table.sort(fileNames)

			local files = {}
			for _, fileName in ipairs(fileNames) do
				table.insert(files, directory .. "/" .. fileName)
			end

			return files
		elseif context == "none" then
			contextPrefix = nil
		else
			error("invalid value for context. valid values are: client, server, all, none")
		end
	else
		if SERVER then
			contextPrefix = "sv"
		elseif CLIENT then
			contextPrefix = "cl"
		else
			error("This really shouldn't happen. We're neither a client nor server.")
		end
	end

	local filesToLoad = {}

	local sharedFiles = file.Find(directory .. "/sh_*.lua", "LUA")
	table.sort(sharedFiles)

	for _, fileName in ipairs(sharedFiles) do
		table.insert(filesToLoad, directory .. "/" .. fileName)
	end

	if contextPrefix ~= nil then
		local contextFiles = file.Find(directory .. "/" .. contextPrefix .. "_*.lua", "LUA")
		table.sort(contextFiles)

		for _, fileName in ipairs(contextFiles) do
			table.insert(filesToLoad, directory .. "/" .. fileName)
		end
	end

	return filesToLoad
end

---
-- Loads all extensions and includes for the current Lua context
function loader.loadExtensions()
	loadFiles(getLoadableFiles(GM.FolderName .. "/gamemode/lib"))

	local extensionFolder = GM.FolderName .. "/gamemode/extensions"
	local _, extensionFolders = file.Find(extensionFolder .. "/*", "LUA")
	for _, folder in SortedPairsByValue(extensionFolders) do
		MsgN("[LOADER] Loading extension \"" .. folder .. "\"")

		loadExtensions(getLoadableFiles(extensionFolder .. "/" .. folder))
	end

	loadFiles(getLoadableFiles(GM.FolderName .. "/gamemode/player_class", "all"))
	loadFiles(getLoadableFiles(GM.FolderName .. "/gamemode/metatables"))
end

local function addCSLuaFiles(filePaths)
	for _, filePath in ipairs(filePaths) do
		MsgN("[LOADER] Client file added: " .. filePath)
		AddCSLuaFile(filePath)
	end
end

---
-- Adds all clientside files as resources
function loader.addClientFiles()
	-- Many addons fail to add themselves as resources. As such, we go through
	-- and add all of our addons as resources for the client. This isn't very
	-- efficient for the client's loading time, but it ensures that they won't
	-- have content missing due to workshop addons.
	for _, addon in ipairs(engine.GetAddons()) do
		if addon.wsid ~= nil then
			resource.AddWorkshop(addon.wsid)
			MsgN("[LOADER] Add workshop addon for download: " .. addon.title)
		end
	end


	-- this is the folder where all of our extensions are
	local extensionFolder = GM.FolderName .. "/gamemode/extensions"

	local _, extensionFolders = file.Find(extensionFolder .. "/*", "LUA")
	for _, folder in SortedPairsByValue(extensionFolders) do
		addCSLuaFiles(getLoadableFiles(extensionFolder .. "/" .. folder, "client"))
	end

	addCSLuaFiles(getLoadableFiles(GM.FolderName .. "/gamemode/player_class", "all"))
	addCSLuaFiles(getLoadableFiles(GM.FolderName .. "/gamemode/modules", "client"))
	addCSLuaFiles(getLoadableFiles(GM.FolderName .. "/gamemode/metatables", "client"))
	addCSLuaFiles(getLoadableFiles(GM.FolderName .. "/gamemode/lib", "client"))
end
