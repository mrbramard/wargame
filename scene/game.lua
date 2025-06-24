local game = {
    text = "The game scene"
}

local map = require "engine.map"
local sprite = require "engine.sprite"
local test_map = require "maps.test"

local redSoldierSprite = sprite:new({{0, 0}, {16, 0}, {32, 0}, {48, 0}, {48, 16}, {48, 32}}, {{
    id = "idle",
    frames = {1, 2, 3, 2},
    duration = 0.4
}, {
    id = "run",
    frames = {4, 5, 4, 6},
    duration = 0.2

}})
local blueSoldierSprite = sprite:new({{0, 16}})
local spriteTypes = {redSoldierSprite, blueSoldierSprite}

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
            s.animation.state = s.animation.state == "idle" and "run" or "idle"
        end
    end
end

function game:update(dt)
    for i, s in ipairs(test_map.sprites) do
        local spriteType = spriteTypes[s[1]]
        if not spriteType.animations or not s.animation then
            break
        end

        local anim = s.animation

        if anim.timer + dt > spriteType.animations[s.animation.state].duration then
            anim.timer = 0
            anim.current_frame = anim.current_frame + 1
        else
            anim.timer = anim.timer + dt
        end

        if anim.current_frame > #spriteType.animations[s.animation.state].frames then
            anim.current_frame = 1
        end
    end
end

function game:draw()
    map:draw(test_map.map, mapX, mapY)

    sprite:initializeSpriteBatch()
    for _, s in ipairs(test_map.sprites) do
        local pos = map:mapToCanvas(test_map.map, s[2] % test_map.map.mapWidth, math.ceil(s[2] / test_map.map.mapWidth))

        local quadToDisplay = spriteTypes[s[1]].quads[1]
        if spriteTypes[s[1]].animations and s.animation then
            quadToDisplay = spriteTypes[s[1]].quads[spriteTypes[s[1]].animations[s.animation.state].frames[s.animation
                                .current_frame]]
        end
        sprite:addSpriteToSpriteBatch(quadToDisplay, pos.x, pos.y, test_map.map.zoom, test_map.map.zoom, s[3])
    end
    sprite:drawSpriteBatch()
end

return game
