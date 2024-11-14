function Player(debugging) 
    local start_angle = 0

    debugging = debugging or false

    return {
        x = love.graphics.getWidth() / 2,
        y = love.graphics.getHeight() / 2,
        sprite = love.graphics.newImage("sprites/spaceship.PNG", {dpiscale = 20}),
        orientation = 0,
        thrusting = false,
        thrust = {
            x = 0,
            y = 0,
            speed = 5,
        },

        draw = function(self)
            local opacity = 1

            if debugging then
                love.graphics.setColor(1, 0, 0)

                love.graphics.rectangle("line", self.x + 5, self.y + 5, 45, 45)

            end

            love.graphics.setColor(1, 1, 1)
            love.graphics.draw(self.sprite, self.x, self.y, self.orientation)

        end,

        movePlayer = function(self)
            local FPS = love.timer.getFPS()
            local friction = 0.7

            if love.keyboard.isDown('s') then
                self.y = self.y + 10
            end
            if love.keyboard.isDown('w') then
                self.y = self.y - 10
            end
            if love.keyboard.isDown('d') then
                self.x = self.x + 10
            end
            if love.keyboard.isDown('a') then
                self.x = self.x - 10
            end

            if self.thrusting then
                self.thrust.x = self.thrust.x + self.thrust.speed * math.cos(self.orientation) / FPS
                self.thrust.y = self.thrust.y - self.thrust.speed * math.sin(self.orientation) / FPS
            else
                if self.thrust.x ~= 0 or self.thrust.y ~= 0 then
                    self.thrust.x = self.thrust.x - friction * self.thrust.x / FPS
                    self.thrust.y = self.thrust.y - friction * self.thrust.x / FPS
                end
            end

            self.x = self.x + self.thrust.x
            self.y = self.y + self.thrust.y

            if self.x + 45 < 0 then
                self.x = love.graphics.getWidth() + 45
            elseif self.x - 45 > love.graphics.getWidth() then
                self.x = -45
            elseif self.y + 45 < 0 then
                self.y = love.graphics.getHeight() + 45
            elseif self.y - 45 > love.graphics.getHeight() then
                self.y = - 45
            end


        end
    }
end

return Player 