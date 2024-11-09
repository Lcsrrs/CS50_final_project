WINDOW_WIDTH, WINDOW_HEIGHT = love.window.getDesktopDimensions()
WINDOW_WIDTH, WINDOW_HEIGHT = WINDOW_WIDTH * 0.8, WINDOW_HEIGHT * 0.8

function love.load()
    love.window.setMode(WINDOW_WIDTH,WINDOW_HEIGHT, {fullscreen = false, vsync = true})
    
    spaceship = {}
    spaceship.x = WINDOW_HEIGHT/2
    spaceship.y = WINDOW_WIDTH/2
    spaceship.sprite = love.graphics.newImage("sprites/spaceship.PNG")
    spaceship.orientation = 0

    --love.window.setFullscreen(true, "desktop")
end

function love.update(dt)
    if love.keyboard.isDown('s') then
        spaceship.y = spaceship.y + 25
    end
    if love.keyboard.isDown('w') then
        spaceship.y = spaceship.y - 25
    end
    if love.keyboard.isDown('d') then
        spaceship.x = spaceship.x + 25
    end
    if love.keyboard.isDown('a') then
        spaceship.x = spaceship.x - 25
    end

    --spaceship.orientation = math.atan((love.mouse.getY() - spaceship.y) / (love.mouse.getX() - spaceship.x))

    -- Setting the screen limit for the spaceship
    if spaceship.x < 0 then
        spaceship.x = 0
    end
    if spaceship.x > WINDOW_WIDTH then
        spaceship.x = WINDOW_WIDTH
    end
    if spaceship.y < 0 then
        spaceship.y = 0
    end
    if spaceship.y > WINDOW_HEIGHT then
        spaceship.y = WINDOW_HEIGHT
    end
    
end


function love.draw()
    love.graphics.print({WINDOW_WIDTH}, 50, 50)
    love.graphics.print({WINDOW_HEIGHT}, 50, 100)
    love.graphics.print({spaceship.x}, 50, 200)
    love.graphics.print({spaceship.y}, 50, 300)

    --love.graphics.scale(0.07)
    love.graphics.draw(spaceship.sprite, spaceship.x, spaceship.y, spaceship.orientation)


end