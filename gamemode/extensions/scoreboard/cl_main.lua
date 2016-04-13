-- Copyright (C) Charles Leasure, Mark Dietzer, and Michael Johnson d.b.a SpaceAge - All Rights Reserved
-- See LICENSE file for more information.

local sa_theme = require("sa_theme")

-- This code was originally copied from the stock sandbox scoreboard.
-- Thanks, garry!

local curAdminStats = {}

net.Receive("sa_adminstats", function()
	curAdminStats.frameTime = net.ReadFloat()
end)

-- A single card in the server stats
local STAT_ENTRY = {
	Init = function(self)
		self.title = vgui.Create("DLabel")
	end,
	Paint = function(self, w, h)
		local c = sa_theme.divider.dark
		surface.SetDrawColor(c.r, c.g, c.b, c.a)
		surface.DrawRect(0, h - 1, w - 72, 1)
	end
}
STAT_ENTRY = vgui.RegisterTable(STAT_ENTRY, "DPanel")

local ADMIN_STATS = {
	Init = function(self)
		self.headerBox = self:Add("Panel")
		self.headerBox:Dock(TOP)

		self.title = self.headerBox:Add("DLabel")
		self.title:SetFont(sa_theme.fonts.title)
		self.title:SetTextColor(sa_theme.lightText.primary)
		self.title:Dock(FILL)
		self.title:SetContentAlignment(5)
		self.title:SetText("Server Stats")
		self.title:SizeToContents()

		self.headerBox:SetHeight(self.title:GetTall() + (16 * 2))

		self.stats = self:Add("DScrollPanel")
		self.stats:Dock(FILL)
	end,
	PerformLayout = function(self)
		self:SetSize(200, ScrH() - 200)
	end,
	Paint = function(self, w, h)
		do
			local c = sa_theme.background.mid

			surface.SetDrawColor(c.r, c.g, c.b, c.a)
			surface.DrawRect(0, 0, w, h)
		end

		do
			local x, y = self.headerBox:GetPos()
			local hW, hH = self.headerBox:GetSize()

			local c = sa_theme.primary.light

			surface.SetDrawColor(c.r, c.g, c.b, c.a)
			surface.DrawRect(x, y, hW, hH)
		end
	end,
}
ADMIN_STATS = vgui.RegisterTable(ADMIN_STATS, "DPanel")

-- This defines a circular avatar image
-- It uses stencils to mask out the parts of the image not inside the circle

local function circlePoly( _x, _y, _r, _points )
	-- U is how many times the texture should repeat along the X
	local _u = ( _x + _r * 1 ) - _x

	-- V is how many times the texture should repeat along the Y
	local _v = ( _y + _r * 1 ) - _y

	local _slices = ( 2 * math.pi ) / _points
	local _poly = { }
	for i = 0, _points - 1 do
		local _angle = ( _slices * i ) % _points
		local x = _x + _r * math.cos( _angle )
		local y = _y + _r * math.sin( _angle )
		table.insert( _poly, { x = x, y = y, u = _u, v = _v } )
	end

	return _poly
end

circlePoly = circlePoly(16, 16, 16, 32)
local circleMaterial = Material("effects/flashlight001")

local CIRCLE_AVATAR = {
	Init = function(self)
		self.Avatar = vgui.Create("AvatarImage", self)
		self.Avatar:SetPaintedManually(true)
	end,
	SetPlayer = function(self, ...)
		self.Avatar:SetPlayer(...)
	end,
	PerformLayout = function(self)
		self.Avatar:SetSize(self:GetWide(), self:GetTall())
	end,
	Paint = function(self, w, h)
		render.ClearStencil()
		render.SetStencilEnable(true)

		render.SetStencilWriteMask(1)
		render.SetStencilTestMask(1)

		render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
		render.SetStencilPassOperation(STENCILOPERATION_ZERO)
		render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
		render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
		render.SetStencilReferenceValue(1)

		draw.NoTexture();
		surface.SetMaterial(circleMaterial)
		surface.SetDrawColor(color_black)
		surface.DrawPoly(circlePoly)

		render.SetStencilFailOperation(STENCILOPERATION_ZERO)
		render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
		render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
		render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
		render.SetStencilReferenceValue(1)

		self.Avatar:SetPaintedManually(false)
		self.Avatar:PaintManual()
		self.Avatar:SetPaintedManually(true)

		render.SetStencilEnable(false)
		render.ClearStencil()
	end
}
CIRCLE_AVATAR = vgui.RegisterTable(CIRCLE_AVATAR)

--
-- This defines a new panel type for the player row. The player row is given a player
-- and then from that point on it pretty much looks after itself. It updates player info
-- in the think function, and removes itself when the player leaves the server.
--
local PLAYER_LINE = {
	Init = function(self)
		self.Avatar = vgui.CreateFromTable(CIRCLE_AVATAR, self)
		self.Avatar:Dock(LEFT)
		self.Avatar:SetSize(32, 32)

		self.Name = self:Add("DLabel")
		self.Name:Dock(FILL)
		self.Name:SetFont(sa_theme.fonts.subheading)
		self.Name:SetTextColor(sa_theme.darkText.secondary)
		self.Name:DockMargin(24, 0, 8, 0)

		self.Mute = self:Add("DImageButton")
		self.Mute:SetSize(32, 32)
		self.Mute:SetColor(sa_theme.darkText.hint)
		self.Mute:Dock(RIGHT)
		self.Mute:DockMargin(8, 0, 8, 0)

		self.Ping = self:Add("DLabel")
		self.Ping:Dock(RIGHT)
		self.Ping:SetWidth(50)
		self.Ping:SetFont(sa_theme.fonts.body1)
		self.Ping:SetTextColor(sa_theme.darkText.hint)
		self.Ping:SetContentAlignment(5)
		self.Ping:DockMargin(8, 0, 8, 0)

		self:Dock(TOP)
		self:DockPadding(16, 8, 16, 8)
		self:SetHeight(48)
		self:DockMargin(0, 0, 0, 0)
	end,
	Setup = function(self, pl)
		self.Player = pl
		self.Avatar:SetPlayer(pl, 32)
		self:Think(self)
	end,
	Think = function(self)
		if not IsValid(self.Player) then
			self:SetZPos(9999) -- Causes a rebuild
			self:Remove()

			return
		end

		if self.PName == nil or self.PName ~= self.Player:Nick() then
			self.PName = self.Player:Nick()
			self.Name:SetText(self.PName)
			self.Name:SizeToContents()
		end

		if self.NumPing == nil or self.NumPing ~= self.Player:Ping() then
			self.NumPing = self.Player:Ping()
			self.Ping:SetText(self.NumPing .. "ms")
			self.Ping:SizeToContents()
		end

		--
		-- Change the icon of the mute button based on state
		--
		if self.Muted == nil or self.Muted ~= self.Player:IsMuted() then
			self.Muted = self.Player:IsMuted()

			if self.Muted then
				self.Mute:SetImage("spaceage/scoreboard/muted.png")
			else
				self.Mute:SetImage("spaceage/scoreboard/unmuted.png")
			end

			self.Mute.DoClick = function()
				self.Player:SetMuted(not self.Muted)
			end
		end
	end,
	Paint = function(self, w, h)
		local c = sa_theme.divider.dark
		surface.SetDrawColor(c.r, c.g, c.b, c.a)
		surface.DrawRect(72, h - 1, w - 72, 1)
	end
}

--
-- Convert it from a normal table into a Panel Table based on DPanel
--
PLAYER_LINE = vgui.RegisterTable(PLAYER_LINE, "DPanel")

local function playerScoreboardSort(a, b)
	local aName, bName = a:Nick():lower(), b:Nick():lower()

	return aName < bName
end

local function localPlayerCanViewAdminStats()
	return LocalPlayer():query("sa serverstats")
end

--
-- Here we define a new panel table for the scoreboard. It basically consists
-- of a header and a scrollpanel - into which the player lines are placed.
--
local SCORE_BOARD = {
	Init = function(self)
		self.Header = self:Add("Panel")
		self.Header:Dock(TOP)

		self.Name = self.Header:Add("DLabel")
		self.Name:SetFont(sa_theme.fonts.display2)
		self.Name:SetTextColor(sa_theme.lightText.primary)
		self.Name:Dock(FILL)
		self.Name:SetContentAlignment(5)

		self.Scores = self:Add("DScrollPanel")
		self.Scores:Dock(FILL)

		self.adminStats = vgui.CreateFromTable(ADMIN_STATS, self)
		self.adminStats:Dock(LEFT)
		if not localPlayerCanViewAdminStats() then
			-- the local player isn't allowed to view admin stats; hide them
			self.adminStats:Hide()
		end
	end,
	HideAdminStats = function(self)
		self.adminStats:Hide()
	end,
	ShowAdminStats = function(self)
		self.adminStats:Show()
	end,
	PerformLayout = function(self)
		local extraWidth = 0
		if self.adminStats:IsVisible() then
			extraWidth = self.adminStats:GetWide()
		end
		self:SetSize(700 + extraWidth, ScrH() - 200)
		self:Center()
	end,
	Paint = function(self, w, h)
		do
			local c = sa_theme.background.light

			surface.SetDrawColor(c.r, c.g, c.b, c.a)
			surface.DrawRect(0, 0, w, h)
		end

		do
			local x, y = self.Header:GetPos()
			local hW, hH = self.Header:GetSize()

			local c = sa_theme.primary.mid

			surface.SetDrawColor(c.r, c.g, c.b, c.a)
			surface.DrawRect(x, y, hW, hH)
		end
	end,
	Think = function(self)
		local curServerName = GetHostName()
		if self.serverName == nil or self.serverName ~= curServerName then
			self.serverName = curServerName
			self.Name:SetText(self.serverName)
			self.Name:SizeToContents()
			self.Header:SetHeight(self.Name:GetTall() + (16 * 2))
		end

		local plyrs = player.GetAll()
		table.sort(plyrs, playerScoreboardSort)

		for k, pl in pairs(plyrs) do -- loop through each player
			if not IsValid(pl.ScoreEntry) then
				-- if the player doesn't have a scoreboard entry, create one
				pl.ScoreEntry = vgui.CreateFromTable(PLAYER_LINE, pl.ScoreEntry)
				pl.ScoreEntry:Setup(pl)
				self.Scores:AddItem(pl.ScoreEntry)
			end

			-- set the player's scoreboard entry to be in the correct position
			pl.ScoreEntry:SetZPos(k)
		end
	end
}

SCORE_BOARD = vgui.RegisterTable(SCORE_BOARD, "EditablePanel")

if IsValid(_G._saScoreboardPanel) then
	-- this usually happens on reload; remove the old scoreboard panel
	_G._saScoreboardPanel:Remove()
end

local scoreboardPanel

--[[---------------------------------------------------------
	Name: gamemode:ScoreboardShow( )
	Desc: Sets the scoreboard to visible
-----------------------------------------------------------]]
function HOOKS:ScoreboardShow()
	if not IsValid(scoreboardPanel) then
		scoreboardPanel = vgui.CreateFromTable(SCORE_BOARD)
		_G._saScoreboardPanel = scoreboardPanel
	end

	if IsValid(scoreboardPanel) then
		scoreboardPanel:Show()
		scoreboardPanel:MakePopup()
		scoreboardPanel:SetKeyboardInputEnabled(false)
	end

	return true -- return to prevent calling sandbox's scoreboard
end

--[[---------------------------------------------------------
	Name: gamemode:ScoreboardHide( )
	Desc: Hides the scoreboard
-----------------------------------------------------------]]
function HOOKS:ScoreboardHide()
	if IsValid(scoreboardPanel) then
		scoreboardPanel:Hide()
	end

	return true -- return to prevent calling sandbox's scoreboard
end

local function uclChanged()
	print("UCL changed")
	if not IsValid(scoreboardPanel) then return end -- the panel hasn't been created; no need to update

	if localPlayerCanViewAdminStats() then
		scoreboardPanel:ShowAdminStats()
	else
		scoreboardPanel:HideAdminStats()
	end
end
hook.Add("UCLChanged", "sa_scoreboard", uclChanged) -- we can't use HOOKS because ULib won't call the gamemode hook table
