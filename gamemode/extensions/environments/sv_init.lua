-- Copyright (C) Charles Leasure, Mark Dietzer, and Michael Johnson d.b.a SpaceAge - All Rights Reserved
-- See LICENSE file for more information.

function HOOKS:PostSetupPlayerDatatables(ply)
	if ply.planetDirty then
		ply:ApplyPlanet(ply.planets[#ply.planets])
		ply.planetDirty = nil
	end
end

function HOOKS:PostPlayerDeath(ply)
	-- reset all of the player's suit resources to 0
	ply:SetEnergy(0)
	ply:SetOxygen(0)
	ply:SetCoolant(0)
end

function HOOKS:PlayerExitedPlanet(ply)
	if not ply:GetInSpace() then
		-- player isn't in space
		return
	end

	if ply:IsRestricted() then
		-- this player is restricted
		if ply:GetMoveType() == MOVETYPE_NOCLIP then
			-- the player is currently noclipping
			-- let's disable that
			ply:SetMoveType(MOVETYPE_WALK)
		end
	end
end
