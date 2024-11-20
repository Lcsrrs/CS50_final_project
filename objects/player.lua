function Player(debugging) 
    local start_angle = 0

    debugging = debugging or false

    return {
        x = love.graphics.getWidth() / 2,
        y = love.graphics.getHeight() / 2,
        sprite = love.graphics.newImage("sprites/spaceship.PNG", {dpiscale = 20}),
        orientation = 0,
        thrusting_up = false,
        thrusting_left = false,
        thrusting_down = false,
        thrusting_right = false,
        thrust = {
            x = 0,
            y = 0,
            speed = 5,
        },

        draw = function(self, faded)
            local opacity = 1

            if faded then
                opacity = 0.2
            end

            sprite_height = self.sprite:getHeight()
            sprite_width = self.sprite:getWidth()

            if debugging then
                love.graphics.push()
                love.graphics.setColor(1, 0, 0)
                love.graphics.circle("line", self.x, self.y, sprite_width/2)
                love.graphics.pop()

                love.graphics.push()
                love.graphics.setColor(1, 1, 1)
                love.graphics.setFont(love.graphics.newFont(13))
                love.graphics.print(self.thrust.x, 10, 20)
                love.graphics.print(self.thrust.y, 10, 30)
                love.graphics.pop()
            end

            
            love.graphics.push()
            love.graphics.setColor(1, 1, 1, opacity)
            love.graphics.draw(self.sprite, self.x, self.y, self.orientation, 1, 1, sprite_width/2 , sprite_height/2)
            love.graphics.pop()
            
            

 
        end,

        movePlayer = function(self)
            local FPS = love.timer.getFPS()
            local friction = 0.7
            local mouse_x = love.mouse.getX()
            local mouse_y = love.mouse.getY()
            sprite_height = self.sprite:getHeight()
            sprite_width = self.sprite:getWidth()
            self.orientation = math.atan2(self.y - sprite_height/2 - mouse_y, self.x - sprite_width/2 - mouse_x) + math.deg(90)

            if self.thrusting_up then
                self.thrust.y = self.thrust.y - self.thrust.speed / FPS
            else
                if self.thrust.y ~= 0 then
                    self.thrust.y = self.thrust.y - friction * self.thrust.y / FPS
                end
            end

            if self.thrusting_left then
                self.thrust.x = self.thrust.x - self.thrust.speed / FPS
            else
                if self.thrust.x ~= 0 then
                    self.thrust.x = self.thrust.x - friction * self.thrust.x / FPS
                end
            end

            if self.thrusting_down then
                self.thrust.y = self.thrust.y + self.thrust.speed / FPS
            else
                if self.thrust.y ~= 0 then
                    self.thrust.y = self.thrust.y - friction * self.thrust.y / FPS
                end
            end

            if self.thrusting_right then
                self.thrust.x = self.thrust.x + self.thrust.speed / FPS
            else
                if self.thrust.x ~= 0 then
                    self.thrust.x = self.thrust.x - friction * self.thrust.x / FPS
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