local drystal = require 'drystal'

local Dark = require 'dark'
local content = require 'content'

local Map = {
	spawnx=0,
	spawny=0,
	goalx=0,
	goaly=0,
	maxx=0,
	maxy=0,
}
Map.__index = Map


function Map:init(name)
	self.surface = assert(drystal.load_surface(name .. '.png'))
	drystal.set_reload_callback(name, function() self:reload() end)
	self:reload()
end

function Map:reload()
	self.walls = {}
	self.safe = {}
	self.darks = {}
	for x=1, self.surface.w do
		for y=1, self.surface.h do
			local xx, yy = x * TS, y * TS
			local r, g, b, a = self.surface:get_pixel(x, y)
			if a==0 then
				goto continue
			elseif r==0 and g==255 and b==0 then
				self.spawnx, self.spawny = xx, yy
			elseif r==0 and g==0 and b==0 then
				table.insert(self.walls, {
					xx, yy,
					box={x=xx, y=yy, w=TS, h=TS},
				})
			elseif r==0 and g==255 and b==255 then
				table.insert(self.safe, {
					xx, yy,
					box={x=xx, y=yy, w=TS, h=TS},
				})
			elseif r==255 and g==0 and b==0 then
				table.insert(self.darks, new(Dark, xx, yy))
			elseif r==200 and g==255 and b==0 then
				self.goalx = xx
				self.goaly = yy
			elseif r >= 254 and b==255 then
				local id = g
				if r == 255 then
					new(Door, id, xx, yy)
				elseif r == 254 then
					new(Button, id, xx, yy)
				end
			end

			-- dark

			self.maxx = xx
			self.maxy = yy

			::continue::
		end
	end
end

function Map:update(dt)
	for _, d in ipairs(self.darks) do
		d:update(dt)
	end
end

function Map:predraw()
	drystal.set_color '#444044'
	drystal.draw_rect(TS, TS, self.maxx, self.maxy)

	drystal.set_color '#448044'
	drystal.draw_rect(self.spawnx, self.spawny, TS, TS)

	drystal.set_color 'black'
	for _, w in ipairs(self.walls) do
		local x, y = table.unpack(w)
		drystal.draw_rect(x, y, TS, TS)
	end
end

function Map:draw()
	drystal.set_color 'white'
	drystal.set_alpha(200)
	for _, s in ipairs(self.safe) do
		local x, y = table.unpack(s)
		drystal.draw_rect(x, y, TS, TS)
	end

	drystal.set_color 'white'
	drystal.set_alpha(255)
	drystal.draw_sprite(content.sprites.goal, self.goalx, self.goaly)

	drystal.set_blend_mode(drystal.blends.mult)
	drystal.set_alpha(255)
	drystal.set_color 'black'
	for _, d in ipairs(self.darks) do
		d:draw()
	end
	drystal.set_blend_mode(drystal.blends.default)

	drystal.set_color 'white'
	drystal.set_alpha(50 + 25+math.sin(TIME*5)*50)
	drystal.draw_sprite(content.sprites.goal, self.goalx, self.goaly)
end

function Map:get_spawn()
	return self.spawnx, self.spawny
end

function Map:get_goal()
	return self.goalx, self.goaly
end

return Map

