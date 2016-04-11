AddCSLuaFile("cl_init.lua")
AddCSLuaFile("info.lua")
AddCSLuaFile("shared.lua")

include("info.lua")
include("shared.lua")


function ENT:SpawnFunction(ply, trace, entClassName)
	if not trace.Hit then
		return
	end

	local spawnPos = trace.HitPos + trace.HitNormal * 30
	local spawnAng = ply:EyeAngles()
	spawnAng.p = 0
	spawnAng.y = spawnAng.y + 270
	spawnAng.r = spawnAng.r + 90

	local ent = ents.Create(entClassName)
	ent:SetCreator(ply)
	ent:SetPos(spawnPos)
	ent:SetAngles(spawnAng)
	ent:Spawn()
	ent:Activate()

	--ent:DropToFloor()

	return ent

end
