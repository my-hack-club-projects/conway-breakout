local oo = require 'lib.oo'
local State = require 'classes.state'
local Paddle, Ball, Boundary, ConwayGrid = require 'classes.paddle', require 'classes.ball', require 'classes.boundary', require 'classes.conwaygrid'

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
    self.conwayGrid = ConwayGrid.new(0, 0, self.game.width, self.game.height / 2)

    table.insert(self.entities, self.paddle)
    table.insert(self.entities, self.ball)
    table.insert(self.entities, self.conwayGrid)
    table.insert(self.entities, self.conwayGrid.cells)

    for _, wall in pairs(self.boundary.walls) do
        table.insert(self.entities, wall)
    end
end

function Play:exit()
    self.paddle = nil
end

local function _doForEachEntity(entities, func)
    for _, entity in ipairs(entities) do
        if entity.render and entity.update then
            func(entity)
        else
            _doForEachEntity(entity, func)
        end
    end
end

function Play:update(dt)
    local collidedWith = self.ball:check(self.entities)

    if collidedWith == 'bottom' then
        print("game over")
    end

    _doForEachEntity(self.entities, function(entity)
        entity:update(dt)
    end)
end

function Play:render()
    _doForEachEntity(self.entities, function(entity)
        entity:render()
    end)
end

return Play