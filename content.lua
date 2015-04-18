local drystal = require 'drystal'

TS=32

local content = {
	spritesheet=assert(drystal.load_surface('spritesheet.png')),
	sprites={
		hero={
			x=0, y=0, w=32, h=32,
		},
		light={
			x=128, y=0, w=128, h=128,
		},
		dark={
		},
		goal={
			x=0, y=32*2, w=32, h=32,
		},
	},
	maps={
		'basics'
	},
}

content.spritesheet:set_filter(drystal.filters.nearest)
content.spritesheet:draw_from()

return content

