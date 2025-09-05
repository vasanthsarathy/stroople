-- End screen 
local End = {}
local colors = require('colors')

function End:load(state)
    endFont = love.graphics.newFont(50)
end

function End:update(state, dt)
end

function End:draw(state, dt)
    love.graphics.setColor(colors["white"])
    love.graphics.setFont(endFont)
    love.graphics.print("GAME OVER!", love.graphics.getWidth()/2 -  endFont:getWidth("GAME OVER!")/2, 100)

    love.graphics.setFont(endFont)
    love.graphics.print("SCORE: "..state.score, love.graphics.getWidth()/2 -  endFont:getWidth("SCORE: "..state.score)/2, 200)
end

function End:keypressed( state, key, scancode, isrepeat )
    if key == "q" then
        changeSceneTo('start')
    end
end

return End