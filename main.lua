local Player = require "player"

WINDOW_WIDTH, WINDOW_HEIGHT = love.window.getMode()
--WINDOW_WIDTH, WINDOW_HEIGHT = WINDOW_WIDTH * 0.8, WINDOW_HEIGHT * 0.8

function love.load()
    local show_debugging = true
    
    love.window.setMode(WINDOW_WIDTH,WINDOW_HEIGHT, {fullscreen = false, vsync = true})
    
    player = Player(show_debugging)

    --love.window.setFullscreen(true, "desktop")
end

function love.keypressed(key)
    if key == "w" then
        player.thrusting = true
    end
end

function love.keyreleased(key)
    if key == "w" then
        player.thrusting = false
    end
end

function love.update(dt)
    mouse_x, mouse_y = love.mouse.getPosition()
    player:movePlayer()
end


function love.draw()
    player:draw()

    love.graphics.print(love.timer.getFPS(), 10, 10)
end