-- Copyright (C) Charles Leasure, Mark Dietzer, and Michael Johnson d.b.a SpaceAge - All Rights Reserved
-- See LICENSE file for more information.

-- based on the material design guidelines at https://www.google.com/design/spec/style/color.html

return {
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
