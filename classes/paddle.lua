local oo = require 'lib.oo'

local Paddle = oo.class()

function Paddle:init(x, y, width, height)
    self.x = x or 0
    self.y = y or 0
    self.width = width or 0
    self.height = height or 0

    self.minX = 0
    self.maxX = 0

    self.speed = 1
end

function Paddle:update(dt)
    if love.keyboard.isDown('a') then
        self.x = self.x - self.speed * dt
    end

    if love.keyboard.isDown('d') then
        self.x = self.x + self.speed * dt
    end

    self.x = math.max(self.minX, math.min(self.maxX, self.x))
end

function Paddle:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end

return Paddle