local oo = require 'lib.oo'
local State = require 'classes.state'
local Gui, TextLabel = require 'classes.gui', require 'classes.textlabel'

local GameOver = oo.class(State)

function GameOver:init(game)
    assert(game, 'GameOver state requires a game object')

    State.init(self, 'GameOver', game)

    self.previousState = nil
end

function GameOver:enter(previousState)
    self.previousState = previousState

    self.gui = Gui.new(self.game)

    local label = TextLabel.new(self.game.width / 2, self.game.height / 2, 'Game Over', 32)
    self.gui:addChild(label)
end

function GameOver:exit()
    self.gui = nil
end

function GameOver:update(dt)
    self.gui:update(dt)

    if love.keyboard.isDown('return') then
        self.game:setState(self.previousState)
    end
end

function GameOver:render()
    self.previousState:render()

    self.gui:render()
end

return GameOver