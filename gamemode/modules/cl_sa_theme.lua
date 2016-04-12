-- Copyright (C) Charles Leasure, Mark Dietzer, and Michael Johnson d.b.a SpaceAge - All Rights Reserved
-- See LICENSE file for more information.

-- based on the material design guidelines at https://www.google.com/design/spec/style/color.html

surface.CreateFont("MaterialDisplay3", {
	font = "Roboto",
	size = 56,
	weight = 400
})

surface.CreateFont("MaterialDisplay2", {
	font = "Roboto",
	size = 45,
	weight = 400
})

surface.CreateFont("MaterialDisplay1", {
	font = "Roboto",
	size = 34,
	weight = 400
})

surface.CreateFont("MaterialHeadline", {
	font = "Roboto",
	size = 24,
	weight = 400
})

surface.CreateFont("MaterialTitle", {
	font = "Roboto",
	size = 20,
	weight = 500
})

surface.CreateFont("MaterialSubheading", {
	font = "Roboto",
	size = 16,
	weight = 400
})

surface.CreateFont("MaterialBody2", {
	font = "Roboto",
	size = 14,
	weight = 500
})

surface.CreateFont("MaterialBody1", {
	font = "Roboto",
	size = 14,
	weight = 400
})

surface.CreateFont("MaterialCaption", {
	font = "Roboto",
	size = 12,
	weight = 400
})

surface.CreateFont("MaterialButton", {
	font = "Roboto",
	size = 14,
	weight = 500
})

return {
	fonts = {
		display3 = "MaterialDisplay3",
		display2 = "MaterialDisplay2",
		display1 = "MaterialDisplay1",
		headline = "MaterialHeadline",
		title = "MaterialTitle",
		subheading = "MaterialSubheading",
		body2 = "MaterialBody2",
		body1 = "MaterialBody1",
		caption = "MaterialCaption",
		button = "MaterialButton"
	},

	primary = { -- indigo
		mid = Color(63, 81, 181),
		light = Color(197, 202, 233),
		dark = Color(48, 63, 159)
	},

	accent = { -- pink
		mid = Color(255, 64, 129),
		light = Color(255, 128, 171),
		dark = Color(245, 0, 87)
	},

	darkText = {
		primary = Color(0, 0, 0, 255 * 0.87),
		secondary = Color(0, 0, 0, 255 * 0.54),
		hint = Color(0, 0, 0, 255 * 0.38),
		disabled = Color(0, 0, 0, 255 * 0.38) -- alias of hint
	},

	lightText = {
		primary = Color(255, 255, 255, 255),
		secondary = Color(255, 255, 255, 255 * 0.70),
		hint = Color(255, 255, 255, 255 * 0.50),
		disabled = Color(255, 255, 255, 255 * 0.50) -- alias of hint
	},

	background = {
		white = Color(255, 255, 255),
		light = Color(250, 250, 250),
		mid = Color(245, 245, 245),
		dark = Color(224, 224, 224)
	},

	divider = {
		dark = Color(0, 0, 0, 255 * 0.12),
		light = Color(255, 255, 255, 255 * 0.12)
	}
}
