local drystal = require 'drystal'
local content = require 'content'

local Dark = {
	dx=0,
	dy=0,
	targetx=nil,
	targety=nil,
	w=512,
	h=512,
	radius=130,
	radius_sight=1000,
}
Dark.__index = Dark

function Dark:init(x, y)
	self.sprite = content.sprites.light
	self.x = x
	self.y = y
	self.targetx = self.x
	self.targety = self.y
	self.wander_timer = drystal.new_timer(0.2)

	self.part = drystal.new_system(x, y)
	self.part:start()
	--self.part:set_texture(content.spritesheet, content.sprites.darkpart.x, content.sprites.darkpart.y)
	self.part:set_colors { [0]='black', [1]='black' }
	self.part:set_sizes { [0]=40, [1]=3 }
	self.part:set_lifetime(1.4)
	self.part:set_emission_rate(10)
	self.part:set_initial_velocity(300)
	self.part:set_initial_acceleration(-350)
end

function Dark:update(dt)
	self.part:set_position(self.x, self.y)
	self.part:update(dt)
	if self.game:inside_dark_collide(self.targetx, self.targety) then
		self.targetx = self.x
		self.targety = self.y
		self.wander_timer = drystal.new_timer(0.5,
										function()
											self:wander()
										end)
		self.part:set_emission_rate(6)
	elseif self.wander_timer then
		self.wander_timer:update(dt)
		if self.wander_timer.finished then
			self.wander_timer = nil
		end
		self.part:set_emission_rate(6)
	elseif math.distance(self.targetx, self.targety, self.hero.x, self.hero.y) < self.radius_sight then
		self.targetx = self.hero.x
		self.targety = self.hero.y
		self.part:set_emission_rate(12)
	end

	local speed = 9000 * dt
	if self.targetx then
		self.dx = self.dx + (math.clamp(self.targetx - self.x, -speed, speed) - self.dx) * 0.1
		local newx = self.x + self.dx * dt
		if not self.game:dark_collide(newx, self.y, self.radius) then
			self.x = newx
		end
	end
	if self.targety then
		self.dy = self.dy + (math.clamp(self.targety - self.y, -speed, speed) - self.dy) * 0.1
		local newy = self.y + self.dy * dt
		if not self.game:dark_collide(self.x, newy, self.radius) then
			self.y = newy
		end
	end
end

function Dark:draw()
	drystal.set_color'black'
	drystal.draw_sprite_resized(self.sprite, self.x - self.w/2, self.y - self.h/2,
							 self.w, self.h)
	--drystal.set_color'red'
	--drystal.draw_circle(self.x, self.y, self.radius)
	--drystal.set_color'red'
	--drystal.draw_circle(self.targetx, self.targety, 30)
end

function Dark:draw_particles()
	self.part:draw()
end

function Dark:wander()
	local a = math.random() * math.pi * 2
	self.targetx = self.x + math.cos(a) * self.radius * 5
	self.targety = self.x + math.sin(a) * self.radius * 5
	self.targetx = math.clamp(self.targetx, 0, self.game.map.maxx)
	self.targety = math.clamp(self.targety, 0, self.game.map.maxy)
	self.wander_timer = drystal.new_timer(1.5)
end

return Dark

