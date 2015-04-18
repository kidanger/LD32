local drystal = require 'drystal'

local Hero = require 'hero'
local Map = require 'map'
local Light = require 'light'
local Dark = require 'dark'
local content = require 'content'

local Game = {
	map_index=1,
	cx=0, cy=0, czoom=1,
	zoom=0.5,
}
Game.__index = Game

function Game:init()
	self.map = new(Map, content.maps[self.map_index])
	local x, y = self.map:get_spawn()
	self.hero = new(Hero, x, y)
	self.hero.game = self
	local light = new(Light, x, y)
	self.hero.light = light
end

function Game:update(dt)
	local cx, cy = -self.hero.x + W/2, -self.hero.y + H/2
	self.cx = self.cx + (cx - self.cx) * 0.2
	self.cy = self.cy + (cy - self.cy) * 0.2
	self.czoom = self.czoom + (self.zoom - self.czoom) * 0.2

	for _, d in ipairs(self.map.darks) do
		d.hero = self.hero
	end

	self.map:update(dt)
	self.hero:update(dt)
end

function Game:draw()
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

	drystal.postfx('vignette', 0.9, 0.4)
end

function Game:hero_collide(x, y)
	local w, h = self.hero.sprite.w, self.hero.sprite.h
	local box = {x=x-w/2, y=y-h/2, w=w, h=h}
	for _, w in ipairs(self.map.walls) do
		-- circlebox
		if math.aabb(w.box, box) then
			return true
		end
	end
end

function Game:mouse_press(x, y, b)
	if b == 1 then
		local xx, yy = drystal.screen2scene(x, y)
		self.hero.light.targetx = xx
		self.hero.light.targety = yy
	end
end

return Game

