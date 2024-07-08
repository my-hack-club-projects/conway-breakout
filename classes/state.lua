local oo = require 'lib.oo'

local State = oo.class()

function State:init(name, game)
    assert(type(name) == 'string', 'State name must be a string')
    assert(game, 'State must have a game object')

    self.name = name
    self.game = game
end

return State