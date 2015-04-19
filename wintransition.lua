local drystal = require 'drystal'
local content = require 'content'

local Transition = {
}
Transition.__index = Transition

function Transition:init(game)
	self.game = game
	self.t = 0
	self.tt = 0
	self.reseted = false
	self.stopped = false
	self.text = content.texts[self.game.map_index + 1]
end

local function pause(char)
	if char == '.' or char == '!' or char == '?' then
		return 2
	end
	return 15
end

function Transition:update(dt)
	self.t = self.t + dt

	if self.t >= 1 and not self.reseted then
		self.game:next_level()
		self.reseted = true
	end

	if not self.stopped and self.t >= 1 then
		local len = math.floor(self.tt)
		local factor = pause(self.text:sub(len, len))
		self.tt = self.tt + dt * factor
		if self.tt >= #self.text + 20 then
			self.stopped = true
		end
		self.t = 1
		local newlen = math.floor(self.tt)
		if newlen ~= len and newlen < #self.text and self.text:sub(newlen, newlen) ~= ' ' then
			content.sounds.feet[2]:play(.8)
		end
	elseif self.t >= 2 then
		self.game:reset()
		set_state(self.game)
	end
end

function Transition:draw()
	self.game:draw()

	drystal.set_blend_mode(drystal.blends.add)
	drystal.camera.push()
	drystal.camera.reset()

	local max = math.max(W, H) * 4
	if self.t < 1 then
		drystal.draw_sprite_resized(content.sprites.light,
							  W/2 - self.t*max/2, H/2 - self.t*max/2,
							  self.t * max, self.t * max)
	else
		local t = 1 - (self.t - 1)
		drystal.draw_sprite_resized(content.sprites.light,
							  W/2 - t*max/2, H/2 - t*max/2,
							  t * max, t * max)
		drystal.draw_sprite_resized(content.sprites.light,
							  W/2 - t*max/2, H/2 - t*max/2,
							  t * max, t * max)
	end
	drystal.set_blend_mode(drystal.blends.default)

	if not self.stopped then
		local len = math.floor(self.tt)
		if len > #self.text then
			drystal.set_alpha((1 - (len - #self.text) / 20) * 255)
		end
		drystal.set_color 'black'
		content.font:draw(self.text:sub(1, len), W * .1, H * .6)
	end
	drystal.camera.pop()
end

return Transition

