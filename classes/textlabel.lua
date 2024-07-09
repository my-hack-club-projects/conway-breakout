local oo = require 'lib.oo'
local Game = require 'classes.game'

local TextLabel = oo.class()

function TextLabel:init(x, y, text, fontSize)
    self.text = text or ''
    self.fontSize = fontSize or 12
    self.x = x or 0
    self.y = y or 0

    self.pressed = false

    self.font = love.graphics.newFont(Game.FontName, self.fontSize)
end

function TextLabel:bindToClick(callback)
    self.onClick = callback
end

function TextLabel:update(dt)
    if self.onClick and love.mouse.isDown(1) then
        if self.pressed then return end

        local mx, my = love.mouse.getPosition()
        if mx >= self.x and mx <= self.x + self.font:getWidth(self.text) and
           my >= self.y and my <= self.y + self.font:getHeight() then
            self.pressed = true

            if self.onClick then
                self.onClick()
            end
        end
    else
        self.pressed = false
    end
end

function TextLabel:render()
    local w, h = self.font:getWidth(self.text), self.font:getHeight()

    love.graphics.setFont(self.font)
    love.graphics.print(self.text, self.x - w / 2, self.y - h / 2)
end

return TextLabel