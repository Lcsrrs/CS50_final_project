require "globals"

function Laser(x, y, angle)    
    local LASER_SPEED = 500
    local explodingEnum = {
        not_exploding = 0,
        exploding = 0,
        done_exploding = 2
    }
    local EXPLODE_DUR = 0.2

    return {
        x = x,
        y = y,
        x_vel = LASER_SPEED * math.cos(angle) / love.timer.getFPS(),
        y_vel = -LASER_SPEED * math.sin(angle) / love.timer.getFPS(),
        time_on_screen = 0,
        exploding = 0,
        explode_time = 0,

        draw = function(self, faded)
            local opacity = 1

            if faded then
                opacity = 0.2
            end

            if self.exploding < 1 then 
                love.graphics.setColor(1, 1, 1, opacity)
    
                love.graphics.setPointSize(3)
    
                love.graphics.points(self.x, self.y)
            else
                love.graphics.setColor (1, 104/255, 0, opacity)
                love.graphics.circle("fill", self.x, self.y, 7 * 1.5)
                love.graphics.setColor (1, 234/255, 0, opacity)
                love.graphics.circle("fill", self.x, self.y, 7 * 1)
            end

            if show_debugging then
                love.graphics.push()
                love.graphics.setColor(1, 1, 1)
                love.graphics.setFont(love.graphics.newFont(13))
                love.graphics.print(self.time_on_screen, 10, 40)
                love.graphics.pop()
            end

        end,

        move = function(self, dt)
            self.x = self.x + self.x_vel
            self.y = self.y + self.y_vel

            if self.explode_time > 0 then
               self.exploding = 1 
            end

            self.time_on_screen = self.time_on_screen + dt / love.timer.getFPS()
        end,

        explode = function(self)
            self.explode_time = math.ceil(EXPLODE_DUR * (love.timer.getFPS() / 100))
            
            if self.explode_time > EXPLODE_DUR then
                self.exploding = 2
            end  
        end
    }

end

return Laser