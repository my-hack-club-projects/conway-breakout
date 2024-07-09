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

    self.image = love.graphics.newImage('assets/images/paddle.png')
    self.isPaddle = true
end

function Paddle:update(dt)
    self.direction = (love.keyboard.isDown('a') and -1 or 0) + (love.keyboard.isDown('d') and 1 or 0)

    self.x = self.x + self.speed * self.direction * dt
    self.x = math.max(self.minX, math.min(self.maxX, self.x))
end

function Paddle:render()
    love.graphics.draw(self.image, self.x, self.y, 0, self.width/self.image:getWidth(), self.height/self.image:getHeight()) 
end

return Paddle