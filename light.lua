local drystal = require 'drystal'
local content = require 'content'

local Light = {
	dx=0,
	dy=0,
	targetx=nil,
	targety=nil,
}
Light.__index = Light

function Light:init(x, y)
	self.sprite = content.sprites.light
	self.x = x + self.sprite.w / 2
	self.y = y + self.sprite.h / 2
end

function Light:update(dt)
	local friction = 0.98
	self.dx = self.dx * friction
	self.dy = self.dy * friction

	local speed = 10000 * dt
	if self.targetx then
		self.dx = self.dx + (math.clamp(self.targetx - self.x, -speed, speed) - self.dx) * 0.1
	end
	if self.targety then
		self.dy = self.dy + (math.clamp(self.targety - self.y, -speed, speed) - self.dy) * 0.1
	end

	self.dx = self.dx
	self.dy = self.dy

	self.x = self.x + self.dx * dt
	self.y = self.y + self.dy * dt
end

function Light:draw()
	drystal.set_blend_mode(drystal.blends.add)
	drystal.set_color 'white'
	drystal.set_alpha(200)
	drystal.draw_sprite(self.sprite, self.x - self.sprite.w/2, self.y - self.sprite.h/2)
	drystal.set_blend_mode(drystal.blends.default)
end

return Light


