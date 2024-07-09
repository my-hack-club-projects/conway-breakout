local oo = require 'lib.oo'
local State = require 'classes.state'
local Gui = require 'classes.gui'
local TextLabel = require 'classes.textlabel'

local Test = oo.class(State)

function Test:init(game)
    assert(game, 'Test state requires a game object')

    State.init(self, 'Test', game)

    self.gui = Gui.new(game)

    self.label = TextLabel.new(game.width / 2, game.height / 2, 'Test', 32)
    self.label:bindToClick(function()
        print('Clicked!')
    end)

    self.gui:addChild(self.label)

    self.elapsed = 0
end

function Test:enter()
    print('Entering Test state')

    self.elapsed = 0
end

function Test:exit()
    print('Exiting Test state')

    self.elapsed = 0
end

function Test:update(dt)
    self.elapsed = self.elapsed + dt

    self.label.text = string.format('Test: %.2f', self.elapsed)

    if love.keyboard.isDown('escape') then
        self.game:setState(nil)
    elseif love.keyboard.isDown('return') then
        self.game:setState((require 'states.play').new(self.game))
    end
end

function Test:render()
    self.gui:render()
end

return Test