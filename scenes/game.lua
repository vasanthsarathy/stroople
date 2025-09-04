local Game = {}

function Game:load()
end

function Game:update(dt)
end

function Game:draw(dt)
    love.graphics.print("Let's play! Press q to end the game", 300,300)
end

function Game:keypressed( key, scancode, isrepeat )
    if key == "q" then
        changeSceneTo('end')
    end
end

return Game