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
    self.maxRotation = math.pi/16

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

    -- Rotate the paddle towards the direction it's moving. The rotation should be smooth (sinusoidal) and never exceed the max rotation. There should be resistance to rotation, so the paddle should return to its original position when no keys are pressed.
    self.rotation = self.rotation + math.sin(self.rotation + self.direction) * dt
    self.rotation = self.rotation * 0.9 -- Apply resistance to rotation

    -- Move the object depending on the rotation, as if it had real thrusters
    self.targetVelocity = math.sin(self.rotation) * self.speed * 100 * dt
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