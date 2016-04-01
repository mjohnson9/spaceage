local PANEL = {}

function PANEL:Init()
	self:SetPaintBackground(false)

	self.background = vgui.Create("DImage", self)
	self.background:SetImage("spaceage/hud_background.png")
	self.background:SetPos(0, 0)
	self.background:SetSize(306, 111)


	self.environmentLabel = vgui.Create("DLabel", self)
	self.environmentLabel:SetPos(34, 5)
	self.environmentLabel:SetContentAlignment(5)
	self.environmentLabel:SetColor(Color(255, 255, 255))

	self.healthOcclusion = vgui.Create("SAOcclusionBar", self)
	self.healthOcclusion:SetPos(133, 28)

	self.healthLabel = vgui.Create("DLabel", self)
	self.healthLabel:SetFont("DermaDefaultBold")
	self.healthLabel:SetPos(115, 89)
	self.healthLabel:SetContentAlignment(5)
	self.healthLabel:SetColor(Color(214, 0, 3))

	self.energyOcclusion = vgui.Create("SAOcclusionBar", self)
	self.energyOcclusion:SetPos(179, 28)

	self.energyLabel = vgui.Create("DLabel", self)
	self.energyLabel:SetFont("DermaDefaultBold")
	self.energyLabel:SetPos(161, 88)
	self.energyLabel:SetContentAlignment(5)
	self.energyLabel:SetColor(Color(71, 230, 0))

	self.oxygenOcclusion = vgui.Create("SAOcclusionBar", self)
	self.oxygenOcclusion:SetPos(225, 28)

	self.oxygenLabel = vgui.Create("DLabel", self)
	self.oxygenLabel:SetFont("DermaDefaultBold")
	self.oxygenLabel:SetPos(207, 88)
	self.oxygenLabel:SetContentAlignment(5)
	self.oxygenLabel:SetColor(Color(255, 255, 255))

	self.coolantOcclusion = vgui.Create("SAOcclusionBar", self)
	self.coolantOcclusion:SetPos(271, 28)

	self.coolantLabel = vgui.Create("DLabel", self)
	self.coolantLabel:SetFont("DermaDefaultBold")
	self.coolantLabel:SetPos(253, 88)
	self.coolantLabel:SetContentAlignment(5)
	self.coolantLabel:SetColor(Color(0, 180, 231))

	-- initialize the environment as an empty string
	self:SetEnvironment("")

	-- initialize all of the values to 0
	self:SetHealthValue(0)
	self:SetEnergyValue(0)
	self:SetOxygenValue(0)
	self:SetCoolantValue(0)
end

function PANEL:SizeToContents()
	self:SetSize(self.background:GetSize())
end

function PANEL:SetEnvironment(name)
	self.environmentLabel:SetText(name)
end

local mathMax = math.max
local mathMin = math.min
local mathRound = math.Round

function PANEL:SetHealthValue(amt)
	local textValue = mathMax(0, amt)
	local occlusionValue = mathMin(100, textValue)

	self.healthLabel:SetText(mathRound(textValue))
	self.healthOcclusion:SetValue(occlusionValue)
end

function PANEL:SetEnergyValue(amt)
	local textValue = mathMax(0, amt)
	local occlusionValue = mathMin(100, textValue)

	self.energyLabel:SetText(mathRound(textValue))
	self.energyOcclusion:SetValue(occlusionValue)
end

function PANEL:SetOxygenValue(amt)
	local textValue = mathMax(0, amt)
	local occlusionValue = mathMin(100, textValue)

	self.oxygenLabel:SetText(mathRound(textValue))
	self.oxygenOcclusion:SetValue(occlusionValue)
end

function PANEL:SetCoolantValue(amt)
	local textValue = mathMax(0, amt)
	local occlusionValue = mathMin(100, textValue)

	self.coolantLabel:SetText(mathRound(textValue))
	self.coolantOcclusion:SetValue(occlusionValue)
end

vgui.Register("SAHUD", PANEL, "DPanel")
