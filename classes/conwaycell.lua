local oo = require 'lib.oo'

local ConwayCell = oo.class()

ConwayCell.CellSize = 32

function ConwayCell:init(x, realX, y, realY)
    self.x = realX or 0
    self.y = realY or 0
    self.gridX = x or 0
    self.gridY = y or 0
    self.alive = false

    self.isCell = true
    self.width = ConwayCell.CellSize
    self.height = ConwayCell.CellSize

    self.update = function() end
end

function ConwayCell:render()
    if self.alive then
        love.graphics.setColor(1,1,1)
        love.graphics.rectangle('fill', self.x, self.y, ConwayCell.CellSize, ConwayCell.CellSize)
    end
end

return ConwayCell