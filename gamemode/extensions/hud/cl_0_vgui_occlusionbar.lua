local PANEL = {}

function PANEL:Init()
	self:SetImage("spaceage/hud_drain.png")
	self:SetValue(0) -- initialize with a value of 0
end

local mathRemap = math.Remap

---
-- Sets the occlusion bar's value between 0 and 100
function PANEL:SetValue(val)
	self:SetSize(27, mathRemap(val, 0, 100, 63, 0))
end

vgui.Register("SAOcclusionBar", PANEL, "DImage")
