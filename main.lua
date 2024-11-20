local Player = require "objects/player"
local Game = require "states/game"

math.randomseed(os.time())

WINDOW_WIDTH, WINDOW_HEIGHT = love.window.getMode()
--WINDOW_WIDTH, WINDOW_HEIGHT = WINDOW_WIDTH * 0.8, WINDOW_HEIGHT * 0.8

function love.load()
    local show_debugging = true
    
    love.window.setMode(WINDOW_WIDTH,WINDOW_HEIGHT, {fullscreen = false, vsync = true})
    
    player = Player(show_debugging)
    game = Game()
    game:startNewGame(player)

end

function love.update(dt)
    mouse_x, mouse_y = love.mouse.getPosition()
    
    if game.state.running then
        player:movePlayer()

        for ast_index, asteroid in pairs(asteroids) do
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