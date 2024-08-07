local oo = require 'lib.oo'
local moonshine = require 'lib.moonshine'

local Game = oo.class()

Game.FontName = 'assets/fonts/PressStart2P.ttf'

Game.collision = {}
Game.color = {}
Game.audio = {
    sounds = {
        bounce = {name = 'assets/sounds/ball_land.mp3', type = 'static'},
        destroy = {name = 'assets/sounds/cell_destroy.mp3', type = 'static'},
        click = {name = 'assets/sounds/click.mp3', type = 'static'},
        lose = {name = 'assets/sounds/lose.mp3', type = 'static'},
        win = {name = 'assets/sounds/win.mp3', type = 'static'},
        music = {name = 'assets/sounds/music.mp3', type = 'stream', loop = true, volume = 0.3},
    },
    sources = {},
}

function Game:init()
    self.state = nil
    self.time = 0     -- passed by Play state later
    self.bestTime = 0 -- loaded from file, overriden by self.time if it's higher

    self.width = love.graphics.getWidth()
    self.height = love.graphics.getHeight()

    self.background = love.graphics.newImage('assets/images/bg.png')
    self.font = love.graphics.newFont(Game.FontName, 16)

    self:setupEffects()

    self._onResize = {
        function(w, h)
            self:setupEffects()
        end,
    }

    love.resize = function(w, h)
        for _, callback in ipairs(self._onResize) do
            callback(w, h)
        end
    end

    love.graphics.setFont(self.font)
end

function Game:onResize(callback)
    table.insert(self._onResize, callback)
end

function Game:setupEffects()
    self.effect = moonshine(moonshine.effects.filmgrain)
    .chain(moonshine.effects.glow)
    .chain(moonshine.effects.vignette)
    .chain(moonshine.effects.crt)
    .chain(moonshine.effects.godsray)

    self.effect.filmgrain.size = 2
    self.effect.filmgrain.opacity = 0.5

    self.effect.glow.min_luma = 0.7
    self.effect.glow.strength = 1

    self.effect.godsray.exposure = 0.1
    self.effect.godsray.decay = 0.9

    self.effect.vignette.opacity = 0.2
end

function Game:setState(state)
    if state then
        assert(state.enter, 'State must have an enter method')
        assert(state.exit, 'State must have an exit method')
        assert(state.update, 'State must have an update method')
        assert(state.render, 'State must have a render method')
    end

    local prevState = self.state
    if self.state then
        self.state:exit()
    end

    self.state = state

    if not state then return end

    self.state:enter(prevState)
end

function Game.collision.aabb(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2 + w2 and x2 < x1 + w1 and y1 < y2 + h2 and y2 < y1 + h1
end

function Game.collision.circle(x1, y1, r1, x2, y2, r2)
    return (x1 - x2) ^ 2 + (y1 - y2) ^ 2 < (r1 + r2) ^ 2
end

function Game.collision.circleRectangle(cx, cy, radius, rx, ry, rw, rh)
    local dx = math.abs(cx - (rx + rw / 2))
    local dy = math.abs(cy - (ry + rh / 2))

    if dx > (rw / 2 + radius) or dy > (rh / 2 + radius) then
        return false
    end

    if dx <= (rw / 2) or dy <= (rh / 2) then
        return true
    end

    local cornerDistanceSq = (dx - rw / 2) ^ 2 + (dy - rh / 2) ^ 2
    return cornerDistanceSq <= (radius ^ 2)
end

function Game.color.hex2color(hex)
    local splitToRGB = {}

    if #hex < 6 then hex = hex .. string.rep("F", 6 - #hex) end --flesh out bad hexes

    for x = 1, #hex - 1, 2 do
        table.insert(splitToRGB, tonumber(hex:sub(x, x + 1), 16))            --convert hexes to dec
        if splitToRGB[#splitToRGB] < 0 then splitToRGB[#splitToRGB] = 0 end  --prevents negative values
    end
    return unpack(splitToRGB)
end

function Game.audio.play(name)
    local sources = Game.audio.sources[name] or {}
    local stoppedSource = false

    for _, source in ipairs(sources) do
        if source:isStopped() then
            stoppedSource = source
            break
        end
    end

    if not stoppedSource then
        local sound = Game.audio.sounds[name]

        if not sound then
            error('Sound not found: ' .. name)
        end

        stoppedSource = love.audio.newSource(sound.name, sound.type)

        stoppedSource:setLooping(sound.loop or false)
        stoppedSource:setVolume(sound.volume or 1)

        table.insert(sources, stoppedSource)
    end

    stoppedSource:play()

    return stoppedSource
end

function Game:update(dt)
    self.width = love.graphics.getWidth()
    self.height = love.graphics.getHeight()

    if self.state then
        self.state:update(dt)
    end
end

function Game:render()
    local function render()
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(self.background, 0, 0, 0, self.width / self.background:getWidth(),
            self.height / self.background:getHeight())

        if self.state then
            self.state:render()
        end
    end

    if self.effect then
        self.effect(render)
    else
        render()
    end
end

return Game
