local Start = {}

function Start:load()
end

function Start:update(dt)
end

function Start:draw(dt)
    love.graphics.circle("fill", 160, 160, 80)
    love.graphics.print("Press Space to begin or q to quit", 100, 100)
end

function Start:keypressed( key, scancode, isrepeat )
    if key == "space" then
        changeSceneTo("game")
    end
    if key == "q" then
        love.event.quit(0)
    end
end

return Start