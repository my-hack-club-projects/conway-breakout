local oo = require 'lib.oo'

local State = require 'classes.state'

local MainMenu = oo.class(State)

function MainMenu:init(game)
    assert(game, 'MainMenu state requires a game object')

    State.init(self, 'MainMenu', game)
end

function MainMenu:enter()
    self.gui = require 'classes.gui'.new(self.game)

    local title = require 'classes.textlabel'.new(self.game.width / 2, self.game.height / 3, "Conway's Breakout", 32)
    self.gui:addChild(title)

    local play = require 'classes.textlabel'.new(self.game.width / 2, self.game.height / 3 * 2, 'Play', 16)
    play:bindToClick(function()
        self:playGame()
    end)
    self.gui:addChild(play)
end

function MainMenu:playGame()
    self.game:setState((require 'states.play').new(self.game))
end

function MainMenu:exit()
    self.gui = nil
end

function MainMenu:update(dt)
    self.gui:update(dt)

    if love.keyboard.isDown('escape') then
        love.event.quit()
    elseif love.keyboard.isDown('return') then
        self:playGame()
    end
end

function MainMenu:render()
    self.gui:render()
end

return MainMenu