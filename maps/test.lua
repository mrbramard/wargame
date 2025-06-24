local tilesAtlasPos = {{0, 0}, {16, 0}, {32, 0}, {48, 0}}
local data = {4, 4, 4, 2, 2, 1, 1, 1, 1, 4, 4, 4, 4, 4, 4, 4, 4, 2, 2, 1, 1, 1, 1, 1, 1, 4, 4, 2, 4, 4, 4, 1, 1, 1, 1,
              1, 1, 1, 1, 1, 1, 1, 1, 2, 4, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 4, 1, 1, 1, 1, 1, 1, 1, 1, 1,
              1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 4, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 4, 4,
              4, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 4, 4, 4, 4, 4, 4, 1, 1, 1, 4, 1, 1, 1, 1, 4, 4, 4, 4, 4, 4, 4, 4, 1,
              4, 4, 4, 1, 4, 4, 4, 4, 4, 4}
local sprites = {{
    1,
    15 * 3 + 6,
    false,
    animation = {
        state = "idle",
        current_frame = math.random(4),
        timer = 0
    }
}, {
    1,
    15 * 5 + 4,
    false,
    animation = {
        state = "idle",
        current_frame = math.random(4),
        timer = 0
    }
}, {2, 15 * 5 + 14, true}, {2, 15 * 8 + 14, true}}

local map = require "engine.map"

return {
    map = map:createMap("assets/atlas.png", 16, tilesAtlasPos, data, 15, 3),
    sprites = sprites
}
