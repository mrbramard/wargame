local tilesAtlasPos = {{0, 0}, {16, 0}, {32, 0}, {48, 0}}
local data = {4, 4, 4, 2, 2, 1, 1, 1, 1, 4, 4, 4, 4, 4, 4, 4, 4, 2, 2, 1, 1, 1, 1, 1, 1, 4, 4, 2, 4, 4, 4, 1, 1, 1, 1,
              1, 1, 1, 1, 1, 1, 1, 1, 2, 4, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 4, 1, 1, 1, 1, 1, 1, 1, 1, 1,
              1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 4, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 4, 4,
              4, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 4, 4, 4, 4, 4, 4, 1, 1, 1, 4, 1, 1, 1, 1, 4, 4, 4, 4, 4, 4, 4, 4, 1,
              4, 4, 4, 1, 4, 4, 4, 4, 4, 4}

local tileInfos = {
    {label = "Plain", defense = 1},
    {label = "Forest", defense = 2},
    {label = "Sea", defense = 1},
    {label = "Mountain", defense = 3}
}

local sprites = {}
sprites.red = {
    {
        1, 15 * 3 + 6, false,
        animation = {
            state = "idle",
            current_frame = math.random(4),
            timer = 0
        }
    },
    {
        1, 15 * 5 + 4, false,
        animation = {
            state = "idle",
            current_frame = math.random(4),
            timer = 0
        }
    }
}
sprites.blue = {{2, 15 * 5 + 14, true}, {2, 15 * 8 + 14, true}}

local mapsys = require "engine.mapsys"
local map = mapsys:createMap("assets/atlas.png", 16, tilesAtlasPos, data, tileInfos, 15, 3)
map.sprites = sprites

return map
