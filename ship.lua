Ship = Class{}

local GRAVITY = 20

function Ship:init()
     self.image = love.graphics.newImage('ship.png')
	 self.width = self.image:getWidth()
	 self.height = self.image:getHeight()
	 
	 self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
	 self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)
	 
	 self.dy = 0

end

function Ship:collides(obstacle)
    -- the 2's are left and top offsets
    -- the 4's are right and bottom offsets
    -- both offsets are used to shrink the bounding box to give the player
    -- a little bit of leeway with the collision
    if (self.x + 2) + (self.width - 4) >= obstacle.x and self.x + 2 <= obstacle.x + OBSTACLE_WIDTH then
        if (self.y + 2) + (self.height - 4) >= obstacle.y and self.y + 2 <= obstacle.y + OBSTACLE_HEIGHT then
            return true
        end
    end

    return false
end


function Ship:render()
     love.graphics.draw(self.image, self.x, self.y)
end

function Ship:update(dt)
     self.dy = self.dy + GRAVITY * dt
	 self.y  = self.y + self.dy
	 
	if love.keyboard.wasPressed('space') then
        self.dy = -5
    end

end

