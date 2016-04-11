-- Copyright (C) Charles Leasure, Mark Dietzer, and Michael Johnson d.b.a SpaceAge - All Rights Reserved
-- See LICENSE file for more information.

local sa_colors = require("sa_colors")

-- This code was originally copied from the stock sandbox scoreboard.
-- Thanks, garry!

surface.CreateFont("ScoreboardDefault", {
	font = "Helvetica",
	size = 22,
	weight = 800
})

surface.CreateFont("ScoreboardDefaultTitle", {
	font = "Helvetica",
	size = 32,
	weight = 800
})

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
		--[[self.AvatarButton = self:Add("DButton")
		self.AvatarButton:Dock(LEFT)
		self.AvatarButton:SetSize(32, 32)

		self.AvatarButton.DoClick = function()
			self.Player:ShowProfile()
		end]]

		self.Avatar = vgui.CreateFromTable(CIRCLE_AVATAR, self)
		self.Avatar:Dock(LEFT)
		self.Avatar:SetSize(32, 32)
		self.Avatar.DoClick = function()

	end

		self.Name = self:Add("DLabel")
		self.Name:Dock(FILL)
		self.Name:SetFont("ScoreboardDefault")
		self.Name:SetTextColor(sa_colors.darkText.secondary)
		self.Name:DockMargin(24, 0, 8, 0)

		self.Mute = self:Add("DImageButton")
		self.Mute:SetSize(32, 32)
		self.Mute:SetColor(sa_colors.darkText.hint)
		self.Mute:Dock(RIGHT)
		self.Mute:DockMargin(8, 0, 8, 0)

		self.Ping = self:Add("DLabel")
		self.Ping:Dock(RIGHT)
		self.Ping:SetWidth(50)
		self.Ping:SetFont("ScoreboardDefault")
		self.Ping:SetTextColor(sa_colors.darkText.hint)
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
	--local friend = self.Player:GetFriendStatus()
	--MsgN( pl, " Friend: ", friend )
	Think = function(self)
		if not IsValid(self.Player) then
			self:SetZPos(9999) -- Causes a rebuild
			self:Remove()

			return
		end

		if self.PName == nil or self.PName ~= self.Player:Nick() then
			self.PName = self.Player:Nick()
			self.Name:SetText(self.PName)
		end

		if self.NumPing == nil or self.NumPing ~= self.Player:Ping() then
			self.NumPing = self.Player:Ping()
			self.Ping:SetText(self.NumPing .. "ms")
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
		local c = sa_colors.divider.dark
		surface.SetDrawColor(c.r, c.g, c.b, c.a)
		surface.DrawRect(72, 47, w - 72, 1)
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

--
-- Here we define a new panel table for the scoreboard. It basically consists
-- of a header and a scrollpanel - into which the player lines are placed.
--
local SCORE_BOARD = {
	Init = function(self)
		self.Header = self:Add("Panel")
		self.Header:Dock(TOP)
		self.Name = self.Header:Add("DLabel")
		self.Name:SetFont("ScoreboardDefaultTitle")
		self.Name:SetTextColor(sa_colors.lightText.primary)
		self.Name:Dock(FILL)
		self.Name:SetHeight(40)
		self.Name:SetContentAlignment(5)
		self.Header:SetHeight(40 + (16 * 2))
		--self.Name:SetExpensiveShadow(2, Color(0, 0, 0, 200))
		--self.NumPlayers = self.Header:Add( "DLabel" )
		--self.NumPlayers:SetFont( "ScoreboardDefault" )
		--self.NumPlayers:SetTextColor( Color( 255, 255, 255, 255 ) )
		--self.NumPlayers:SetPos( 0, 100 - 30 )
		--self.NumPlayers:SetSize( 300, 30 )
		--self.NumPlayers:SetContentAlignment( 4 )
		self.Scores = self:Add("DScrollPanel")
		self.Scores:Dock(FILL)
	end,
	PerformLayout = function(self)
		self:SetSize(700, ScrH() - 200)
		self:SetPos(ScrW() / 2 - 350, 100)
	end,
	Paint = function(self, w, h)
		draw.RoundedBox(4, 0, 0, w, h, sa_colors.background.light) -- main background
		do
			-- in a separate scope to keep from cluttering the function scope
			local x, y = self.Header:GetPos()
			local hW, hH = self.Header:GetSize()
			draw.RoundedBox(4, x, y, hW, hH, sa_colors.primary.mid)
		end
	end,
	--draw.RoundedBox( 4, 0, 0, w, h, Color( 0, 0, 0, 200 ) )
	Think = function(self, w, h)
		self.Name:SetText(GetHostName())
		--
		-- Loop through each player, and if one doesn't have a score entry - create it.
		--
		local plyrs = player.GetAll()
		table.sort(plyrs, playerScoreboardSort)

		for k, pl in pairs(plyrs) do
			if not IsValid(pl.ScoreEntry) then
				pl.ScoreEntry = vgui.CreateFromTable(PLAYER_LINE, pl.ScoreEntry)
				pl.ScoreEntry:Setup(pl)
				self.Scores:AddItem(pl.ScoreEntry)
			end
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
