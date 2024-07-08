local oo = require 'lib.oo'
local Game = require 'classes.game' -- used for collision detection

local Ball = oo.class()

local DEBOUNCE = 0.1

function Ball:init(x, y, radius)
    self.x = x or 0
    self.y = y or 0
    self.radius = radius or 0

    self.velocity = { x = 0, y = 0 }
    self.speedInheritance = 0.2
    self.drag = 0.15
    self.gravity = 50

    self.isBall = true

    self.debounce = {}
end

function Ball:bounce(axis)
    assert(axis == 'x' or axis == 'y', 'Invalid axis')

    self.velocity[axis] = -self.velocity[axis]
end

function Ball:check(entities)
    for _, entity in ipairs(entities) do
        if entity.width and entity.height then
            if os.time() - (self.debounce[entity] or 0) < DEBOUNCE then
                goto continue
            end

            if Game.collision.circleRectangle(self.x, self.y, self.radius, entity.x, entity.y, entity.width, entity.height) then
                self.debounce[entity] = os.time()

                if entity.isWall and entity.side == "bottom" then
                    return "bottom"
                end

                local dx = self.x - entity.x
                local dy = self.y - entity.y

                if math.abs(dx) > math.abs(dy) then
                    self:bounce('y')
                else
                    self:bounce('x')
                end

                if entity.isPaddle then
                    self.velocity.x = self.velocity.x + (entity.speed * entity.direction) * self.speedInheritance
                elseif entity.isCell then
                    entity:destroy()
                end
            end
        end

        ::continue::
    end
end

function Ball:update(dt)
    self.velocity.x = self.velocity.x * (1 - self.drag * dt)
    self.velocity.y = self.velocity.y + self.gravity * dt
    self.x = self.x + self.velocity.x * dt
    self.y = self.y + self.velocity.y * dt
end

function Ball:render()
    love.graphics.circle('fill', self.x, self.y, self.radius)
end

return Ball
