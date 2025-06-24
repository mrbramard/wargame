local map = {}

-- @param atlasPath: path to the atlas image
-- @param tileSize: size of each tile in pixels
-- @param tilesAtlasPos: positions of each tile in the atlas image
-- @param data: array of tile indices for the map
-- @param width: width of the map in tiles
-- @param zoom: zoom factor for the map
-- @return: a map object with the atlas image, tile size, tiles, data, map width, zoom factor, and a sprite batch for rendering
function map:createMap(atlasPath, tileSize, tilesAtlasPos, data, tileInfos, width, zoom)
    if not atlasPath or not tileSize or not tilesAtlasPos or not data or not width or not zoom then
        return error("Invalid parameters for createMap")
    end

    local atlasImage = love.graphics.newImage(atlasPath)
    local tiles = {}
    for i, pos in ipairs(tilesAtlasPos) do
        tiles[i] = love.graphics.newQuad(pos[1], pos[2], tileSize, tileSize, atlasImage:getWidth(),
            atlasImage:getHeight())
    end
    local spriteBatch = love.graphics.newSpriteBatch(atlasImage)

    return {
        atlas = atlasImage,
        tileSize = tileSize,
        tiles = tiles,
        data = data or {},
        tileInfos = tileInfos or {},
        sprites = sprites or {},
        width = width,
        zoom = zoom,
        spriteBatch = spriteBatch,
        ox = 0,
        oy = 0
    }
end

-- @param ix: x offset in tiles
-- @param iy: y offset in tiles
function map:draw(map, ix, iy)
    if not map then
        error "no map passed"
    end
    map.ox, map.oy = ix or 0, iy or 0
    for i, cell in ipairs(map.data) do
        local x = ((i - 1) % map.width) * map.tileSize * map.zoom + map.ox
        local y = math.floor((i - 1) / map.width) * map.tileSize * map.zoom + map.oy
        map.spriteBatch:add(map.tiles[cell], x, y, 0, map.zoom, map.zoom)
    end

    love.graphics.draw(map.spriteBatch)

    map.spriteBatch:clear()
end

function map:getDimensions(map)
    return map.width * map.tileSize * map.zoom, #map.data / map.width * map.tileSize * map.zoom
end

function map:mapToCanvas(map, x, y)
    local canvasX = (x - 1) * map.tileSize * map.zoom + map.ox
    local canvasY = (y - 1) * map.tileSize * map.zoom + map.oy
    return {
        x = canvasX,
        y = canvasY
    }
end

function map:canvasToMap(map, x, y)
    local mx = math.ceil(x * map.width / canvasConf.width)
    local my = math.ceil(y * (#map.data / map.width) / canvasConf.height)
    return (my - 1) * map.width + mx
end

return map
