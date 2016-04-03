-- Copyright (C) Charles Leasure, Mark Dietzer, and Michael Johnson d.b.a SpaceAge - All Rights Reserved
-- See LICENSE file for more information.

-- Add the basic gamemode information as a resource
AddCSLuaFile("info.lua")

-- Basic gamemode information
include("info.lua")

-- Add the loader library as a resource
AddCSLuaFile("sh_loader.lua")

-- Loader library
local loader = include("sh_loader.lua")

-- Add clientside Lua files as resources
loader.addClientFiles()

-- Load client files
loader.loadExtensions("server")
