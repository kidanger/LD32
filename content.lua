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
		'end',
	},
	colors={
		'#30f030', '#3030f0', '#f03030', '#f0f030',
	},
	sounds={
		bup=assert(drystal.load_sound('sounds/bup.wav')),
		aww=assert(drystal.load_sound('sounds/aww.wav')),
		chest=assert(drystal.load_sound('sounds/chest.wav')),
		off=assert(drystal.load_sound('sounds/off.wav')),
		on=assert(drystal.load_sound('sounds/on.wav')),
		pickup=assert(drystal.load_sound('sounds/pickup.wav')),
		spawn=assert(drystal.load_sound('sounds/spwan.wav')),
		toudoc=assert(drystal.load_sound('sounds/toudoc.wav')),
		kill=assert(drystal.load_sound('sounds/kill.wav')),
		feet={
			assert(drystal.load_sound('sounds/foot1.wav')),
			assert(drystal.load_sound('sounds/foot2.wav')),
		},
	},
	musics={
		m1=assert(drystal.load_music('musics/m1.ogg')),
	},
	texts={
[[
You found a strange device. It says: "Collect light fragments".
Activation...
It glows!
Move with WASD, use left click to command the glowy thing.
]],
[[
It appears that the glowy thing can activate levers.
Interesting.
(Press 'm' to mute the music, 'l' to mute the sounds.)
]],
[[
The glowy thing looks hungry for light fragments.
Go collect some more.
Please.
]],
[[
There are some dark things not far from here.
They don't look so friendly.
You may want to avoid them.
Just 'saying.
]],
[[
Okay, that was not so hard.
Oh... There is more.
]],
[[
Snap, that was close.
]],
[[
"War is not nice"
    - Someone
]],
[[
Were they some kind of children? Dark children?
Well, at least they dropped light fragments when they died.
]],
[[
Look over here, it looks like a dorm.
Maybe we could collect some more fragments for the glowy thing.
]],
[[
Uff.
Light always triumphs over darkness.
]],
[[
Well, that was some kind of labyrinth.
They seems more and more furious.
]],
[[
Whoo!
Now that you've collected all the light fragments,
darkness won't be able to stand so much glowyness!
The world is safe. Light can prevail over all the things.
]]
	},
	small_font=assert(drystal.load_font('arial.ttf', 24)),
	font=assert(drystal.load_font('arial.ttf', 30)),
}

content.spritesheet:set_filter(drystal.filters.nearest)
content.spritesheet:draw_from()

return content

