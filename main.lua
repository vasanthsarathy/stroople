-- STROOPLE
--[[
Stroople is a simple game where you get points for clicking certain shapes and colors based on a rule. More correct clicks = more points. Wrong clicks and you lose a life. Loose three lives and you lose game. You have 90 seconds! Oh and wait, the rule for what you can and cannot click changes every 10 seconds.
]]--


function love.load()
    changeSceneTo("start")
end

function love.update(dt)
end

function love.draw()
    if Scene.draw then Scene:draw() end
end

function changeSceneTo(sceneName)
    -- Scenes: start, game, end
    Scene = require('Scenes/'..sceneName)
    if Scene.load then Scene:load() end
end

function love.keypressed( key, scancode, isrepeat )
    if Scene.keypressed then
        Scene:keypressed(key, scancode, isrepeat)
    end
end



