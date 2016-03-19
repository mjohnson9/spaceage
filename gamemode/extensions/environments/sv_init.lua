-- Copyright (C) Charles Leasure, Mark Dietzer, and Michael Johnson d.b.a SpaceAge - All Rights Reserved
-- See LICENSE file for more information.

function HOOKS:PostSetupPlayerDatatables(ply)
	if ply.planetDirty then
		ply:ApplyPlanet(ply.planets[#ply.planets])
		ply.planetDirty = nil
	end
end
