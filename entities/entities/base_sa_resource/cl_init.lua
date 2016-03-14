include("info.lua")
include("shared.lua")

function ENT:RenderPanel()
	if self.RenderBegin == nil or self.RenderEnd == nil then
		return
	end
end
