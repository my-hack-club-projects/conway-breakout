local oo = require 'lib.oo'
local ConwayCell = require 'classes.conwaycell'

local ConwayGrid = oo.class()

ConwayGrid.StepInterval = 5

function ConwayGrid:init(x, y, width, height)
    self.x = x or 0
    self.y = y or 0
    self.width = width or 0
    self.height = height or 0
    self.lastStep = 0

    self.gridWidth = math.floor(self.width / ConwayCell.CellSize)
    self.gridHeight = math.floor(self.height / ConwayCell.CellSize)

    self.cells = {}
    for i = 1, self.gridWidth do
        self.cells[i] = {}
        for j = 1, self.gridHeight do
            self.cells[i][j] = ConwayCell.new(i, self.x + (i - 1) * ConwayCell.CellSize, j, self.y + (j - 1) * ConwayCell.CellSize, self.cells)
        end
    end

    self:randomize()

    self.skipCollision = true
end

function ConwayGrid:countNeighbors(x, y)
    local count = 0

    for i = -1, 1 do
        for j = -1, 1 do
            if i == 0 and j == 0 then
                goto continue
            end

            local nx = x + i
            local ny = y + j

            if nx < 1 or nx > self.gridWidth or ny < 1 or ny > self.gridHeight then
                goto continue
            end

            if self.cells[nx][ny].alive then
                count = count + 1
            end

            ::continue::
        end
    end

    return count
end

function ConwayGrid:countAliveCells()
    local count = 0

    for i = 1, self.gridWidth do
        for j = 1, self.gridHeight do
            if self.cells[i][j].alive then
                count = count + 1
            end
        end
    end

    return count
end

function ConwayGrid:step()
    for i = 1, self.gridWidth do
        for j = 1, self.gridHeight do
            local count = self:countNeighbors(i, j)

            if self.cells[i][j].alive then
                self.cells[i][j].alive = count == 2 or count == 3
            else
                self.cells[i][j].alive = count == 3
            end
        end
    end
end

function ConwayGrid:randomize()
    for i = 1, self.gridWidth do
        for j = 1, self.gridHeight do
            self.cells[i][j].alive = math.random() > 0.5
        end
    end
end

function ConwayGrid:update(dt)
    self.lastStep = self.lastStep + dt

    if self.lastStep >= self.StepInterval then
        self:step()
        self.lastStep = 0
    end
end

function ConwayGrid:render()
end

return ConwayGrid