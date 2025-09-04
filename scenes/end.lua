-- End screen 
local End = {}

function End:load()
end

function End:update(dt)
end

function End:draw(dt)
    love.graphics.print("GAME OVER - press q to go to home screen!", 300,300)
end

function End:keypressed( key, scancode, isrepeat )
    if key == "q" then
        changeSceneTo('start')
    end
end

return End