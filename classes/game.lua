local oo = require 'lib.oo'

local Game = oo.class()

function Game:init()
    self.state = nil
    self.highScore = 0
end

function Game:setState(state)
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