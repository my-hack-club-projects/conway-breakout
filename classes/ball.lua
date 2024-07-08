local oo = require 'lib.oo'
local Game = require 'classes.game' -- used for collision detection

local Ball = oo.class()

function Ball:init(x, y, radius)
    self.x = x or 0
    self.y = y or 0
    self.radius = radius or 0

    self.velocity = { x = 0, y = 0 }

    self.isBall = true
end

function Ball:bounce(axis)
    assert(axis == 'x' or axis == 'y', 'Invalid axis')

    self.velocity[axis] = -self.velocity[axis]
end

function Ball:check(entities)
    for _, entity in ipairs(entities) do
        if entity.width and entity.height then
            if Game.collision.circleRectangle(self.x, self.y, self.radius, entity.x, entity.y, entity.width, entity.height) then
                if entity.isPaddle then
                    print("paddle")
                    self:bounce('y')
                    self.velocity.x = (self.x - entity.x) / entity.width * (entity.speed * entity.direction)

                    return "paddle"
                elseif entity.isWall then
                    print("wall")
                    if entity.side == "bottom" then
                        return "bottom"
                    else
                        if entity.side == "top" then
                            self:bounce('y')
                        else
                            self:bounce('x')
                        end

                        return "wall"
                    end
                elseif entity.isCell then
                    local dx = self.x - entity.x
                    local dy = self.y - entity.y
                    local width = entity.width
                    local height = entity.height

                    if math.abs(dx) > math.abs(dy) then
                        if dx > 0 then
                            self.x = entity.x + width + self.radius
                        else
                            self.x = entity.x - self.radius
                        end
                        self:bounce('x')
                    else
                        if dy > 0 then
                            self.y = entity.y + height + self.radius
                        else
                            self.y = entity.y - self.radius
                        end
                        self:bounce('y')
                    end

                    return "cell"
                end

                if entity.isWall and entity.side == "bottom" then
                    return "bottom"
                end

                -- local dx = self.x - entity.x
                -- local dy = self.y - entity.y
                -- local width = entity.width
                -- local height = entity.height

                -- if math.abs(dx) > math.abs(dy) then
                --     if dx > 0 then
                --         self.x = entity.x + width + self.radius
                --     else
                --         self.x = entity.x - self.radius
                --     end
                --     self:bounce('x')
                -- else
                --     if dy > 0 then
                --         self.y = entity.y + height + self.radius
                --     else
                --         self.y = entity.y - self.radius
                --     end
                --     self:bounce('y')
                -- end

                -- if entity.isPaddle then
                --     -- self.velocity.x = self.velocity.x + (entity.speed * entity.direction)
                -- end
            end
        end
    end
end

function Ball:update(dt)
    self.x = self.x + self.velocity.x * dt
    self.y = self.y + self.velocity.y * dt
end

function Ball:render()
    love.graphics.circle('fill', self.x, self.y, self.radius)
end

return Ball
