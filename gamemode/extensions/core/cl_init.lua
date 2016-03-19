-- Copyright (C) Charles Leasure, Mark Dietzer, and Michael Johnson d.b.a SpaceAge - All Rights Reserved
-- See LICENSE file for more information.

function HOOKS:OnEntityCreated(ent)
	if ent:IsPlayer() then
		-- hotfix for https://github.com/Facepunch/garrysmod-issues/issues/892
		ent:InstallDataTable()
		player_manager.RunClass(ent, "SetupDataTables")
	end
end
