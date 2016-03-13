function GM:HUDPaint()
	self.BaseClass.HUDPaint(self)

	draw.SimpleTextOutlined(self.LocalPlayer:GetAreaName(), "DermaDefault", 10, 10, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
end
