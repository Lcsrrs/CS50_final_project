local Laser = require "objects/laser"
require "globals"

function Player(num_lives, sfx) 
    local start_angle = 0
    local LASER_MAX_TIME = 0.025
    local MAX_LASERS = 10

    local EXPLODE_DUR = 3
    local USABLE_BLINKS = 10 * 2

    return {
        x = love.graphics.getWidth() / 2,
        y = love.graphics.getHeight() / 2,
        sprite = love.graphics.newImage("sprites/spaceship.PNG", {dpiscale = 20}),
        invencible = true,
        invencible_seen = true,
        time_blinked = USABLE_BLINKS,
        lasers = {},
        orientation = 0,
        explode_time = 0,
        exploding = false,
        thrusting_up = false,
        thrusting_left = false,
        thrusting_down = false,
        thrusting_right = false,
        thrust = {
            x = 0,
            y = 0,
            speed = 5,
        },
        lives = num_lives or 3,

        sprite_height = love.graphics.newImage("sprites/spaceship.PNG", {dpiscale = 20}):getHeight(),
        sprite_width = love.graphics.newImage("sprites/spaceship.PNG", {dpiscale = 20}):getWidth(),

        shootLaser = function(self)
            if #self.lasers < MAX_LASERS then
                table.insert(self.lasers, Laser(
                    self.x,
                    self.y,
                    self.orientation*(-1) + math.pi/2
                ))

                sfx:playFX("laser")
            end
        end,

        destroyLaser = function(self, index)
            table.remove(self.lasers, index)
        end,

        draw = function(self, faded)
            local opacity = 1

            if faded then
                opacity = 0.2
            end

            self.sprite_height = self.sprite:getHeight()
            self.sprite_width = self.sprite:getWidth()

            if show_debugging then
                love.graphics.push()
                love.graphics.setColor(1, 0, 0)
                love.graphics.circle("line", self.x, self.y, self.sprite_width/2)
                love.graphics.pop()

                love.graphics.push()
                love.graphics.setColor(1, 1, 1)
                love.graphics.setFont(love.graphics.newFont(13))
                love.graphics.print(self.thrust.x, 10, 20)
                love.graphics.print(self.thrust.y, 10, 30)
                love.graphics.pop()

            end

            if self.invencible_seen then
                love.graphics.setColor(1, 1, 1, faded and opacity or 0.5)
            else
                love.graphics.setColor(1, 1, 1, opacity)
            end

            if not self.exploding then
                love.graphics.push()
                love.graphics.setColor(1, 1, 1, opacity)
                love.graphics.draw(self.sprite, self.x, self.y, self.orientation, 1, 1, self.sprite_width/2 , self.sprite_height/2)
                love.graphics.pop()

                for _, laser in pairs(self.lasers) do
                    laser:draw(faded, show_debugging)
                end
            else
                love.graphics.setColor (1, 0, 0, opacity)
                love.graphics.circle("fill", self.x, self.y, self.sprite_width * 1.5)

                love.graphics.setColor (1, 158/255, 0, opacity)
                love.graphics.circle("fill", self.x, self.y, self.sprite_width)                
                
                love.graphics.setColor (1, 234/255, 0, opacity)
                love.graphics.circle("fill", self.x, self.y, self.sprite_width * 0.5)                
            end
        end,

        draw_lives = function(self, faded)
            local opacity = 1

            if faded then
                opacity = 0.2
            end

            if self.lives == 2 then
                love.graphics.setColor(1, 1, 0.5, opacity)
            elseif self.lives == 1 then
                love.graphics.setColor(1, 0.2, 0.2, opacity)
            else
                love.graphics.setColor(1, 1, 1, opacity)
            end

            local x_pos, y_pos = 45, 30
            self.sprite_height = self.sprite:getHeight()
            self.sprite_width = self.sprite:getWidth()

            for i = 1, self.lives do
                if self.exploding then
                    if i == self.lives then
                        love.graphics.setColor(1, 0, 0, opacity)
                    end
                end
                love.graphics.push()
                love.graphics.setColor(1, 1, 1, opacity)
                love.graphics.draw(self.sprite, (i*self.sprite_width + 10) + x_pos, y_pos, 1, 1, 1, self.sprite_width/2 , self.sprite_height/2)
                love.graphics.pop()
            end
        end,


        movePlayer = function(self, dt)
            local FPS = love.timer.getFPS()
            local friction = 0.7
            local mouse_x = love.mouse.getX()
            local mouse_y = love.mouse.getY()
            self.sprite_height = self.sprite:getHeight()
            self.sprite_width = self.sprite:getWidth()
            self.orientation = math.atan2(self.y - self.sprite_height/2 - mouse_y, self.x - self.sprite_width/2 - mouse_x) + 1.47*math.pi

            if self.invencible then
                self.time_blinked = self.time_blinked - dt*2

                if math.ceil(self.time_blinked) % 2 == 0 then
                    self.invencible_seen = false
                else
                    self.invencible_seen = true
                end

                if self.time_blinked <= 0 then
                    self.invencible = false
                end

            else
                self.time_blinked = USABLE_BLINKS
                self.invencible_seen = false
            end
            
            self.exploding = self.explode_time > 0
            
            if not self.exploding then
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
            for index, laser in pairs(self.lasers) do
                if (laser.time_on_screen > LASER_MAX_TIME) and laser.exploding == 0 then
                    laser:explode()
                end
    
                if laser.exploding == 0 then
                    laser:move(dt)
                elseif laser.exploding == 2 then
                    self.destroyLaser(self, index)
                end
            end
        end,
        

        explode = function(self)
            sfx:playFX("ship_explosion")
            self.explode_time = math.ceil(EXPLODE_DUR * love.timer.getFPS())
        end
    }
end

return Player 