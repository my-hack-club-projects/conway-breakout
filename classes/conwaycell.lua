local oo = require 'lib.oo'
local Game = require 'classes.game'

local ConwayCell = oo.class()

ConwayCell.CellSize = 32

function ConwayCell:init(x, realX, y, realY, cells)
    self.otherCells = cells

    self.x = realX or 0
    self.y = realY or 0
    self.gridX = x or 0
    self.gridY = y or 0
    self.alive = false

    self.isCell = true
    self.width = ConwayCell.CellSize
    self.height = ConwayCell.CellSize

    self.image = love.graphics.newImage('assets/images/cell.png')

    self.update = function() end
end

function ConwayCell:render()
    if self.alive then
        love.graphics.setColor(1,1,1)
        love.graphics.draw(self.image, self.x, self.y, 0, self.width/self.image:getWidth(), self.height/self.image:getHeight())

        --- Draw an outline on each edge that has no neighbors
        love.graphics.setColor(Game.color.hex2color('4c4c65'))
        if self.gridX == 1 or not self.otherCells[self.gridX - 1][self.gridY].alive then
            love.graphics.line(self.x, self.y, self.x, self.y + self.height)
        end

        if self.gridX == #self.otherCells or not self.otherCells[self.gridX + 1][self.gridY].alive then
            love.graphics.line(self.x + self.width, self.y, self.x + self.width, self.y + self.height)
        end

        if self.gridY == 1 or not self.otherCells[self.gridX][self.gridY - 1].alive then
            love.graphics.line(self.x, self.y, self.x + self.width, self.y)
        end

        if self.gridY == #self.otherCells[1] or not self.otherCells[self.gridX][self.gridY + 1].alive then
            love.graphics.line(self.x, self.y + self.height, self.x + self.width, self.y + self.height)
        end
    end
end

return ConwayCell