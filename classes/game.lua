local oo = require 'lib.oo'

local Game = oo.class()

Game.FontName = 'assets/fonts/PressStart2P.ttf'

Game.collision = {}
Game.color = {}

function Game:init()
    self.state = nil
    self.time = 0 -- passed by Play state later
    self.bestTime = 0 -- loaded from file, overriden by self.time if it's higher

    self.width = love.graphics.getWidth()
    self.height = love.graphics.getHeight()

    self.background = love.graphics.newImage('assets/images/bg.png')
    self.font = love.graphics.newFont(Game.FontName, 16)

    love.graphics.setFont(self.font)
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

function Game.color.hex2color(hex)
    local splitToRGB = {}
    
    if #hex < 6 then hex = hex .. string.rep("F", 6 - #hex) end --flesh out bad hexes
    
    for x = 1, #hex - 1, 2 do
         table.insert(splitToRGB, tonumber(hex:sub(x, x + 1), 16)) --convert hexes to dec
         if splitToRGB[#splitToRGB] < 0 then splitToRGB[#splitToRGB] = 0 end --prevents negative values
    end
    return unpack(splitToRGB)
end

function Game:update(dt)
    if self.state then
        self.state:update(dt)
    end
end

function Game:render()
    love.graphics.setColor(1,1,1)
    love.graphics.draw(self.background, 0, 0, 0, self.width/self.background:getWidth(), self.height/self.background:getHeight())

    if self.state then
        self.state:render()
    end
end

return Game