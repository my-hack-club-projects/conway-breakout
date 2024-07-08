local oo = require 'lib.oo'

local Game = oo.class()

function Game:init()
    self.state = nil
    self.highScore = 0
    
    self.width = love.graphics.getWidth()
    self.height = love.graphics.getHeight()
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

function Game:update(dt)
    if self.state then
        self.state:update(dt)
    end
end

function Game:render()
    if self.state then
        self.state:render()
    end
end

return Game