push = require 'push'

Class = require 'class'

require 'Ship'

require 'Obstacle'

require 'ObstPair'


WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288


-- images we load into memory from files to later draw onto the screen
local background = love.graphics.newImage('background.png')
local backgroundScroll = 0

local ground = love.graphics.newImage('ground.png')
local groundScroll = 0

local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED     = 60

local BACKGROUND_LOOPING_POINT = 413

local ship = Ship()

local obstacles = {}

local ObstPairs = {}

local spawnTimer = 0

local lastY = -OBSTACLE_HEIGHT + math.random(80) + 20

local scrolling = true


function love.load()
    -- initialize our nearest-neighbor filter
    love.graphics.setDefaultFilter('nearest', 'nearest')
	
	math.randomseed(os.time())


    -- app window title
    love.window.setTitle('Spaceship Crash')

    -- initialize our virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })
	
	love.keyboard.keysPressed = {}

end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end
end

function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

function love.update(dt)
  if scrolling then
      backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt)
	  % BACKGROUND_LOOPING_POINT

      groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt)
      % VIRTUAL_WIDTH
	  
	 spawnTimer = spawnTimer + dt

    -- spawn a new obstacle if the timer is past 2 seconds
    if spawnTimer > 2 then
        -- modify the last Y coordinate we placed so obstacles gaps aren't too far apart
        -- no higher than 10 pixels below the top edge of the screen,
        -- and no lower than a gap length (90 pixels) from the bottom
        local y = math.max(-OBSTACLE_HEIGHT + 10, 
            math.min(lastY + math.random(-20, 20), VIRTUAL_HEIGHT - 90 - OBSTACLE_HEIGHT))
        lastY = y
        
        table.insert(ObstPairs, ObstPair(y))
        spawnTimer = 0
    end
	  
	  ship:update(dt)
	  
    -- for every obstacle in the scene...
    for k, pair in pairs(ObstPairs) do
        pair:update(dt)
    end

           -- check to see if ship collided with obstacle
            for l, obstacle in pairs(ObstPairs) do
                if ship:collides(obstacle) then
                    -- pause the game to show collision
                    scrolling = false
                end
            end

    -- remove any flagged obstacles
    -- we need this second loop, rather than deleting in the previous loop, because
    -- modifying the table in-place without explicit keys will result in skipping the
    -- next obstacle, since all implicit keys (numerical indices) are automatically shifted
    -- down after a table removal
    for k, pair in pairs(ObstPairs) do
        if pair.remove then
            table.remove(ObstPairs, k)
        end
    end
  end

    love.keyboard.keysPressed = {}

end

function love.draw()
    push:start()
    
    -- draw the background starting at top left (0, 0)
    love.graphics.draw(background, -backgroundScroll, 0)
	
    -- render all the obstacle pairs in our scene
    for k, pair in pairs(ObstPairs) do
        pair:render()
    end

    -- draw the ground on top of the background, toward the bottom of the screen
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)
	
	ship:render()
	    
    push:finish()
end