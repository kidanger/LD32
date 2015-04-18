local drystal = require 'drystal'
local content = require 'content'

local Transition = {
}
Transition.__index = Transition

function Transition:init(game)
	self.game = game
	self.t = 1
	self.game:reset()
end

function Transition:update(dt)
	self.t = self.t - dt

	if self.t <= 0 then
		set_state(self.game)
		return
	end
end

function Transition:draw()
	self.game:draw_simple()

	drystal.postfx('vignette', 1 - self.t*.9, 0.0)
end

return Transition

