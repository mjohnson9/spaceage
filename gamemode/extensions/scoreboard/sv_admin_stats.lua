util.AddNetworkString("sa_adminstats")

-- function to get the last frame time
local FrameTime = FrameTime

do
	local requireSuccess = pcall(require, "fps")
	if requireSuccess then
		if engine and engine.RealFrameTime then
			FrameTime = engine.RealFrameTime
		elseif game and game.GetFrameTimeReal then
			FrameTime = game.GetFrameTimeReal
		end
	end
end

-- function to check if a user has access to receive admin stats
local function playerCanReceiveAdminStats(ply)
	return ply:query("sa serverstats")
end
ULib.ucl.registerAccess("sa serverstats", ULib.ACCESS_ADMIN, "Grants access to see server statistics in the scoreboard", "Diagnostics")

-- gets all of the players eligible to receive admin stats
local function getPlayersForAdminStats()
	local plys = {}

	for _, ply in ipairs(player.GetHumans()) do
		if playerCanReceiveAdminStats(ply) then
			plys[#plys + 1] = ply
		end
	end

	return plys
end

local function sendStats()
	local receivers = getPlayersForAdminStats()
	if #receivers <= 0 then
		-- no reason to assemble the message; no one will receive it
		return
	end

	net.Start("sa_adminstats")
	net.WriteFloat(FrameTime())
	net.Send(receivers)
end

timer.Create("sa_adminstats", 1, 0, sendStats)
