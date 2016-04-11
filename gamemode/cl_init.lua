-- Copyright (C) Charles Leasure, Mark Dietzer, and Michael Johnson d.b.a SpaceAge - All Rights Reserved
-- See LICENSE file for more information.

-- Basic gamemode information
include("info.lua")

-- Loader library
local loader = include("sh_loader.lua")

-- Load client files
loader.loadExtensions("client")
