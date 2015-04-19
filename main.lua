local drystal = require 'drystal'
local content = require 'content'

if drystal.is_web then
	drystal.run_js([[
				document.getElementById('text').style.display = 'none';
				]])
end

W, H = 900, 600

local state

function new(cls, ...)
	if cls.__call then
		return cls(...)
	end
	local self = setmetatable({}, cls)
	if self.init then
		self:init(...)
	end
	return self
end

function set_state(s)
	if state and state.on_exit then
		state:on_exit()
	end
	state = s
	if state.on_enter then
		state:on_enter()
	end
end

function drystal.init()
	collectgarbage()
	drystal.resize(W, H)
	drystal.show_cursor(false)
	state = new(require 'wintransition', new(require 'game'))
	content.musics.m1:play(true)
end

TIME = 0
function drystal.update(dt)
	TIME = TIME + 0.016
	state:update(0.016)
end

function drystal.draw()
	drystal.set_alpha(255)
	drystal.set_color '#191919'
	drystal.draw_background()

	state:draw()
end

drystal.keys = {}
local mute = false
local mute_sound = false
function drystal.key_press(k)
	drystal.keys[k] = true
	if state.key_press then
		state:key_press(k)
	end
	if k == 'm' then
		mute = not mute
		if mute then
			content.musics.m1:pause()
		else
			content.musics.m1:play()
		end
	elseif k == 'l' then
		mute_sound = not mute_sound
		if mute_sound then
			drystal.set_sound_volume(0)
		else
			drystal.set_sound_volume(1)
		end
	end
end

function drystal.key_release(k)
	drystal.keys[k] = false
	if state.key_release then
		state:key_release(k)
	end
end

function drystal.mouse_press(x, y, b)
	if state.mouse_press then
		state:mouse_press(x, y, b)
	end
end

function drystal.mouse_release(x, y, b)
	if state.mouse_release then
		state:mouse_release(x, y, b)
	end
end

function drystal.mouse_motion(x, y, dx, dy)
	if state.mouse_motion then
		state:mouse_motion(x, y, dx, dy)
	end
end

