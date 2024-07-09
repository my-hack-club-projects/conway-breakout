local oo = require 'lib.oo'

local Boundary = oo.class()

local THICKNESS = 10

function Boundary:init(game)
    self.game = game
    self.walls = {}

    self:initializeWalls()

    self.game:onResize(function()
        self:initializeWalls()
    end)

    self.update = function() end
end

function Boundary:initializeWalls()
    for i, v in ipairs(self.walls) do
        self.walls[i] = nil
    end

    -- self.walls.top = { side = 'top', x = 0, y = 0, width = self.game.width, height = THICKNESS }
    -- self.walls.bottom = { side = 'bottom', x = 0, y = self.game.height - THICKNESS, width = self.game.width, height = THICKNESS }
    -- self.walls.left = { side = 'left', x = 0, y = 0, width = THICKNESS, height = self.game.height }
    -- self.walls.right = { side = 'right', x = self.game.width - THICKNESS, y = 0, width = THICKNESS, height = self.game.height }

    table.insert(self.walls, { side = 'top', x = 0, y = 0, width = self.game.width, height = THICKNESS })
    table.insert(self.walls, { side = 'bottom', x = 0, y = self.game.height - THICKNESS, width = self.game.width, height = THICKNESS })
    table.insert(self.walls, { side = 'left', x = 0, y = 0, width = THICKNESS, height = self.game.height })
    table.insert(self.walls, { side = 'right', x = self.game.width - THICKNESS, y = 0, width = THICKNESS, height = self.game.height })

    for _, wall in pairs(self.walls) do
        wall.isWall = true

        wall.render = function()
            love.graphics.setColor(0,0,0, 0.4)
            love.graphics.rectangle('fill', wall.x, wall.y, wall.width, wall.height)
        end

        wall.update = function() end
    end
end

function Boundary:render()
    love.graphics.setColor(0,0,0, 0.4)
    for _, wall in pairs(self.walls) do
        wall.render()
    end
end

return Boundary