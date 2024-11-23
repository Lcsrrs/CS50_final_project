local Player = require "objects/player"
local Game = require "states/game"
require "globals"

math.randomseed(os.time())

WINDOW_WIDTH, WINDOW_HEIGHT = love.window.getMode()
--WINDOW_WIDTH, WINDOW_HEIGHT = WINDOW_WIDTH * 0.8, WINDOW_HEIGHT * 0.8

function love.load()    
    love.window.setMode(WINDOW_WIDTH,WINDOW_HEIGHT, {fullscreen = false, vsync = true})
    
    player = Player()
    game = Game()
    game:startNewGame(player)

end

function love.update(dt)
    mouse_x, mouse_y = love.mouse.getPosition()
    
    if game.state.running then
        player:movePlayer(dt)

        for ast_index, asteroid in pairs(asteroids) do
            if not player.exploding then
                if calculateDistance(player.x, player.y, asteroid.x, asteroid.y) < asteroid.radius then
                    player:explode()
                    destroy_ast = true
                end
            else
                player.explode_time = player.explode_time - 1            
            end
            for _, laser in pairs(player.lasers) do
                if calculateDistance(laser.x, laser.y, asteroid.x, asteroid.y) < asteroid.radius then
                    laser:explode()
                    asteroid:destroy(asteroids, ast_index, game)
                end
            end

            if destroy_ast then
                destroy_ast = false
                asteroid:destroy(asteroids, ast_index, game)
            end

            asteroid:move(dt)
        end

    end
    
    if game.state.running then
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
    end
    
    function love.keypressed(key)
        if key == "escape" then
            if game.state.running then
                game:changeGameState("paused")
            elseif game.state.paused then
                game:changeGameState("running")
            end
        end
    end

    function love.mousepressed(x, y, button, istouch, presses)
        if button == 1 then
            if game.state.running then
                player:shootLaser()
            end
        end
    end
end


function love.draw()
    if game.state.running or game.state.paused then
        player:draw(game.state.paused)

        for _, asteroid in pairs(asteroids) do
            asteroid:draw(game.state.paused)
        end

        game:draw(game.state.paused)
    end


    love.graphics.push()

    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(love.graphics.newFont(13))
    love.graphics.print(love.timer.getFPS(), 10, 10)

    love.graphics.pop()
end