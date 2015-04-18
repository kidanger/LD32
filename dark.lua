local drystal = require 'drystal'
local content = require 'content'

local Dark = {
	dx=0,
	dy=0,
	targetx=nil,
	targety=nil,
	w=512,
	h=512,
	radius=150,
}
Dark.__index = Dark

function Dark:init(x, y)
	self.sprite = content.sprites.light
	self.x = x + self.w / 2
	self.y = y + self.h / 2
end

function Dark:update(dt)
	if not self.targetx or not self.targety
		or math.distance(self.targetx, self.targety, self.hero.x, self.hero.y) > self.radius then
		self.targetx = self.hero.x
		self.targety = self.hero.y
	end

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

function Dark:draw()
	drystal.draw_sprite_resized(self.sprite, self.x - self.w/2, self.y - self.h/2,
							 self.w, self.h)
end

return Dark

