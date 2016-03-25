function ENT:Initialize()
	self:SetModel("models/props_phx/construct/glass/glass_plate1x1.mdl")
	if SERVER then
		self:ServerInitialize()
	end

	self.BaseClass.Initialize(self)
end
