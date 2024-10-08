--[[
    Game: Breakout, except the cells at the top follow the rules of Conway's Game of Life.

    Tasks:
        - Create the paddle and ball, make them move
        - Create a grid of 1's and 0's, where all 1's are visible blocks that the ball and paddle collide with
        - Make the ball collide with the blocks, removing them before bouncing back
        - Make the paddle collide with the ball, bouncing it back
        - Make the ball collide with the walls, bouncing it back
        - Prevent the paddle from going off-screen
        - At the start of the game, insert random 1's and 0's into the grid near the top (define bounds for this)
        - Simulate the game of life on those cells (not the walls)
        - Add a timer that counts up until there are no cells left
        - Score is determined by the time it takes to clear the cells. Lower is better.
        - Add a game over screen that displays the score with a button to restart
        - Add a start screen that explains the game and has a button to start

    Objects:
        Paddle
            - x, y, width, height
            - update(dt)
            - render()
        Ball
            - x, y, radius
            - dx, dy
            - update(dt)
            - render()
            - collide()
        Block
            - x, y
            - visible
            - update(dt)
            - render()
        Cell (Block)
            - isCell=true
        State
            - enter()
            - exit()
            - update(dt)
            - render()
        Game -- main game object, passed to all states
            - state
            - bestTime
            - update(dt)
            - render()
            - setState(state)

    States:
        - Start
        - Play
        - GameOver
]]

local Game = require 'classes.game'

local INITIAL_STATE = require 'states.menu'

function love.load()
    love.window.setTitle("Conway's Breakout")

    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.window.setMode(640, 480, {
        fullscreen = false,
        resizable = true,
        vsync = false
    })

    local game = Game.new()

    game:setState(INITIAL_STATE.new(game))

    function love.update(dt)
        game:update(dt)
    end

    function love.draw()
        game:render()
    end
end