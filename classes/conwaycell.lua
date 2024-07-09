local oo = require 'lib.oo'
local Game = require 'classes.game'

local ConwayCell = oo.class()

ConwayCell.CellSize = 24

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

        local neighbors = {
            {position = {self.gridX - 1, self.gridY}, edge = {{0, 0}, {0, 1}}}, -- left
            {position = {self.gridX + 1, self.gridY}, edge = {{1, 0}, {1, 1}}}, -- right
            {position = {self.gridX, self.gridY - 1}, edge = {{0, 0}, {1, 0}}}, -- top
            {position = {self.gridX, self.gridY + 1}, edge = {{0, 1}, {1, 1}}}, -- bottom
        }

        for _, neighbor in ipairs(neighbors) do
            local nx, ny = neighbor.position[1], neighbor.position[2]
            if nx < 1 or nx > #self.otherCells or ny < 1 or ny > #self.otherCells[1] or not self.otherCells[nx][ny].alive then
                local x1, y1 = self.x + neighbor.edge[1][1] * self.width, self.y + neighbor.edge[1][2] * self.height
                local x2, y2 = self.x + neighbor.edge[2][1] * self.width, self.y + neighbor.edge[2][2] * self.height

                love.graphics.line(x1, y1, x2, y2)
            end
        end
    end
end

return ConwayCell