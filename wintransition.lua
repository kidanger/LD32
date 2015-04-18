local drystal = require 'drystal'
local content = require 'content'

local Transition = {
}
Transition.__index = Transition

function Transition:init(game)
	self.game = game
	self.t = 0
	self.reseted = false
end

function Transition:update(dt)
	self.t = self.t + dt

	if self.t >= 1 and not self.reseted then
		self.game:next_level()
		self.reseted = true
	end

	if self.t >= 2 then
		self.game:reset()
		set_state(self.game)
		return
	end
end

function Transition:draw()
	self.game:draw()

	drystal.set_blend_mode(drystal.blends.add)
	drystal.camera.push()
	drystal.camera.reset()

	local max = math.max(W, H) * 4
	if self.t <= 1 then
		drystal.draw_sprite_resized(content.sprites.light,
							  W/2 - self.t*max/2, H/2 - self.t*max/2,
							  self.t * max, self.t * max)
	else
		local t = 1 - (self.t - 1)
		drystal.draw_sprite_resized(content.sprites.light,
							  W/2 - t*max/2, H/2 - t*max/2,
							  t * max, t * max)
	end
	drystal.camera.pop()
	drystal.set_blend_mode(drystal.blends.default)
end

return Transition

