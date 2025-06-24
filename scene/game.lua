local game = {
    text = "The game scene"
}

local mapsys = require "engine.mapsys"
local spritesys = require "engine.spritesys"
local test_map = require "maps.test"

local spritesheet = love.graphics.newImage("assets/spritesheet.png")
local spritebatch = love.graphics.newSpriteBatch(spritesheet)

local redSoldierSprite = spritesys:new(spritesheet,
    {{0, 0}, {16, 0}, {32, 0}, {48, 0}, {48, 16}, {48, 32}},
    {
        {
            id = "idle",
            frames = {1, 2, 3, 2},
            duration = 0.4
        }, {
            id = "run",
            frames = {4, 5, 4, 6},
            duration = 0.2
        }
    },
    {
        label = "Inftry",
        move = 3,
        hp = 10,
        ammo = 0,
        fuel = 99
    }
)

local blueSoldierSprite = spritesys:new(spritesheet, {{0, 16}}, nil, 
    {
        label = "Inftry",
        move = 3,
        hp = 10,
        ammo = 0,
        fuel = 99
    })
local spriteTypes = {redSoldierSprite, blueSoldierSprite}

local width, mapHeight = mapsys:getDimensions(test_map)
local mapX, mapY = canvasConf.width / 2 - width / 2, canvasConf.height / 2 - mapHeight / 2

local selectedSoldier = nil
local hoverSoldier = nil
local hoverTile = nil
local ui_rect_w, ui_rect_h = 130, 200

function game:load()
    if music then music:stop() end
    music = love.audio.newSource("assets/music/neils-theme.mp3", "stream")
    music:setLooping(true)
    music:play()
end

function game:keypressed(key, isrepeat)
    if key == "escape" then
        current_scene = require "scene.title"
        current_scene:load()
    end

    if key == "space" then
        game.text = "Modified game scene"
    end
end

function game:mousepressed(x, y, button, istouch)
    local canvasx, canvasy = screenToCanvas(x, y)
    local mappos = mapsys:canvasToMap(test_map, canvasx, canvasy)

    for _, s in ipairs(test_map.sprites.red) do
        if s[2] == mappos then
            if selectedSoldier == s then selectedSoldier = nil
            else selectedSoldier = s
            end
            s.animation.state = s.animation.state == "idle" and "run" or "idle"
        end
    end
end

function game:mousemoved(x, y, dx, dy, istouch)
    local canvasx, canvasy = screenToCanvas(x, y)
    local mappos = mapsys:canvasToMap(test_map, canvasx, canvasy)

    hoverTile = test_map.tileInfos[test_map.data[mappos]]

    hoverSoldier = nil
    for _, s in ipairs(test_map.sprites.red) do
        if s[2] == mappos then
            hoverSoldier = spriteTypes[s[1]]
        end
    end

    for _, s in ipairs(test_map.sprites.blue) do
        if s[2] == mappos  then
            hoverSoldier = spriteTypes[s[1]]
        end
    end
end

function game:update(dt)
    for i, s in ipairs(test_map.sprites.red) do
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

    for i, s in ipairs(test_map.sprites.blue) do
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
    mapsys:draw(test_map, mapX, mapY)

    spritesys:initializeSpriteBatch(spritebatch)
    for _, s in ipairs(test_map.sprites.red) do
        local pos = mapsys:mapToCanvas(test_map, s[2] % test_map.width, math.ceil(s[2] / test_map.width))

        local quadToDisplay = spriteTypes[s[1]].quads[1]
        if spriteTypes[s[1]].animations and s.animation then
            quadToDisplay = spriteTypes[s[1]].quads[spriteTypes[s[1]].animations[s.animation.state].frames[s.animation
                                .current_frame]]
        end
        spritesys:addSpriteToSpriteBatch(spritebatch, quadToDisplay, pos.x, pos.y, test_map.zoom, test_map.zoom, s[3])
    end

    for _, s in ipairs(test_map.sprites.blue) do
        local pos = mapsys:mapToCanvas(test_map, (s[2] % test_map.width) + 1, math.ceil(s[2] / test_map.width))

        local quadToDisplay = spriteTypes[s[1]].quads[1]
        if spriteTypes[s[1]].animations and s.animation then
            quadToDisplay = spriteTypes[s[1]].quads[spriteTypes[s[1]].animations[s.animation.state].frames[s.animation
                                .current_frame]]
        end
        spritesys:addSpriteToSpriteBatch(spritebatch, quadToDisplay, pos.x, pos.y, test_map.zoom, test_map.zoom, s[3])
    end

    spritesys:drawSpriteBatch(spritebatch)

    if hoverTile then
        draw_ui_rect(canvasConf.width - (ui_rect_w + 20), canvasConf.height - (ui_rect_h + 20), ui_rect_w, ui_rect_h)
        love.graphics.print(hoverTile.label, canvasConf.width - (ui_rect_w + 20), canvasConf.height - (ui_rect_h + 20))
        love.graphics.print("DEF " .. hoverTile.defense, canvasConf.width - (ui_rect_w + 20), canvasConf.height - (ui_rect_h + 20) + 16)
    end

    if hoverSoldier then
        draw_ui_rect(canvasConf.width - (ui_rect_w*2 + 20), canvasConf.height - (ui_rect_h + 20), ui_rect_w, ui_rect_h)
        love.graphics.print(hoverSoldier.infos.label, canvasConf.width - (ui_rect_w*2 + 20), canvasConf.height - (ui_rect_h + 20))
        love.graphics.print("HP " .. hoverSoldier.infos.hp, canvasConf.width - (ui_rect_w*2 + 20), canvasConf.height - (ui_rect_h + 20) + 16)
        love.graphics.print("AMMO " .. hoverSoldier.infos.ammo, canvasConf.width - (ui_rect_w*2 + 20), canvasConf.height - (ui_rect_h + 20) + 32)
        love.graphics.print("FUEL " .. hoverSoldier.infos.fuel, canvasConf.width - (ui_rect_w*2 + 20), canvasConf.height - (ui_rect_h + 20) + 48)
    end
end

function draw_ui_rect(x, y, w, h)
    love.graphics.setColor(0,0,0,0.5)
    love.graphics.rectangle("fill", x, y, w, h)
    love.graphics.setColor(1,1,1)
end

return game
