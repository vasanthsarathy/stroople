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

local score = 0
local timer = 90
local lives = 3
local roundTimer = 10

local rule = {}


-- Fonts
local scoreFont = love.graphics.newFont(20)
local timerFont = love.graphics.newFont(20)
local livesFont = love.graphics.newFont(20)
local ruleFont = love.graphics.newFont(20)

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
            item.lifespan = math.random(9,12)

            table.insert(items, item)
        end
    end

    -- load up random rule
    rule.color = colorKeys[math.random(#colorKeys)]
    rule.shape = shapes[math.random(#shapes)]
    rule.text = rule.color.." "..rule.shape.." is target"

end

function Game:update(dt)
    timer = timer - 1 * dt
    roundTimer = roundTimer - 1 * dt

    -- Kill and spawn items once they age out
    for idx, item in pairs(items) do
        item.age = item.age + 1*dt

        if item.age > item.lifespan then
            -- reset color and shape
            item.color = colors[colorKeys[math.random(#colorKeys)]]
            item.shape = shapes[math.random(#shapes)]
            item.lifespan = math.random(9,12)
            item.age = 0
        end
    end

    if roundTimer < 0 then
        rule.color = colorKeys[math.random(#colorKeys)]
        rule.shape = shapes[math.random(#shapes)]
        rule.text = rule.color.." "..rule.shape.." is target"
        roundTimer = 10
    end

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

    -- HUD
    love.graphics.setFont(scoreFont)
    love.graphics.print("Score: "..score, love.graphics.getWidth()/2 - scoreFont:getWidth("Score: "..score)/2, 10)

    love.graphics.setFont(timerFont)
    love.graphics.print("Time: "..timer, 10, 10)

    love.graphics.setFont(livesFont)
    love.graphics.print("Lives: "..lives, love.graphics.getWidth() - livesFont:getWidth("Lives: "..lives)-10, 10)

    love.graphics.setFont(ruleFont)
    love.graphics.print("RULE: "..rule.text, love.graphics.getWidth()/2 - ruleFont:getWidth("RULE: "..rule.text)/2, love.graphics.getHeight() - (ruleFont:getHeight() + 10)  )
end

function Game:keypressed( key, scancode, isrepeat )
    if key == "q" then
        changeSceneTo('end')
    end
end


return Game