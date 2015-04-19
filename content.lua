local drystal = require 'drystal'

TS=32

local content = {
	spritesheet=assert(drystal.load_surface('spritesheet.png')),
	sprites={
		hero={
			x=0, y=32*9, w=40, h=17,
		},
		hero_walk={
			{x=0, y=32*10, w=40, h=17},
			{x=0, y=32*11, w=40, h=17},
			{x=0, y=32*9, w=40, h=17},
		},
		oldlight={
			x=64, y=0, w=64, h=64,
		},
		light={
			x=128, y=0, w=128, h=128,
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
		safe={
			x=32*2, y=32*9, w=64, h=64
		},
		button_off={
			x=32*2, y=32*3, w=32, h=32,
		},
		button_on={
			x=32*2, y=32*4, w=32, h=32,
		},
		circle={
			x=32*5, y=32*5, w=64, h=64,
		},
		darkpart={
			x=32*5, y=32*7, w=64, h=64,
		},
		lightpart={
			x=32*5, y=32*9, w=64, h=64,
		},
		cursor={
			x=32*5, y=32*11, w=64, h=64,
		},
	},
	maps={
		'basics1',
		'basics2',
		'basics3',
		'dark1',
		'dark2',
		'dark3',
		'littledark1',
		'littledark2',
		'littledark3',
		'laby1',
		'laby2',
	},
	colors={
		'#30f030', '#3030f0', '#f03030', '#f0f030',
	},
	small_font=assert(drystal.load_font('arial.ttf', 24)) -- TODO: changeme
}

content.spritesheet:set_filter(drystal.filters.nearest)
content.spritesheet:draw_from()

return content

