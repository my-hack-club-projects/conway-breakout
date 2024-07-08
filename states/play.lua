local oo = require 'lib.oo'
local State = require 'classes.state'

local Play = oo.class(State)

function Play:init(game)
    assert(game, 'Play state requires a game object')

    State.init(self, 'Play', game)

    self.enter = function() end
    self.exit = function() end
end

function Play:update(dt)
    print('Updating Play state')

    if love.keyboard.isDown('escape') then
        self.game:setState(nil)
    end
end

function Play:render()
    print('Rendering Play state')

    love.graphics.print('Play state', 10, 10)
end

return Play