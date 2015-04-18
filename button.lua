local drystal = require 'drystal'
local content = require 'content'

local Button = {
	dx=0,
	dy=0,
	targetx=nil,
	targety=nil,
	radius=16,
	on=false,
}
Button.__index = Button

function Button:init(id, x, y)
	self.id = id
	self.sprite = content.sprites.button_off
	self.x = x + self.sprite.w / 2
	self.y = y + self.sprite.h / 2
end

function Button:update(dt)
end

function Button:draw()
	drystal.set_color(content.colors[self.id + 1])
	if self.on then
		self.sprite = content.sprites.button_on
	else
		self.sprite = content.sprites.button_off
	end
	drystal.draw_sprite(self.sprite, self.x - self.sprite.w/2, self.y - self.sprite.h/2)
end

return Button

