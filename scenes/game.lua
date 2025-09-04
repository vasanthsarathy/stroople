local Game = {}

-- Grid parameters 
local gridSize = 4 -- Square NxN grid 
local padding = math.floor(love.graphics.getWidth()/10) -- padding around the outside of the grid for other hud stuff
local gap = 20 -- gaps between objects in the grid 

-- general Item parameters
local lifespan = 12

-- Useful collections
local items = {}
local colors = require('colors')
local colorKeys = {"red", "green"}
local shapes = {"square", "circle"}

-- LOAD METHOD
function Game:load()
    local gridWidth = love.graphics.getWidth() - (padding * 2)
    local itemSize = gridWidth/gridSize - (gap * 2)

    -- Create objects and assign to grid 
    items = {}
    for i=1,gridSize do

        for j= 1, gridSize do
            -- calculate x and y positions 
            local x = (padding + gap) + ((i-1) * (itemSize + (gap*2)))
            local y = (padding + gap) + ((j-1) * (itemSize + (gap*2)))

            local item = {}
            item.x = x
            item.y = y
            item.i = i
            item.j = j
            item.color = colors[colorKeys[math.random(#colorKeys)]]
            item.shape = shapes[math.random(#shapes)]
            item.age = 0
            item.isTarget = false
            item.size = itemSize

            table.insert(items, item)
        end
    end

end

function Game:update(dt)
end

function Game:draw(dt)
    for idx,item in pairs(items) do
        love.graphics.setColor(item.color)
        if item.shape == "circle" then
            love.graphics.circle("fill", item.x+item.size/2, item.y+item.size/2, item.size/2)
        else
            love.graphics.rectangle("fill",item.x, item.y, item.size, item.size)
        end
    end
end

function Game:keypressed( key, scancode, isrepeat )
    if key == "q" then
        changeSceneTo('end')
    end
end

return Game