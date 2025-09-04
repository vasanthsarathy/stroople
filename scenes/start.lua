local Start = {}
local sw = love.graphics.getWidth()
local sh = love.graphics.getHeight()

function Start:load(state)
    titleFont = love.graphics.newFont(50)
    instructFont = love.graphics.newFont(20, "light")
end

function Start:update(dt)
end

function Start:draw(dt)
    love.graphics.setFont(titleFont)
    love.graphics.print("STROOPLE", sw/2 - titleFont:getWidth("STROOPLE")/2, 200)

    love.graphics.setFont(instructFont)
    local instruction = "Press <SPACE> to begin or <q> to quit"
    love.graphics.print(instruction,  sw/2 - instructFont:getWidth(instruction)/2, 400)
end

function Start:keypressed(state, key, scancode, isrepeat )
    if key == "space" then
        changeSceneTo("game")
    end
    if key == "q" then
        love.event.quit(0)
    end
end

return Start