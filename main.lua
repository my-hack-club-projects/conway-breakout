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
        - Score is calculated using: 1 / (time) * 1000 or a similar formula
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

    States:
        - Start
        - Play
        - GameOver
]]