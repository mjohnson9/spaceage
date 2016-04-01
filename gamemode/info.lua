-- Copyright (C) Charles Leasure, Mark Dietzer, and Michael Johnson d.b.a SpaceAge - All Rights Reserved
-- See LICENSE file for more information.

DeriveGamemode("sandbox")

GM.Name = "SpaceAge"
GM.VCSInfo = "$Id$"
if #GM.VCSInfo == 47 then -- VCSInfo should be 47 characters long if it was substituted properly
	GM.Version = string.sub(GM.VCSInfo, -42, -2)
else
	GM.Version = "Unknown"
end
MsgC(Color(0, 183, 235), "Loading SpaceAge version " .. GM.Version .. "\n")
