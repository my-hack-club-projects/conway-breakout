local oo = require 'lib.oo'

local Boundary = oo.class()

local THICKNESS = 10

function Boundary:init(game)
    self.walls = {}

    self.walls.top = { side = 'top', x = 0, y = 0, width = game.width, height = THICKNESS }
    self.walls.bottom = { side = 'bottom', x = 0, y = game.height - THICKNESS, width = game.width, height = THICKNESS }
    self.walls.left = { side = 'left', x = 0, y = 0, width = THICKNESS, height = game.height }
    self.walls.right = { side = 'right', x = game.width - THICKNESS, y = 0, width = THICKNESS, height = game.height }

    for _, wall in pairs(self.walls) do
        wall.isWall = true

        wall.render = function()
            love.graphics.rectangle('fill', wall.x, wall.y, wall.width, wall.height)
        end

        wall.update = function() end
    end

    self.update = function() end
end

function Boundary:render()
    for _, wall in pairs(self.walls) do
        love.graphics.rectangle('fill', wall.x, wall.y, wall.width, wall.height)
    end
end

return Boundary