local oo = require 'lib.oo'

local Game = oo.class()

Game.collision = {}

function Game:init()
    self.state = nil
    self.highScore = 0

    self.width = love.graphics.getWidth()
    self.height = love.graphics.getHeight()
    
    self.background = love.graphics.newImage('assets/images/bg.png')
end

function Game:setState(state)
    if state then
        assert(state.enter, 'State must have an enter method')
        assert(state.exit, 'State must have an exit method')
        assert(state.update, 'State must have an update method')
        assert(state.render, 'State must have a render method')
    end
    if self.state then
        self.state:exit()
    end

    self.state = state

    if not state then return end

    self.state:enter()
end

function Game.collision.aabb(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2 + w2 and x2 < x1 + w1 and y1 < y2 + h2 and y2 < y1 + h1
end

function Game.collision.circle(x1, y1, r1, x2, y2, r2)
    return (x1 - x2)^2 + (y1 - y2)^2 < (r1 + r2)^2
end

function Game.collision.circleRectangle(cx, cy, radius, rx, ry, rw, rh)
    local dx = math.abs(cx - (rx + rw / 2))
    local dy = math.abs(cy - (ry + rh / 2))

    if dx > (rw / 2 + radius) or dy > (rh / 2 + radius) then
        return false
    end

    if dx <= (rw / 2) or dy <= (rh / 2) then
        return true
    end

    local cornerDistanceSq = (dx - rw / 2)^2 + (dy - rh / 2)^2
    return cornerDistanceSq <= (radius^2)
end

function Game:update(dt)
    if self.state then
        self.state:update(dt)
    end
end

function Game:render()
    love.graphics.draw(self.background, 0, 0, 0, self.width/self.background:getWidth(), self.height/self.background:getHeight())
    
    if self.state then
        self.state:render()
    end
end

return Game