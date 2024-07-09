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

    local label = TextLabel.new(self.game.width / 2, self.game.height / 3, 'Game Over!', 32)
    self.gui:addChild(label)

    local time = TextLabel.new(self.game.width / 2, self.game.height / 3 + 32, string.format('Your time: %.2f', self.previousState.time), 16)
    self.gui:addChild(time)

    local bestTime = TextLabel.new(self.game.width / 2, self.game.height / 3 + 52, string.format('Best time: %.2f', self.game.bestTime), 16)
    self.gui:addChild(bestTime)

    local button = TextLabel.new(self.game.width / 2, self.game.height / 3 * 2, 'Retry?', 16)

    button:bindToClick(function()
        self.game:setState(self.previousState)
    end)

    self.gui:addChild(button)
end

function GameOver:exit()
    self.gui = nil
end

function GameOver:update(dt)
    self.gui:update(dt)
end

function GameOver:render()
    self.previousState:render() -- TODO: blur this layer, for now, just add a dark overlay

    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle('fill', 0, 0, self.game.width, self.game.height)

    self.gui:render()
end

return GameOver