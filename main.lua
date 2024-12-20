local Player = require "objects/player"
local Game = require "states/game"
local Menu = require "states/menu"
local SFX = require "components/SFX"
require "globals"

local reset_complete = false
math.randomseed(os.time())

WINDOW_WIDTH, WINDOW_HEIGHT = love.window.getMode()


function reset()
    local save_data = readJSON("save")

    sfx = SFX()

    player = Player(3, sfx)
    game = Game(save_data, sfx)
    menu = Menu(game, player, sfx)
    detroy_ast = false
end

function love.load()   
    love.mouse.setVisible(false) 
    love.window.setMode(WINDOW_WIDTH,WINDOW_HEIGHT, {fullscreen = false, vsync = true})

    reset()

    sfx:playBGM()
end

function love.update(dt)
    mouse_x, mouse_y = love.mouse.getPosition()
    
    if game.state.running then
        player:movePlayer(dt)

        for ast_index, asteroid in pairs(asteroids) do
            if not player.exploding and not player.invencible then
                if calculateDistance(player.x, player.y, asteroid.x, asteroid.y) < asteroid.radius then
                    player:explode()
                    destroy_ast = true
                    end
            else
                player.explode_time = player.explode_time - 1
                
                if player.explode_time == 0 then
                    if player.lives - 1 <= 0 then
                        game:changeGameState("ended")
                        return
                    end

                    player = Player(player.lives - 1, sfx)
                end
            end
            for _, laser in pairs(player.lasers) do
                if calculateDistance(laser.x, laser.y, asteroid.x, asteroid.y) < asteroid.radius then
                    laser:explode()
                    asteroid:destroy(asteroids, ast_index, game)
                end
            end

            if destroy_ast then
                if player.lives - 1 <= 0 then
                    if player.explode_time == 0 then
                        destroy_ast = false
                        asteroid:destroy(asteroids, ast_index, game)
                    end
                else
                    destroy_ast = false
                    asteroid:destroy(asteroids, ast_index, game)
                end
            end

            asteroid:move(dt)
        end

        if #asteroids == 0 then
            game.level = game.level + 1
            game:startNewGame(player)
        end

    elseif game.state.menu then
        menu:run(clickedMouse)
        
        clickedMouse = false

        if not reset_complete then
            reset()
            reset_complete = true
        end

    elseif game.state.ended then
        reset_complete = false
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
            else
                clickedMouse = true
            end
        end
    end
end


function love.draw()
    if game.state.running or game.state.paused then
        player:draw_lives(game.state.paused)
        player:draw(game.state.paused)

        for _, asteroid in pairs(asteroids) do
            asteroid:draw(game.state.paused)
        end

        game:draw(game.state.paused)
    elseif game.state.menu then
        menu:draw()
    elseif game.state.ended then
        game:draw()
    end

    love.graphics.circle("fill", mouse_x, mouse_y, 10)

    love.graphics.push()

    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(love.graphics.newFont(13))
    love.graphics.print(love.timer.getFPS(), 10, 10)

    love.graphics.pop()
end