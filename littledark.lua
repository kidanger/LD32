local drystal = require 'drystal'
local content = require 'content'

local LittleDark = {
	w=32,
	h=32,
	radius=16,
	health=1,
	little=true,
}
LittleDark.__index = LittleDark

function LittleDark:init(x, y)
	self.sprite = content.sprites.light
	self.x = x + 16
	self.y = y + 16
	self.part = drystal.new_system(self.x, self.y)
	self.part:start()
	self.part:set_texture(content.spritesheet, content.sprites.darkpart.x, content.sprites.darkpart.y)
	self.part:set_colors { [0]='black', [1]='black' }
	self.part:set_sizes { [0]=10, [1]=3 }
	self.part:set_lifetime(.6)
	self.part:set_emission_rate(3)
	self.part:set_initial_velocity(100)
	self.part:set_initial_acceleration(-300)
end

function LittleDark:update(dt)
	self.part:update(dt)

	if math.random() < 0.2 * dt then
		-- cry, little dark, cry
		self.part:emit(12)
	end
end

function LittleDark:draw()
	drystal.draw_sprite_resized(self.sprite, self.x - self.w/2, self.y - self.h/2,
							 self.w, self.h)
end

function LittleDark:draw_particles()
	self.part:draw()
end

function LittleDark:take_damage(dmg)
	self.health = math.max(0, self.health - dmg)
	self.part:set_emission_rate(30)
end

function LittleDark:be_calm()
	self.part:set_emission_rate(3)
end

return LittleDark

