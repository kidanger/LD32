local drystal = require 'drystal'

local Dark = require 'dark'
local Door = require 'door'
local Button = require 'button'
local content = require 'content'

local Map = {
	spawnx=0,
	spawny=0,
	maxx=0,
	maxy=0,
}
Map.__index = Map

function Map:init(name)
	self.surface = assert(drystal.load_surface(name .. '.png'))
	if drystal.set_reload_callback then
		drystal.set_reload_callback(name, function() self:reload() end)
	end
	self:reload()
end

function Map:reload()
	self.predraw_buffer = nil
	walls = {}
	safes = {}
	self.darks = {}
	self.doors = {}
	self.buttons = {}
	self.items = {}
	local sx, sy
	local maxitems = 0
	for x=1, self.surface.w do
		walls[x] = {}
		safes[x] = {}
		for y=1, self.surface.h do
			local xx, yy = x * TS, y * TS
			local r, g, b, a = self.surface:get_pixel(x, y)
			if a==0 then
				goto continue
			elseif r==0 and g==255 and b==0 then
				self.spawnx, self.spawny = xx, yy
				sx, sy = x, y
			elseif r==0 and g==0 and b==0 then
				walls[x][y] = true
			elseif r==0 and g==255 and b==255 then
				safes[x][y] = true
			elseif r==255 and g==0 and b==0 then
				table.insert(self.darks, new(Dark, xx, yy))
			elseif r==200 and g==255 and b==0 then
				self.chest = new(require 'chest', xx, yy)
			elseif r==255 and g==255 and b==0 then
				table.insert(self.items, {x=xx+TS/2, y=yy+TS/2, radius=TS/2})
				maxitems = maxitems + 1
			elseif r >= 253 and b==255 then
				local id = g
				if r == 255 then
					table.insert(self.doors, new(Door, id, xx, yy, false))
				elseif r == 254 then
					table.insert(self.doors, new(Door, id, xx, yy, true))
				elseif r == 253 then
					table.insert(self.buttons, new(Button, id, xx, yy))
				end
			end

			::continue::
		end
	end
	self.maxx = self.surface.w * TS
	self.maxy = self.surface.h * TS
	if safes[sx][sy + 1]
	or safes[sx][sy - 1]
	or safes[sx + 1][sy]
	or safes[sx - 1][sy] then
		safes[sx][sy] = true
	end
	self.walls = self:merge(walls)
	self.safes = self:merge(safes)
	self.chest.maxitems = maxitems
	print(#self.walls, #self.safes)
end

function Map:merge(grid)
	local result = {}

	for x=1, self.surface.w do
		for y=1, self.surface.h do
			if grid[x][y] then
				local w = 1
				while x+w <= self.surface.w do
					if not grid[x+w][y] then
						break
					end
					w = w + 1
				end
				local h = 1
				while y+h <= self.surface.h do
					for xx=x, x+w-1 do
						if not grid[xx][y+h] then
							goto stop
						end
					end
					h = h + 1
				end
				::stop::
				for xx=x, x+w-1 do
					for yy=y, y+h-1 do
						grid[xx][yy] = nil
					end
				end
				table.insert(result, {x=x*TS, y=y*TS, w=w*TS, h=h*TS})
			end
		end
	end

	return result
end

function Map:update(dt)
	for _, d in ipairs(self.darks) do
		d:update(dt)
	end
	for _, d in ipairs(self.doors) do
		d:update(dt)
	end
	self.chest:update(dt)
end

function Map:predraw()
	if self.predraw_buffer then
		self.predraw_buffer:draw()
		goto others
	end
	self.predraw_buffer = drystal.new_buffer()
	self.predraw_buffer:use()
	drystal.set_color '#444044'
	drystal.draw_rect(TS, TS, self.maxx, self.maxy)

	drystal.set_color 'gray'
	drystal.set_alpha(100)
	for _, w in ipairs(self.walls) do
		drystal.draw_rect(w.x-2.5, w.y-2.5, w.w+5, w.h+5)
	end
	drystal.set_alpha(255)
	drystal.set_color 'black'
	for _, w in ipairs(self.walls) do
		drystal.draw_rect(w.x, w.y, w.w, w.h)
	end
	drystal.use_default_buffer()
	self.predraw_buffer:draw()

	::others::
	drystal.set_alpha(255)
	for _, d in ipairs(self.doors) do
		d:draw()
	end
	for _, b in ipairs(self.buttons) do
		b:draw()
	end
	for _, i in ipairs(self.items) do
		drystal.draw_sprite(content.sprites.item, i.x-i.radius, i.y-i.radius)
	end

	self.chest:draw()
end

function Map:draw()
	drystal.set_color 'white'
	drystal.set_alpha(200+math.sin(TIME*4) * 20)
	for _, s in ipairs(self.safes) do
		drystal.draw_rect(s.x, s.y, s.w, s.h)
	end

	drystal.set_blend_mode(drystal.blends.mult)
	drystal.set_alpha(255)
	drystal.set_color 'black'
	for _, d in ipairs(self.darks) do
		d:draw()
	end
	drystal.set_blend_mode(drystal.blends.default)

	self.chest:draw_after_stuff()
end

function Map:get_spawn()
	return self.spawnx, self.spawny
end

return Map

