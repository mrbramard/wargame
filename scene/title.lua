local title = {}

function title:load()
    if music then
        music:stop()
    end
    music = love.audio.newSource("assets/music/battle-fanfare.mp3", "stream")
    music:setLooping(true)
    music:play()
end

function title:keypressed(key, isrepeat)
    if key == "escape" then
        love.event.quit()
    end

    if key == "space" then
        scene_sys.switch("game")
    end
end

function title:draw()
    local text = globals.game_title
    local font = love.graphics.getFont()
    local textWidth = font:getWidth(text)
    local textHeight = font:getHeight()
    love.graphics.print(text, (canvasConf.width - textWidth) / 2, (canvasConf.height - textHeight) / 2)
end

return title
