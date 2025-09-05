local Game = {}

-- Grid parameters 
local gridSize = 10 -- Square NxN grid 
local padding = math.floor(love.graphics.getWidth()/10) -- padding around the outside of the grid for other hud stuff
local gap = 5 -- gaps between objects in the grid 

-- general Item parameters
local lifespanLow = 9
local lifespanHigh = 20

local allowableWithin = 0.5 -- distance around item allowed to be considered within item

-- Useful collections
local items = {}
local colors = require('colors')
local colorKeys = {"red", "green", "blue"}
local shapes = {"square", "circle"}

-- Fonts
local scoreFont = love.graphics.newFont(20)
local timerFont = love.graphics.newFont(20)
local livesFont = love.graphics.newFont(20)
local ruleFont = love.graphics.newFont(20)

local rule = {}

local gridWidth = love.graphics.getWidth() - (padding * 2)
local itemSize = gridWidth/gridSize - (gap * 2)

-- Sounds
local targetClickSound = love.audio.newSource("assets/Audio/drop_004.ogg", "static")
local clickSound = love.audio.newSource("assets/Audio/tick_001.ogg", "static")
local errorSound = love.audio.newSource("assets/Audio/error_008.ogg", "static")
local ruleChangeSound = love.audio.newSource("assets/Audio/confirmation_001.ogg", "static")

local function resetItem(item)
    -- Item FACTORY
    item.colorName = colorKeys[math.random(#colorKeys)]
    item.color = colors[item.colorName]
    item.shape = shapes[math.random(#shapes)]
    item.lifespan = math.random(lifespanLow, lifespanHigh)
    item.age = 0
    item.size = itemSize
    item.isTarget = true
    if item.shape == "circle" then
        item.center  = {item.x + item.size/2, item.y + item.size/2}
    elseif item.shape == "square" then
        item.center = {item.x + item.size/2, item.y + item.size/2}
    end
end

local function setItemStatus(item, rule)
    item.isTarget = false
    if item.colorName == rule.color and item.shape == rule.shape then
        item.isTarget = true
    end
end

local function distanceBetween(x1, y1, x2, y2)
    return math.sqrt((x1-x2)^2 + (y1-y2)^2)
end

-- LOAD METHOD
function Game:load(state)
    state.score = 0
    state.timer = 35
    state.lives = 5
    state.roundTimer = 5

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
            
            resetItem(item)

            table.insert(items, item)
        end
    end

    -- load up random rule
    rule.color = colorKeys[math.random(#colorKeys)]
    rule.shape = shapes[math.random(#shapes)]
    rule.text = rule.color.." "..rule.shape.." is target"
    rule.textColor = colors[colorKeys[math.random(#colorKeys)]]


end

function Game:update(state, dt)
    -- check the current rule and update all the "isTarget" for the items
    for idx, item in pairs(items) do 
        setItemStatus(item, rule)
    end

    -- Kill and spawn items once they age out
    for idx, item in pairs(items) do
        item.age = item.age + 1*dt

        -- have items age (e.g., make size smaller)
        local t = item.age / item.lifespan
        local eased = t * t * t
        -->> item.size = item.size - (item.age/item.lifespan) * item.size * dt
        item.size = item.size - (eased * item.size * dt)

        if item.age > item.lifespan - 1 then
            -- reset color and shape
            resetItem(item)
            setItemStatus(item, rule)
        end
    end

    -- Update rule at the end of a round 
    if state.roundTimer < -0.5 then
        ruleChangeSound:play()
        rule.color = colorKeys[math.random(#colorKeys)]
        rule.shape = shapes[math.random(#shapes)]
        rule.text = rule.color.." "..rule.shape.." is target"
        rule.textColor = colors[colorKeys[math.random(#colorKeys)]]
        state.roundTimer = 10
    end

    -- End the game 
    if state.timer <= 0 then
        changeSceneTo("end")
    end

    if state.lives <=0 then
        changeSceneTo("end")
    end


    state.timer = state.timer - 1 * dt
    state.roundTimer = state.roundTimer - 1 * dt

end

function Game:draw(state, dt)
    for idx,item in pairs(items) do
        love.graphics.setColor(item.color)
        if item.shape == "circle" then
            love.graphics.circle("fill", item.x+item.size/2, item.y+item.size/2, item.size/2)
            -- love.graphics.print(item.age, item.x+item.size/2, item.y+item.size/2)
        else
            love.graphics.rectangle("fill",item.x, item.y, item.size, item.size)
        end
    end

    love.graphics.setColor(colors["white"])
    -- HUD
    love.graphics.setFont(scoreFont)
    love.graphics.print("Score: "..state.score, love.graphics.getWidth()/2 - scoreFont:getWidth("Score: "..state.score)/2, 10)

    love.graphics.setFont(timerFont)
    local timerString = string.format("%0.2f",state.timer)
    love.graphics.print("Time: "..timerString, 10, 10)

    love.graphics.setFont(livesFont)
    love.graphics.print("Lives: "..state.lives, love.graphics.getWidth() - livesFont:getWidth("Lives: "..state.lives)-10, 10)

    love.graphics.setFont(ruleFont)
    local roundTimerString = string.format("%0.2f",state.roundTimer)
    love.graphics.print(roundTimerString, 10, love.graphics.getHeight() - (ruleFont:getHeight() + 10))

    love.graphics.setColor(rule.textColor)
    love.graphics.setFont(ruleFont)
    love.graphics.print("RULE: "..rule.text, love.graphics.getWidth()/2 - ruleFont:getWidth("RULE: "..rule.text)/2, love.graphics.getHeight() - (ruleFont:getHeight() + 10)  )

    

end

function Game:keypressed(state, key, scancode, isrepeat )
    if key == "q" then
        changeSceneTo('end')
    end
end

function Game:mousepressed(state, x, y, button, istouch, presses)
    clickSound:play()

    for idx,item in pairs(items) do
        local d = distanceBetween(x,y,item.center[1], item.center[2])
        if d <= item.size/2 + allowableWithin then 
            if item.isTarget then
                state.score = state.score + 1

                resetItem(item)
                setItemStatus(item, rule)

                -- play sound
                targetClickSound:play()
            else
                state.lives = state.lives - 1
                errorSound:play()
            end
        end
    end

end







return Game