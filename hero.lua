local drystal = require 'drystal'
local content = require 'content'

local Hero = {
	dx=0,
	dy=0,
}
Hero.__index = Hero

function Hero:init(x, y)
	self.sprite = content.sprites.hero
	self.x = x + self.sprite.w / 2
	self.y = y + self.sprite.h / 2
end

function Hero:update(dt)
	local friction = 0.92
	self.dx = self.dx * friction
	self.dy = self.dy * friction

	local speed = 15000 * dt
	if (drystal.keys.q or drystal.keys.d) and (drystal.keys.z or drystal.keys.s) then
		speed = speed / math.sqrt(2)
	end

	if drystal.keys.q then
		self.dx = -speed
	end
	if drystal.keys.d then
		self.dx = speed
	end

	local newx = self.x + self.dx * dt
	if not self.game:hero_collide(newx, self.y) then
		self.x = newx
	end

	if drystal.keys.z then
		self.dy = -speed
	end
	if drystal.keys.s then
		self.dy = speed
	end

	local newy = self.y + self.dy * dt
	if not self.game:hero_collide(self.x, newy) then
		self.y = newy
	end

	self.light:update(dt)
end

function Hero:draw()
	drystal.set_blend_mode(drystal.blends.add)
	drystal.set_color 'white'
	drystal.set_alpha(200)
	drystal.draw_sprite(self.sprite, self.x - self.sprite.w/2, self.y - self.sprite.h/2)
	drystal.set_blend_mode(drystal.blends.default)

	self.light:draw()
end

return Hero

