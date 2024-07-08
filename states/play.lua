local oo = require 'lib.oo'
local State = require 'classes.state'
local Paddle = require 'classes.paddle'

local Play = oo.class(State)

function Play:init(game)
    assert(game, 'Play state requires a game object')

    State.init(self, 'Play', game)
end

function Play:enter()
    self.paddle = Paddle.new(self.game.width / 2, self.game.height - 32, 64, 16)
    self.paddle.minX, self.paddle.maxX = 0, self.game.width - self.paddle.width
    self.paddle.speed = 400
end

function Play:exit()
    self.paddle = nil
end

function Play:update(dt)
    self.paddle:update(dt)
end

function Play:render()
    self.paddle:render()
end

return Play