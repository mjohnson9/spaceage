-- Copyright (C) Charles Leasure, Mark Dietzer, and Michael Johnson d.b.a SpaceAge - All Rights Reserved
-- See LICENSE file for more information.

function HOOKS:SetupPlayerDatatables(ply)
	ply:NetworkVar("String", 0, "AreaName")
	ply:NetworkVar("Bool", 0, "InSpace")
	ply:NetworkVar("Int", 0, "Oxygen")
	ply:NetworkVar("Int", 1, "Coolant")
end
