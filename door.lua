local drystal = require 'drystal'
local content = require 'content'

local Door = {
	dx=0,
	dy=0,
	targetx=nil,
	targety=nil,
	timer=0,
	doing='closing',
}
Door.__index = Door

function Door:init(id, x, y, vertical)
	self.id = id
	self.vertical = vertical
	self.sprite = content.sprites.door_states[1]
	self.x = x + self.sprite.w / 2
	self.y = y + self.sprite.h / 2
end

function Door:update(dt)
	local d
	if self.doing == 'opening' then
		d = dt
	elseif self.doing == 'closing' then
		d = -dt
	end

	local hero = self.game.hero
	local w, h = self.sprite.w, self.sprite.h
	local box = {x=self.x-w/2, y=self.y-h/2, w=w, h=h}
	if not math.aabb_circle(box, hero.x, hero.y, hero.radius) then
		self.timer = math.clamp(self.timer + d, 0, #content.sprites.door_states - 1)
		self.sprite = content.sprites.door_states[1 + math.floor(self.timer+.5)]
	end
end

function Door:open()
	self.doing = 'opening'
end

function Door:close()
	self.doing = 'closing'
end

function Door:draw()
	drystal.set_color(content.colors[self.id + 1])
	if self.vertical then
		drystal.draw_sprite_rotated(self.sprite, self.x - self.sprite.w/2, self.y - self.sprite.h/2,
							  math.pi/2)
	else
		drystal.draw_sprite(self.sprite, self.x - self.sprite.w/2, self.y - self.sprite.h/2)
	end
end

return Door

