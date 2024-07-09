local oo = require 'lib.oo'
local Game = require 'classes.game'

local TextLabel = oo.class()

function TextLabel:init(x, y, text, fontSize)
    self.text = text or ''
    self.fontSize = fontSize or 12
    self.x = x or 0
    self.y = y or 0

    self.pressed = false

    self.color = { 1, 1, 1, 1 }
    self.font = love.graphics.newFont(Game.FontName, self.fontSize)
end

function TextLabel:bindToClick(callback)
    self.onClick = callback
end

function TextLabel:update(dt)
    if not self.onClick then
        return
    end

    local mx, my = love.mouse.getPosition()
    local w, h = self.font:getWidth(self.text), self.font:getHeight()

    if mx >= self.x - w / 2 and mx <= self.x + w / 2 and my >= self.y - h / 2 and my <= self.y + h / 2 then
        self.color = { 1, 0, 0, 1 }

        if love.mouse.isDown(1) and not self.pressed then
            self.pressed = true
        elseif not love.mouse.isDown(1) and self.pressed then
            self.pressed = false
            
            Game.audio.play('click')
            
            self.onClick()
        end
    else
        self.color = { 1, 1, 1, 1 }
    end
end

function TextLabel:render()
    local w, h = self.font:getWidth(self.text), self.font:getHeight()

    love.graphics.setFont(self.font)
    love.graphics.setColor(self.color)
    love.graphics.print(self.text, self.x - w / 2, self.y - h / 2)
end

return TextLabel