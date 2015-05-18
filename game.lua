local drystal = require 'drystal'

local Hero = require 'hero'
local Map = require 'map'
local Light = require 'light'
local Dark = require 'dark'
local Transition = require 'transition'
local WinTransition = require 'wintransition'
local content = require 'content'

local Game = {
	map_index=0,
	cx=0, cy=0, czoom=1,
	mx=W/2, my=H/2, mangle=0,
	cmx=W/2, cmy=H/2,
	zoom=0.85,
	h=1,
}
Game.__index = Game

function Game:init()
	self:reset()
end

function Game:update(dt)
	if self.map_index == 0 then return end
	local cx, cy = self.hero.x - W/2, self.hero.y - H/2
	self.cx = self.cx + (cx - self.cx) * 0.2
	self.cy = self.cy + (cy - self.cy) * 0.2
	self.czoom = self.czoom + (self.zoom - self.czoom) * 0.2
	self.cmx = self.cmx + (self.mx - self.cmx) * .4
	self.cmy = self.cmy + (self.my - self.cmy) * .4
	self.mangle = self.mangle + dt * .7

	for _, d in ipairs(self.map.darks) do
		d.game = self
		d.hero = self.hero
	end
	for _, d in ipairs(self.map.doors) do
		d.game = self
	end

	self.map:update(dt)
	self.hero:update(dt)

	local l = self.hero.light
	for _, b in ipairs(self.map.buttons) do
		local touched = math.circle_circle(b.x, b.y, b.radius, l.x, l.y, l.radius)
		if touched and not b.on then
			for _, d in ipairs(self.map.doors) do
				if d.id == b.id then
					d:open()
				end
			end
			b.on = true
			content.sounds.on:play()
		elseif not touched and b.on then
			for _, d in ipairs(self.map.doors) do
				if d.id == b.id then
					d:close()
				end
			end
			b.on = false
			content.sounds.off:play()
		end
	end
	for i, d in ipairs(self.map.darks) do
		if d.little then
			local touched = math.circle_circle(d.x, d.y, d.radius, l.x, l.y, l.radius)
			if touched then
				d:take_damage(dt * .7)
				if d.health == 0 then
					table.remove(self.map.darks, i)
					table.insert(self.map.items, {x=d.x, y=d.y, radius=TS/2})
					content.sounds.kill:play()
				end
			else
				d:be_calm()
			end
		end
	end

	if not self.hero.item then
		for idx, i in ipairs(self.map.items) do
			if math.circle_circle(self.hero.x, self.hero.y, self.hero.radius, i.x, i.y, i.radius) then
				table.remove(self.map.items, idx)
				self.hero.item = true
				content.sounds.pickup:play(0.5)
				break
			end
		end
	else
		local chest = self.map.chest
		if math.circle_circle(self.hero.x, self.hero.y, self.hero.radius,
						chest.x, chest.y, chest.radius) then
			chest.items = chest.items + 1
			self.hero.item = false
			if chest.items ~= chest.maxitems then
				content.sounds.chest:play()
			end
		end
	end

	for _, d in ipairs(self.map.darks) do
		if math.circle_circle(self.hero.x, self.hero.y, self.hero.radius, d.x, d.y, d.radius) then
			self.hero:take_damage(dt*.5)
			break
		end
	end

	if self.map.chest.items == self.map.chest.maxitems then
		content.sounds.toudoc:play()
		set_state(new(WinTransition, self))
	elseif self.hero.health == 0 then
		content.sounds.aww:play()
		set_state(new(Transition, self))
	end

	local h = 1 - self.hero.health
	self.h = self.h + (h - self.h) * .2
end

function Game:on_enter()
	content.sounds.spawn:play()
end

function Game:reset()
	if self.map_index == 0 then return end

	self.map = new(Map, content.maps[self.map_index])
	local x, y = self.map:get_spawn()
	self.hero = new(Hero, x, y)
	self.hero.game = self
	local light = new(Light, x, y)
	self.hero.light = light

	local cx, cy = self.hero.x - W/2, self.hero.y - H/2
	self.cx = cx
	self.cy = cy
	self.czoom = self.zoom
	self.h = 0
	collectgarbage()
end

function Game:next_level()
	self.map_index = self.map_index + 1
	self:reset()
end

function Game:draw_simple()
	if self.map_index == 0 then return end
	drystal.camera.x = self.cx
	drystal.camera.y = self.cy
	drystal.camera.zoom = self.czoom

	self.map:predraw()
	drystal.set_color 'white'
	drystal.set_alpha(255)
	self.hero:draw()
	drystal.set_color 'white'
	drystal.set_alpha(255)
	self.map:draw()

	drystal.set_color 'white'
	drystal.set_alpha(150 + 25+math.sin(TIME*5)*50)
	drystal.camera.push()
	drystal.camera.reset()
	local sp = content.sprites.cursor
	local transform = {
		wfactor=.5,
		hfactor=.5,
		angle=self.mangle,
	}
	drystal.draw_sprite(sp, self.cmx-sp.w/4, self.cmy-sp.h/4, transform)
	drystal.camera.pop()
end

function Game:draw()
	self:draw_simple()

	drystal.postfx('vignette', 1.0 - self.h*.9, 0.0)
end

function Game:hero_collide(x, y)
	for _, w in ipairs(self.map.walls) do
		if math.aabb_circle(w, x, y, self.hero.radius) then
			return true
		end
	end
	for _, d in ipairs(self.map.doors) do
		local w, h = d.sprite.w, d.sprite.h
		local box = {x=d.x-w/2, y=d.y-h/2, w=w, h=h}
		if d.timer <= 1 and math.aabb_circle(box, x, y, self.hero.radius) then
			return true
		end
	end
end

function Game:dark_collide(x, y, r)
	for _, s in ipairs(self.map.safes) do
		if math.aabb_circle(s, x, y, r) then
			return true
		end
	end
end

function Game:inside_dark_collide(x, y)
	for _, s in ipairs(self.map.safes) do
		if math.inside(s, x, y) then
			return true
		end
	end
end

function Game:mouse_motion(x, y)
	self.mx, self.my = x, y
end

function Game:mouse_press(x, y, b)
	if b == 1 then
		local xx, yy = drystal.screen2scene(x, y)
		self.hero.light.targetx = xx
		self.hero.light.targety = yy
		self.hero.light:pop()
		local a = math.atan2(yy - self.hero.y, xx - self.hero.x)
		content.sounds.bup:play(0.4, math.cos(a)/2, math.sin(a)/2)
	end
end

function Game:key_press(k)
	if k == 'return' then
		set_state(new(Transition, self))
	end
end

-- thanks http://stackoverflow.com/a/402010
function math.aabb_circle(o, x, y, r)
	local dx = math.abs(x - o.x - o.w/2);
	local dy = math.abs(y - o.y - o.h/2);

	if dx > o.w/2 + r then
		return false
	end
	if dy > o.h/2 + r then
		return false
	end

	if dx <= o.w/2 then
		return true
	end
	if dy <= o.h/2 then
		return true
	end

	local dist = (dx - o.w/2)^2 + (dy - o.h/2)^2;
	return dist <= r ^ 2;
end

function math.circle_circle(x1, y1, r1, x2, y2, r2)
	return (x1 - x2) ^ 2 + (y1 - y2) ^ 2 <= (r1 + r2)^2
end

return Game

