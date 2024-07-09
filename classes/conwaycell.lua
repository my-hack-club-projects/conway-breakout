local oo = require 'lib.oo'

local ConwayCell = oo.class()

ConwayCell.CellSize = 32

function ConwayCell:init(x, realX, y, realY)
    self.x = x or 0
    self.y = y or 0
    self.realX = realX or 0
    self.realY = realY or 0
    self.alive = false

    self.isCell = true
end

function ConwayCell:render()
    if self.alive then
        love.graphics.setColor(1,1,1)
        love.graphics.rectangle('fill', self.realX, self.realY, ConwayCell.CellSize, ConwayCell.CellSize)
    end
end

return ConwayCell