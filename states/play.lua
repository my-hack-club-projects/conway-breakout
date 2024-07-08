local oo = require 'lib.oo'
local State = require 'classes.state'
local Paddle, Ball, Boundary = require 'classes.paddle', require 'classes.ball', require 'classes.boundary'

local Play = oo.class(State)

function Play:init(game)
    assert(game, 'Play state requires a game object')

    State.init(self, 'Play', game)
end

function Play:enter()
    self.entities = {}

    self.paddle = Paddle.new(self.game.width / 2 - 32, self.game.height - 32, 64, 16)
    self.paddle.minX, self.paddle.maxX = 0, self.game.width - self.paddle.width
    self.paddle.speed = 400

    self.ball = Ball.new(self.game.width / 2, self.game.height / 2, 8)
    self.ball.velocity = { x = 0, y = 200 }

    self.boundary = Boundary.new(self.game)

    table.insert(self.entities, self.paddle)
    table.insert(self.entities, self.ball)

    for _, wall in pairs(self.boundary.walls) do
        table.insert(self.entities, wall)
    end
end

function Play:exit()
    self.paddle = nil
end

function Play:update(dt)
    local collidedWith = self.ball:check(self.entities)
    
    if collidedWith == 'bottom' then
        print("game over")
    end

    for _, entity in ipairs(self.entities) do
        entity:update(dt)
    end
end

function Play:render()
    for _, entity in ipairs(self.entities) do
        entity:render()
    end
end

return Play