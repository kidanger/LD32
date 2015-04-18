local drystal = require 'drystal'
local content = require 'content'

local Light = {
	dx=0,
	dy=0,
	targetx=nil,
	targety=nil,
	radius=32,
}
Light.__index = Light

function Light:init(x, y)
	self.sprite = content.sprites.light
	self.x = x + self.radius / 2
	self.y = y + self.radius / 2

	self.part = drystal.new_system(self.x, self.y)
	self.part:start()
	self.part:set_texture(content.spritesheet, content.sprites.lightpart.x, content.sprites.lightpart.y)
	self.part:set_colors { [0]='white', [1]='white' }
	self.part:set_sizes { [0]=8, [1]=1 }
	self.part:set_lifetime(2.)
	self.part:set_emission_rate(30)
	self.part:set_initial_velocity(30)
	self.part:set_initial_acceleration(0)
end

function Light:update(dt)
	self.part:set_position(self.x, self.y)
	self.part:update(dt)

	local friction = 0.98
	self.dx = self.dx * friction
	self.dy = self.dy * friction

	local speed = 11000 * dt
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

	if self.timer then
		self.timer:update(dt)
		if self.timer.finished then
			self.timer = nil
		end
	end
end

function Light:draw()
	drystal.set_blend_mode(drystal.blends.add)
	drystal.set_color 'white'
	drystal.set_alpha(200)
	drystal.draw_sprite(self.sprite, self.x - self.sprite.w/2, self.y - self.sprite.h/2)
	self.part:draw()
	drystal.set_blend_mode(drystal.blends.default)

	drystal.draw_sprite_resized(content.sprites.circle, self.x - self.radius, self.y - self.radius,
							 self.radius*2, self.radius*2)

	if self.targetx and self.timer then
		local radius = (self.timer.duration - self.timer.time) * self.radius
		drystal.draw_sprite_resized(content.sprites.circle, self.targetx - radius, self.targety - radius,
							  radius*2, radius*2)
	end
end

function Light:pop()
	self.timer = drystal.new_timer(.7)
end

return Light


