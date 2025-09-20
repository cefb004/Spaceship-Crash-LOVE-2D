ObstPair = Class{}

local GAP_HEIGHT = 90

function ObstPair:init(y)
    -- initialize obstacles past the end of the screen
    self.x = VIRTUAL_WIDTH + 32

    -- y value is for the topmost obstacle; gap is a vertical shift of the second lower obstacle
    self.y = y

    -- instantiate two obstacles that belong to this pair
    self.obsts = {
        ['upper'] = Obstacle('top', self.y),
        ['lower'] = Obstacle('bottom', self.y + OBSTACLE_HEIGHT + GAP_HEIGHT)
    }

    -- whether this obstacle pair is ready to be removed from the scene
    self.remove = false
end

function ObstPair:update(dt)
    -- remove the obstacle from the scene if it's beyond the left edge of the screen,
    -- else move it from right to left
    if self.x > -OBSTACLE_WIDTH then
        self.x = self.x - OBSTACLE_SPEED * dt
        self.obsts['lower'].x = self.x
        self.obsts['upper'].x = self.x
    else
        self.remove = true
    end
end

function ObstPair:render()
    for k, obst in pairs(self.obsts) do
        obst:render()
    end
end