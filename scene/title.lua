local title = {
    press_key = "Press space to begin"
}

function title:keypressed(key, isrepeat)
    if key == "escape" then
        love.event.quit()
    end

    if key == "space" then
        current_scene = require "scene.game"
    end
end

function title:mousepressed(x, y, button, istouch)
end

function title:update(dt)
end

function title:draw()
    local text = globals.game_title
    local font = love.graphics.getFont()
    local textWidth = font:getWidth(text)
    local textHeight = font:getHeight()
    love.graphics.print(text, (canvasConf.width - textWidth) / 2, (canvasConf.height - textHeight) / 2)
end

return title
