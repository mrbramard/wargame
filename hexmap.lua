local Hexmap = {}

local map = {}

local columns = 32
local lines = 32
local cellWidth = 64
local cellImages = {}
local spriteBatch = nil

function Hexmap:load()
    math.randomseed(os.time())
    for i = 1, lines * columns do
        map[i] = math.random(1, 4)
    end

    tile_atlas = love.graphics.newImage("assets/tileset.png")
    forest_quad = love.graphics.newQuad(0, 0, 64, 64, tile_atlas)
    plain_quad = love.graphics.newQuad(64, 0, 64, 64, tile_atlas)
    sea_quad = love.graphics.newQuad(128, 0, 64, 64, tile_atlas)
    mountain_quad = love.graphics.newQuad(192, 0, 64, 64, tile_atlas)

    -- Load the image for the hex cells
    cellImages = {mountain_quad, forest_quad, plain_quad, sea_quad}

    spriteBatch = love.graphics.newSpriteBatch(tile_atlas)
end

function Hexmap:update(dt)
    -- Update logic for the hexmap can be added here if needed
    if love.mouse.isDown(1) then
        cx, cy = love.graphics.inverseTransformPoint(love.mouse.getPosition())
    else
        cx, cy = nil, nil
    end
end

function Hexmap:draw()
    for i, cell in ipairs(map) do
        local x = ((i - 1) % columns) * cellWidth
        local y = math.floor((i - 1) / columns) * cellWidth
        if cx and cy and cx >= x and cx < x + cellWidth and cy >= y and cy < y + cellWidth then
            spriteBatch:setColor(1, 0, 0, 0.5) -- Red highlight
        end
        spriteBatch:add(cellImages[cell], x, y)
        spriteBatch:setColor(1, 1, 1, 1) -- Reset to white
    end
    love.graphics.draw(spriteBatch)
end

function Hexmap:getWidth()
    return columns * cellWidth
end

function Hexmap:getHeight()
    return math.ceil(#map / columns) * cellWidth
end

return Hexmap
