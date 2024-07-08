local oo = require 'lib.oo'
local State = require 'classes.state'

local Test = oo.class(State)

function Test:init(game)
    assert(game, 'Test state requires a game object')

    State.init(self, 'Test', game)

    self.elapsed = 0
end

function Test:enter()
    print('Entering Test state')

    self.elapsed = 0
end

function Test:exit()
    print('Exiting Test state')

    self.elapsed = 0
end

function Test:update(dt)
    print('Updating Test state')

    self.elapsed = self.elapsed + dt

    if love.keyboard.isDown('escape') then
        self.game:setState(nil)
    elseif love.keyboard.isDown('return') then
        self.game:setState((require 'states.play').new(self.game))
    end
end

function Test:render()
    print('Rendering Test state')

    love.graphics.print('Test state', 10, 10)
    love.graphics.print('Elapsed time: ' .. self.elapsed, 10, 30)
end

return Test