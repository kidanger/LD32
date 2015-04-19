local drystal = require 'drystal'
local content = require 'content'

local Hero = {
	dx=0,
	dy=0,
	radius=10,
	health=1,
	item=false,
	dangle=0,
	walk=0,
}
Hero.__index = Hero

function Hero:init(x, y)
	self.sprite = content.sprites.hero
	self.x = x + self.sprite.w / 2
	self.y = y + self.sprite.h / 2
end

local UP = 'w'
local DOWN = 's'
local LEFT = 'a'
local RIGHT = 'd'

function Hero:update(dt)
	local friction = 0.85
	local dx = self.dx * friction
	local dy = self.dy * friction

	local speed = 15500 * dt
	if (drystal.keys[RIGHT] or drystal.keys[LEFT]) and (drystal.keys[UP] or drystal.keys[DOWN]) then
		speed = speed / math.sqrt(2)
	elseif (drystal.keys['right'] or drystal.keys['left']) and (drystal.keys['up'] or drystal.keys['down']) then
		speed = speed / math.sqrt(2)
	end

	if drystal.keys[RIGHT] or drystal.keys['right'] then
		dx = speed
	end
	if drystal.keys[LEFT] or drystal.keys['left'] then
		dx = -speed
	end

	self.dx = dx
	local newx = self.x + self.dx * dt
	if not self.game:hero_collide(newx, self.y) then
		self.x = newx
	end

	if drystal.keys[UP] or drystal.keys['up'] then
		dy = -speed
	end
	if drystal.keys[DOWN] or drystal.keys['down'] then
		dy = speed
	end

	self.dy = dy
	local newy = self.y + self.dy * dt
	if not self.game:hero_collide(self.x, newy) then
		self.y = newy
	end

	if self.game:inside_dark_collide(self.x, self.y) then
		self.health = math.min(self.health + dt * .2, 1)
	end
	self.light:update(dt)

	local angle = math.atan2(self.dy, self.dx) + math.pi / 2
	while angle < self.dangle - math.pi do
		angle = angle + math.pi * 2
	end
	while angle > self.dangle + math.pi do
		angle = angle - math.pi * 2
	end
	self.dangle = self.dangle + (angle - self.dangle) * .2

	local speed = self.dx ^ 2 + self.dy ^ 2
	local fact = speed / 130000
	self.walk = self.walk + dt * fact
end

function Hero:draw()
	drystal.set_color 'white'
	drystal.set_alpha(255)

	local transform = {
		 angle=self.dangle,
		 wfactor=1,
		 hfactor=1,
	}

	local sp = self.sprite
	local speed = self.dx ^ 2 + self.dy ^ 2
	if speed > 3000 then
		local id = 1 + math.floor(self.walk*10) % 2
		sp = content.sprites.hero_walk[id]
		if id ~= self.oldid then
			content.sounds.feet[id]:play(.5)
		end
		self.oldid = id
	end
	drystal.draw_sprite(sp, self.x - sp.w/2, self.y - sp.h/2, transform)

	self.light:draw()
end

function Hero:take_damage(dmg)
	self.health = math.max(0, self.health - dmg)
end

return Hero

