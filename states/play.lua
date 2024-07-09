local oo = require 'lib.oo'
local State = require 'classes.state'
local GameOverState = require 'states.gameover'

local Paddle, Ball, Boundary, ConwayGrid = require 'classes.paddle', require 'classes.ball', require 'classes.boundary', require 'classes.conwaygrid'

local Play = oo.class(State)

Play.PaddleSize = { width = 64, height = 16 }
Play.PaddleOffset = 38
Play.PaddleSpeed = 2000
Play.PaddleAccel = 50

Play.BallRadius = 8
Play.BallSpawnPositionOffset = { x = 0, y = -150 }
Play.BallSpawnVelocity = { x = 0, y = 200 }

function Play:init(game)
    assert(game, 'Play state requires a game object')

    State.init(self, 'Play', game)
end

function Play:enter()
    self.time = 0
    self.success = false
    self.destroyedCells = 0

    self.entities = {}

    self.paddle = Paddle.new(self.game.width / 2 - Play.PaddleSize.width / 2, self.game.height - Play.PaddleOffset, Play.PaddleSize.width, Play.PaddleSize.height)
    self.paddle.minX, self.paddle.maxX = 0, self.game.width - self.paddle.width
    self.paddle.speed = Play.PaddleSpeed
    self.paddle.accel = Play.PaddleAccel
    self.ball = Ball.new(self.game.width / 2 + Play.BallSpawnPositionOffset.x - Play.BallRadius, self.game.height - Play.PaddleOffset + Play.BallSpawnPositionOffset.y - Play.BallRadius, Play.BallRadius)
    self.ball.velocity = Play.BallSpawnVelocity

    self.boundary = Boundary.new(self.game)
    self.conwayGrid = ConwayGrid.new(self.game.width / 12, self.game.height / 8, self.game.width - self.game.width / 12 * 2, self.game.height / 2)

    table.insert(self.entities, self.paddle)
    table.insert(self.entities, self.ball)
    table.insert(self.entities, self.conwayGrid)
    table.insert(self.entities, self.conwayGrid.cells)
    table.insert(self.entities, self.boundary.walls)

    self.update = Play.update

    self.music = self.game.audio.play("music")

    self.game:onResize(function(w, h)
        self:reinitializePositions(w, h)
    end)
end

function Play:reinitializePositions(w, h)
    assert(self.paddle, 'Paddle not initialized')
    assert(self.ball, 'Ball not initialized')
    assert(self.conwayGrid, 'ConwayGrid not initialized')

    local xPercentagePaddle = (self.paddle.x + self.paddle.width / 2)  / self.game.width

    self.paddle.minX, self.paddle.maxX = 0, w - self.paddle.width

    self.paddle.x = w * xPercentagePaddle - self.paddle.width / 2
    self.paddle.y = h - Play.PaddleOffset

    local xPercentageBall = (self.ball.x + Play.BallRadius) / self.game.width
    local yPercentageBall = (self.ball.y + Play.BallRadius) / self.game.height

    self.ball.x = w * xPercentageBall - Play.BallRadius
    self.ball.y = h * yPercentageBall - Play.BallRadius
end

function Play:exit()
    self.update = function() end
    self.music:stop()
    self.music = nil
end

function Play:cleanup()
    self.paddle = nil
    self.ball = nil
    self.boundary = nil
    self.conwayGrid = nil
    self.entities = nil
    self.time = nil
    self.success = nil
    self.destroyedCells = nil
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
        self.game.audio.play('lose')

        self.game:setState(GameOverState.new(self.game))
    elseif type(collidedWith) == 'table' and collidedWith.isCell then
        collidedWith.alive = collidedWith.alive and not collidedWith.alive
        self.destroyedCells = self.destroyedCells + 1

        if self.conwayGrid:countAliveCells() == 0 then
            self.game.audio.play('win')

            self.success = true
            self.game:setState(GameOverState.new(self.game))
        end
    end

    _doForEachEntity(self.entities, function(entity)
        entity:update(dt)
    end)

    self.time = self.time + dt
end

function Play:render()
    _doForEachEntity(self.entities, function(entity)
        entity:render()
    end)

    -- render timer - needs to be processed MM:SS
    love.graphics.setColor(1, 1, 1)

    local text = string.format("%02d:%02d", math.floor(self.time / 60), math.floor(self.time % 60))
    local xSize = love.graphics.getFont():getWidth(text)

    love.graphics.print(text, self.game.width - xSize - 10, 10)
end

return Play