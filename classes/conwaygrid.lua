local oo = require 'lib.oo'

local ConwayGrid = oo.class()

ConwayGrid.CellSize = 32
ConwayGrid.StepInterval = 1

function ConwayGrid:init(x, y, width, height)
    self.x = x or 0
    self.y = y or 0
    self.width = width or 0
    self.height = height or 0
    self.lastStep = 0

    self.gridWidth = math.floor(self.width / self.CellSize)
    self.gridHeight = math.floor(self.height / self.CellSize)

    self.cells = {}
    for i = 1, self.gridWidth do
        self.cells[i] = {}
        for j = 1, self.gridHeight do
            self.cells[i][j] = false
        end
    end

    self:randomize()
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

            if self.cells[nx][ny] then
                count = count + 1
            end

            ::continue::
        end
    end

    return count
end

function ConwayGrid:step()
    local newCells = {}
    for i = 1, self.gridWidth do
        newCells[i] = {}
        for j = 1, self.gridHeight do
            local count = self:countNeighbors(i, j)

            if self.cells[i][j] then
                newCells[i][j] = count == 2 or count == 3
            else
                newCells[i][j] = count == 3
            end
        end
    end

    self.cells = newCells
end

function ConwayGrid:randomize()
    for i = 1, self.gridWidth do
        for j = 1, self.gridHeight do
            self.cells[i][j] = math.random() > 0.5
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
    for i = 1, self.gridWidth do
        for j = 1, self.gridHeight do
            if self.cells[i][j] then
                love.graphics.rectangle('fill', self.x + (i - 1) * self.CellSize, self.y + (j - 1) * self.CellSize, self.CellSize, self.CellSize)
            end
        end
    end
end

return ConwayGrid