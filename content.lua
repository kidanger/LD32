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
		chest={
			x=0, y=32*2, w=32, h=32,
		},
		item={
			x=32*1, y=32*2, w=32, h=32,
		},
		door_states={
			{x=0, y=32*3, w=32, h=32},
			{x=0, y=32*4, w=32, h=32},
			{x=0, y=32*5, w=32, h=32},
			{x=0, y=32*6, w=32, h=32},
			{x=0, y=32*7, w=32, h=32},
			{x=0, y=32*8, w=32, h=32},
		},
		button_off={
			x=32*2, y=32*3, w=32, h=32,
		},
		button_on={
			x=32*2, y=32*4, w=32, h=32,
		},
	},
	maps={
		'basics'
	},
	small_font=assert(drystal.load_font('arial.ttf', 24)) -- TODO: changeme
}

content.spritesheet:set_filter(drystal.filters.nearest)
content.spritesheet:draw_from()

return content

