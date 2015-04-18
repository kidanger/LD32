local drystal = require 'drystal'
drystal.set_reload_callback = drystal.set_reload_callback or function() end

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
	drystal.resize(W, H)
	state = new(require 'game')
end

TIME = 0
function drystal.update(dt)
	while dt > 0.016 do
		TIME = TIME + 0.016
		state:update(0.016)
		dt = dt - 0.016
	end
	if dt > 0.001 then
		state:update(dt)
	end
end

function drystal.draw()
	drystal.set_alpha(255)
	drystal.set_color 'black'
	drystal.draw_background()

	state:draw()
end

drystal.keys = {}
function drystal.key_press(k)
	drystal.keys[k] = true
	if state.key_press then
		state:key_press(k)
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

