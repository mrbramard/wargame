local game = {
    text = "The game scene"
}

local map = require "core.map"
local sprite = require "core.sprite"
local test_map = require "maps.test"
local mapWidth, mapHeight = map:getDimensions(test_map.map)
local mapX, mapY = canvasConf.width / 2 - mapWidth / 2, canvasConf.height / 2 - mapHeight / 2

function game:keypressed(key, isrepeat)
    if key == "escape" then
        current_scene = require "scene.title"
    end

    if key == "space" then
        game.text = "Modified game scene"
    end
end

function game:mousepressed(x, y, button, istouch)
    canvasx, canvasy = screenToCanvas(x, y)
    mappos = map:canvasToMap(test_map, canvasx, canvasy)

    for _, s in ipairs(test_map.sprites) do
        if s[2] == mappos then
            sprite.sprites[s[1]].animations.idle.duration = 3
        end
    end
end

function game:update(dt)
    for i, s in ipairs(test_map.sprites) do
        if not sprite.sprites[i].animations then
            break
        end

        if sprite.sprites[i].animations.timer + dt > sprite.sprites[i].animations.idle.duration then
            sprite.sprites[i].animations.timer = 0
            sprite.sprites[i].animations.current_frame = sprite.sprites[i].animations.current_frame + 1
        else
            sprite.sprites[i].animations.timer = sprite.sprites[i].animations.timer + dt
        end

        if sprite.sprites[i].animations.current_frame > #sprite.sprites[i].animations.idle.frames then
            sprite.sprites[i].animations.current_frame = 1
        end
    end
end

function game:draw()
    map:draw(test_map.map, mapX, mapY)

    sprite:initializeSpriteBatch()
    for _, s in ipairs(test_map.sprites) do
        local pos = map:mapToCanvas(test_map.map, s[2] % test_map.map.mapWidth, math.ceil(s[2] / test_map.map.mapWidth))

        local quadToDisplay = sprite.sprites[s[1]].quads[1]
        if sprite.sprites[s[1]].animations then
            quadToDisplay = sprite.sprites[s[1]].quads[sprite.sprites[s[1]].animations.idle.frames[sprite.sprites[s[1]]
                                .animations.current_frame]]
        end
        sprite:addSpriteToSpriteBatch(quadToDisplay, pos.x, pos.y, test_map.map.zoom, test_map.map.zoom, s[3])
    end
    sprite:drawSpriteBatch()
end

return game
