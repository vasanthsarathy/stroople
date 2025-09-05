-- STROOPLE
--[[
Stroople is a simple game where you get points for clicking certain shapes and colors based on a rule. More correct clicks = more points. Wrong clicks and you lose a life. Loose three lives and you lose game. You have 90 seconds! Oh and wait, the rule for what you can and cannot click changes every 10 seconds.
]]--
local success = love.window.setMode( 600, 600 )
local colors = require('colors')

local state = {}

love.graphics.setBackgroundColor(colors['white'])

function love.load()
    changeSceneTo("start") --just for debugging. Change to "start" for real game
end

function love.update(dt)
    if Scene.update then Scene:update(state,dt) end
end

function love.draw()
    if Scene.draw then Scene:draw(state) end
end

function changeSceneTo(sceneName)
    -- Scenes: start, game, end
    Scene = require('Scenes/'..sceneName)
    if Scene.load then Scene:load(state) end
end

function love.keypressed( key, scancode, isrepeat )
    if Scene.keypressed then
        Scene:keypressed(state, key, scancode, isrepeat)
    end
end

function love.mousepressed( x, y, button, istouch, presses )
    if Scene.mousepressed then
        Scene:mousepressed(state, x, y, button, istouch, presses)
    end
end

