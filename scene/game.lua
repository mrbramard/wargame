local game = {
    text = "The game scene"
}

local map_sys = require "engine.map_sys"
local sprite_sys = require "engine.sprite_sys"
local anim_sys = require "engine.anim_sys"

local test_map = require "maps.test"

local spritesheet = love.graphics.newImage("assets/spritesheet.png")
local spritebatch = love.graphics.newSpriteBatch(spritesheet)

local redSoldierSprite = sprite_sys:new(spritesheet, {{0, 0}, {16, 0}, {32, 0}, {48, 0}, {48, 16}, {48, 32}}, {{
    id = "idle",
    frames = {1, 2, 3, 2},
    duration = 0.4
}, {
    id = "run",
    frames = {4, 5, 4, 6},
    duration = 0.2
}}, {
    label = "Inftry",
    move = 3,
    hp = 10,
    ammo = 0,
    fuel = 99
})

local blueSoldierSprite = sprite_sys:new(spritesheet, {{0, 16}}, nil, {
    label = "Inftry",
    move = 3,
    hp = 10,
    ammo = 0,
    fuel = 99
})
local spriteTypes = {redSoldierSprite, blueSoldierSprite}

local width, mapHeight = map_sys:getDimensions(test_map)
local mapX, mapY = canvasConf.width / 2 - width / 2, canvasConf.height / 2 - mapHeight / 2

local selectedSoldier = nil
local hoverSoldier = nil
local hoverTile = nil
local ui_rect_w, ui_rect_h = 130, 200

function game:load()
    if music then
        music:stop()
    end
    music = love.audio.newSource("assets/music/neils-theme.mp3", "stream")
    music:setLooping(true)
    music:play()
end

function game:keypressed(key, isrepeat)
    if key == "escape" then
        scene_sys.switch("title")
    end

    if key == "space" then
        game.text = "Modified game scene"
    end
end

function game:mousepressed(x, y, button, istouch)
    local canvasx, canvasy = screenToCanvas(x, y)
    local mappos = map_sys:canvasToMap(test_map, canvasx, canvasy)

    for _, s in ipairs(test_map.sprites.red) do
        if s[2] == mappos then
            if selectedSoldier == s then
                selectedSoldier = nil
                tilesInRange = {}
            elseif selectedSoldier and selectedSoldier ~= s then
                selectedSoldier.animation.state = "idle"
                selectedSoldier = s
            else
                selectedSoldier = s
            end
            s.animation.state = s.animation.state == "idle" and "run" or "idle"
        end
    end
end

function game:mousemoved(x, y, dx, dy, istouch)
    local canvasx, canvasy = screenToCanvas(x, y)
    local mappos = map_sys:canvasToMap(test_map, canvasx, canvasy)

    hoverTile = test_map.tileInfos[test_map.data[mappos]]

    hoverSoldier = nil
    for _, s in ipairs(test_map.sprites.red) do
        if s[2] == mappos then
            hoverSoldier = spriteTypes[s[1]]
        end
    end

    for _, s in ipairs(test_map.sprites.blue) do
        if s[2] == mappos then
            hoverSoldier = spriteTypes[s[1]]
        end
    end
end

function game:update(dt)
    for _, group in pairs(test_map.sprites) do
        for _, s in ipairs(group) do
            anim_sys.update(s.animation, spriteTypes[s[1]], dt)
        end

    end

    check_selected_soldier()
end

function check_selected_soldier()
    if selectedSoldier then
        local selectedSoldierPos = selectedSoldier[2]
        tilesInRange = {}

        for i = 1, #test_map.data do
            local x1 = (selectedSoldierPos - 1) % test_map.width + 1
            local y1 = math.ceil(selectedSoldierPos / test_map.width)
            local x2 = (i - 1) % test_map.width + 1
            local y2 = math.ceil(i / test_map.width)
            local dist = math.abs(x1 - x2) + math.abs(y1 - y2)
            if dist <= 3 then
                -- if dist <= spriteTypes[selectedSoldier[1]].infos.move then
                table.insert(tilesInRange, i)
            end
        end
    end
end

function game:draw()
    map_sys:draw(test_map, mapX, mapY)
    draw_hightlighted_tiles()
    sprite_sys:drawMapSprites(test_map.sprites, spritebatch, test_map, spriteTypes)
    draw_tile_info_box()
    draw_unit_info_box()
end

function draw_hightlighted_tiles()
    if tilesInRange then
        love.graphics.setColor(0, 0, 0, 0.5)
        for i, t in ipairs(tilesInRange) do
            local pos = map_sys:mapToCanvas(test_map, (t % test_map.width), math.ceil(t / test_map.width))
            love.graphics.rectangle("fill", pos.x, pos.y, test_map.tileSize * test_map.zoom,
                test_map.tileSize * test_map.zoom)
        end
        love.graphics.setColor(1, 1, 1)
    end
end

function draw_tile_info_box()
    if hoverTile then
        draw_ui_rect(canvasConf.width - (ui_rect_w + 20), canvasConf.height - (ui_rect_h + 20), ui_rect_w, ui_rect_h)
        love.graphics.print(hoverTile.label, canvasConf.width - (ui_rect_w + 20), canvasConf.height - (ui_rect_h + 20))
        love.graphics.print("DEF " .. hoverTile.defense, canvasConf.width - (ui_rect_w + 20),
            canvasConf.height - (ui_rect_h + 20) + 16)
    end
end

function draw_unit_info_box()
    if hoverSoldier then
        draw_ui_rect(canvasConf.width - (ui_rect_w * 2 + 20), canvasConf.height - (ui_rect_h + 20), ui_rect_w, ui_rect_h)
        love.graphics.print(hoverSoldier.infos.label, canvasConf.width - (ui_rect_w * 2 + 20),
            canvasConf.height - (ui_rect_h + 20))
        love.graphics.print("HP " .. hoverSoldier.infos.hp, canvasConf.width - (ui_rect_w * 2 + 20),
            canvasConf.height - (ui_rect_h + 20) + 16)
        love.graphics.print("AMMO " .. hoverSoldier.infos.ammo, canvasConf.width - (ui_rect_w * 2 + 20),
            canvasConf.height - (ui_rect_h + 20) + 32)
        love.graphics.print("FUEL " .. hoverSoldier.infos.fuel, canvasConf.width - (ui_rect_w * 2 + 20),
            canvasConf.height - (ui_rect_h + 20) + 48)
    end
end

function draw_ui_rect(x, y, w, h)
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", x, y, w, h)
    love.graphics.setColor(1, 1, 1)
end

return game
