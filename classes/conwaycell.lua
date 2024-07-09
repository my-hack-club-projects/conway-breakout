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

    self.image = love.graphics.newImage('assets/images/cell.png')

    self.update = function() end
end

function ConwayCell:render()
    if self.alive then
        love.graphics.setColor(1,1,1)
        love.graphics.draw(self.image, self.x, self.y, 0, self.width/self.image:getWidth(), self.height/self.image:getHeight())
    end
end

return ConwayCell