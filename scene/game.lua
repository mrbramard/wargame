local game = {
    text = "The game scene"
}

local mapsys = require "mapsys"
local test_map = require "maps.test"

function game:update(dt)
end

function game:keypressed(key, isrepeat)
    if key == "escape" then
        current_scene = require("scene.title")
    end

    if key == "space" then
        game.text = "Modified game scene"
    end
end

function game:draw()
    local mapWidth, mapHeight = mapsys:getDimensions(test_map)
    local mapX, mapY = canvasConf.width / 2 - mapWidth / 2, canvasConf.height / 2 - mapHeight / 2

    mapsys:draw(test_map, mapX, mapY)
    love.graphics.print(game.text, 0, 0)
end

return game
