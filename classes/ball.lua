local oo = require 'lib.oo'
local Game = require 'classes.game' -- used for collision detection

local Ball = oo.class()

local DEBOUNCE = 0.05

function Ball:init(x, y, radius)
    self.x = x or 0
    self.y = y or 0
    self.radius = radius or 0

    self.velocity = { x = 0, y = 0 }
    self.speedInheritance = 0.2
    self.drag = 0.15
    self.gravity = 50

    self.image = love.graphics.newImage('assets/images/ball.png')
    self.isBall = true

    self.debounce = {}
end

function Ball:bounce(axis)
    assert(axis == 'x' or axis == 'y', 'Invalid axis')

    self.velocity[axis] = -self.velocity[axis]
end

function Ball:check(entities)
    local function checkTable(tbl)
        for _, entity in ipairs(tbl) do
            if entity.width and entity.height then
                if entity.skipCollision == true then goto continue end
                if entity.isCell and entity.alive == false then goto continue end

                if os.time() - (self.debounce[entity] or 0) < DEBOUNCE then goto continue end

                if not Game.collision.circleRectangle(self.x, self.y, self.radius, entity.x, entity.y, entity.width, entity.height) then goto continue end

                self.debounce[entity] = os.time()

                if entity.isWall and entity.side == "bottom" then
                    return "bottom"
                end

                local closestX = math.max(entity.x, math.min(self.x, entity.x + entity.width))
                local closestY = math.max(entity.y, math.min(self.y, entity.y + entity.height))

                local dx = self.x - closestX
                local dy = self.y - closestY

                if dx^2 + dy^2 < self.radius^2 then
                    if dx^2 > dy^2 then
                        self:bounce('x')
                    else
                        self:bounce('y')
                    end
                end

                if entity.isPaddle then
                    self.velocity.x = self.velocity.x + (entity.speed * entity.direction) * self.speedInheritance
                    self.velocity.y = -math.abs(self.velocity.y) -- always bounce off of the paddle
                elseif entity.isCell then
                    return entity
                end

                ::continue::
            else
                local result = checkTable(entity)

                if result then return result end
            end
        end
    end

    return checkTable(entities)
end

function Ball:update(dt)
    self.velocity.x = self.velocity.x * (1 - self.drag * dt)
    self.velocity.y = self.velocity.y + self.gravity * dt
    self.x = self.x + self.velocity.x * dt
    self.y = self.y + self.velocity.y * dt
end

function Ball:render()
    love.graphics.draw(self.image, self.x, self.y, 0, self.radius*2/self.image:getWidth(), self.radius*2/self.image:getHeight())
end

return Ball
