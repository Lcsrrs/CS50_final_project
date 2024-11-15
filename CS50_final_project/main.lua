local Player = require "player"

WINDOW_WIDTH, WINDOW_HEIGHT = love.window.getMode()
--WINDOW_WIDTH, WINDOW_HEIGHT = WINDOW_WIDTH * 0.8, WINDOW_HEIGHT * 0.8

function love.load()
    local show_debugging = true
    
    love.window.setMode(WINDOW_WIDTH,WINDOW_HEIGHT, {fullscreen = false, vsync = true})
    
    player = Player(show_debugging)

    --love.window.setFullscreen(true, "desktop")
end

function love.update(dt)
    mouse_x, mouse_y = love.mouse.getPosition()
    player:movePlayer()
end


function love.draw()
    player:draw()

    if love.keyboard.isDown("w") then
        player.thrusting_up = true
    else
        player.thrusting_up = false
    end

    if love.keyboard.isDown("a") then
        player.thrusting_left = true
    else
        player.thrusting_left = false
    end

    if love.keyboard.isDown("s") then
        player.thrusting_down = true
    else
        player.thrusting_down = false
    end

    if love.keyboard.isDown("d") then
        player.thrusting_right = true
    else
        player.thrusting_right = false
    end


    love.graphics.print(love.timer.getFPS(), 10, 10)
end