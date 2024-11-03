function love.load()
    spaceship = love.graphics.newImage("sprites/spaceship.PNG")
end

function love.update(dt)
end

function love.draw()
    love.graphics.scale(0.07)
    
    love.graphics.draw(spaceship, 50, 50)
end