local oo = require 'lib.oo'

local Gui = oo.class()

function Gui:init(game)
    self.game = game
    self.width = game.width
    self.height = game.height

    self.children = {}
end

function Gui:addChild(child)
    table.insert(self.children, child)
end

function Gui:update(dt)
    for _, child in ipairs(self.children) do
        child:update(dt)
    end
end

function Gui:render()
    for _, child in ipairs(self.children) do
        child:render()
    end
end

return Gui