local oo = require 'lib.oo'

local Paddle = oo.class()

local function _sign(x)
    return x > 0 and 1 or x < 0 and -1 or 0
end

function Paddle:init(x, y, width, height)
    self.x = x or 0
    self.y = y or 0
    self.width = width or 0
    self.height = height or 0
    self.rotation = 0
    self.maxRotation = math.pi/8
    self.rotationReturnSpeed = 1
    self.rotationSpeed = 2

    self.minX = 0
    self.maxX = 0

    self.speed = 1
    self.accel = 10
    self.targetVelocity = 0
    self.velocity = 0
    self.direction = 0

    self.image = love.graphics.newImage('assets/images/paddle.png')
    self.isPaddle = true
end

function Paddle:update(dt)
    self.direction = (love.keyboard.isDown('a') and -1 or 0) + (love.keyboard.isDown('d') and 1 or 0)

    self.rotation = self.rotation + self.direction * (self.maxRotation - math.abs(self.rotation)) * self.rotationSpeed * dt
    self.rotation = self.rotation * (1 - dt * self.rotationReturnSpeed)

    self.targetVelocity = math.sin(self.rotation) * self.speed
    self.velocity = self.velocity + (self.targetVelocity - self.velocity) * dt * self.accel
    self.x = self.x + self.velocity * dt

    self.x = math.max(self.minX, math.min(self.maxX, self.x))
end

function Paddle:render()
    love.graphics.setColor(1,1,1)

    love.graphics.translate(self.x + self.width/2, self.y + self.height/2)
    love.graphics.rotate(self.rotation)

    love.graphics.draw(self.image, -self.width/2, -self.height/2, 0, self.width/self.image:getWidth(), self.height/self.image:getHeight())

    love.graphics.origin()
end

return Paddle