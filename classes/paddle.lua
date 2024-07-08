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
    self.direction = 0

    self.isPaddle = true
end

function Paddle:update(dt)
    self.direction = (love.keyboard.isDown('a') and -1 or 0) + (love.keyboard.isDown('d') and 1 or 0)

    self.x = self.x + self.speed * self.direction * dt
    self.x = math.max(self.minX, math.min(self.maxX, self.x))
end

function Paddle:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end

return Paddle