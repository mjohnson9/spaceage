-- Copyright (C) Charles Leasure, Mark Dietzer, and Michael Johnson d.b.a SpaceAge - All Rights Reserved
-- See LICENSE file for more information.

DeriveGamemode("sandbox")

GM.Name = "SpaceAge"

GM.ExportHash = "$Format:%H$"

local function detectVersion()
	if string.StartWith(GM.ExportHash, "$Format") then
		return "Development"
	end

	return GM.ExportHash
end

GM.Version = detectVersion()

MsgC(Color(0, 183, 235), "Loading SpaceAge version " .. GM.Version .. "\n")
