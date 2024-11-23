local Laser = require "objects/laser"
require "globals"

function Player() 
    local start_angle = 0
    local LASER_MAX_TIME = 0.025
    local MAX_LASERS = 10

    local EXPLODE_DUR = 3

    return {
        x = love.graphics.getWidth() / 2,
        y = love.graphics.getHeight() / 2,
        sprite = love.graphics.newImage("sprites/spaceship.PNG", {dpiscale = 20}),
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

        shootLaser = function(self)
            if #self.lasers < MAX_LASERS then
                table.insert(self.lasers, Laser(
                    self.x,
                    self.y,
                    self.orientation*(-1) + math.pi/2
                ))
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

            sprite_height = self.sprite:getHeight()
            sprite_width = self.sprite:getWidth()

            if show_debugging then
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

            if not self.exploding then
                love.graphics.push()
                love.graphics.setColor(1, 1, 1, opacity)
                love.graphics.draw(self.sprite, self.x, self.y, self.orientation, 1, 1, sprite_width/2 , sprite_height/2)
                love.graphics.pop()

                for _, laser in pairs(self.lasers) do
                    laser:draw(faded, show_debugging)
                end
            else
                love.graphics.setColor (1, 0, 0, opacity)
                love.graphics.circle("fill", self.x, self.y, sprite_width * 1.5)

                love.graphics.setColor (1, 158/255, 0, opacity)
                love.graphics.circle("fill", self.x, self.y, sprite_width)                
                
                love.graphics.setColor (1, 234/255, 0, opacity)
                love.graphics.circle("fill", self.x, self.y, sprite_width * 0.5)                
            end
            


        end,


        movePlayer = function(self, dt)
            local FPS = love.timer.getFPS()
            local friction = 0.7
            local mouse_x = love.mouse.getX()
            local mouse_y = love.mouse.getY()
            sprite_height = self.sprite:getHeight()
            sprite_width = self.sprite:getWidth()
            self.orientation = math.atan2(self.y - sprite_height/2 - mouse_y, self.x - sprite_width/2 - mouse_x) + 1.47*math.pi

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
            self.explode_time = math.ceil(EXPLODE_DUR * love.timer.getFPS())
        end
    }
end

return Player 