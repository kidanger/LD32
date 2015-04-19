local drystal = require 'drystal'
local content = require 'content'

local Chest = {
	dx=0,
	dy=0,
	targetx=nil,
	targety=nil,
	radius=16,
	items=0,
	maxitems=0,
}
Chest.__index = Chest

function Chest:init(x, y)
	self.sprite = content.sprites.chest
	self.x = x + self.radius
	self.y = y + self.radius
end

function Chest:update(dt)
end

function Chest:draw()
	drystal.set_color 'white'
	drystal.set_alpha(255)
	drystal.draw_sprite(self.sprite, self.x - self.sprite.w / 2, self.y - self.sprite.h / 2)

	drystal.set_color 'yellow'
	local text = ('{shadowx:2|shadowy:3|%d/%d}'):format(self.items, self.maxitems)
	if self.maxitems < 10 then
		content.small_font:draw(text, self.x - 14, self.y - self.sprite.h - 5, drystal.aligns.center)
	else
		content.small_font:draw(text, self.x - 27, self.y - self.sprite.h - 5, drystal.aligns.center)
	end
end

function Chest:draw_after_stuff()
	drystal.set_color 'white'
	drystal.set_alpha(50 + 25+math.sin(TIME*5)*50)
	drystal.draw_sprite(self.sprite, self.x - self.sprite.w / 2, self.y - self.sprite.h / 2)
end

return Chest

