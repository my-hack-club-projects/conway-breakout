local oo = require 'lib.oo'

local State = oo.class()

function State:init(name)
    assert(type(name) == 'string', 'State name must be a string')

    self.name = name

    self.enter = function() end
    self.exit = function() end
    self.update = function() end
    self.render = function() end
end

return State