-- Copyright (C) Charles Leasure, Mark Dietzer, and Michael Johnson d.b.a SpaceAge - All Rights Reserved
-- See LICENSE file for more information.

function HOOKS:SetupPlayerDatatables(ply)
	ply:NetworkVar("String", 0, "AreaName")
	ply:NetworkVar("Bool", 0, "InSpace")
	ply:NetworkVar("Float", 0, "Energy")
	ply:NetworkVar("Float", 1, "Oxygen")
	ply:NetworkVar("Float", 2, "Coolant")
end

function HOOKS:PlayerNoClip(ply, desiredState)
	if not desiredState then
		-- player wants to leave noclip
		-- we don't care about that
		return
	end

	if not ply:GetInSpace() then
		-- player isn't in space
		-- we don't care about that either
		return
	end

	-- if they're not restricted, allow them to noclip
	-- otherwise, they can not noclip
	return not ply:IsRestricted()
end
