Obstacle = Class{}

-- since we only want the image loaded once, not per instantation, define it externally
local OBSTACLE_IMAGE = love.graphics.newImage('Obstacle.png')

-- speed at which the obstacle should scroll right to left
OBSTACLE_SPEED = 60

-- height of obstacle image, globally accessible
OBSTACLE_HEIGHT = 288
OBSTACLE_WIDTH = 70

function Obstacle:init(orientation, y)
    self.x = VIRTUAL_WIDTH
    self.y = y

    self.width = OBSTACLE_IMAGE:getWidth()
    self.height = OBSTACLE_HEIGHT

    self.orientation = orientation
end

function Obstacle:update(dt)
    
end

function Obstacle:render()
    love.graphics.draw(OBSTACLE_IMAGE, self.x, 
        (self.orientation == 'top' and self.y + OBSTACLE_HEIGHT or self.y), 
        0, 1, self.orientation == 'top' and -1 or 1)
end