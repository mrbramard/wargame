local spritesheet = love.graphics.newImage("assets/spritesheet.png")
local aw, ah = spritesheet:getWidth(), spritesheet:getHeight()
local spriteWidth, spriteHeight = 16, 16

local spriteQuads = {}
spriteQuads.red = {}
spriteQuads.blue = {}
spriteQuads.red.soldier = love.graphics.newQuad(0, 0, spriteWidth, spriteHeight, aw, ah)
spriteQuads.red.castle = love.graphics.newQuad(0, 16, spriteWidth, spriteHeight, aw, ah)
spriteQuads.blue.soldier = love.graphics.newQuad(16, 0, spriteWidth, spriteHeight, aw, ah)
spriteQuads.blue.castle = love.graphics.newQuad(16, 16, spriteWidth, spriteHeight, aw, ah)

local spriteBatch = love.graphics.newSpriteBatch(spritesheet)

-- Adds a sprite to the sprite batch
-- @param quad: The quad representing the sprite
-- @param x: The x position to draw the sprite
-- @param y: The y position to draw the sprite
-- @param scaleX: The horizontal scale factor (default is 1)
-- @param scaleY: The vertical scale factor (default is 1)
-- @return: None
function initializeSpriteBatch()
    spriteBatch:clear()
end

function addSpriteToSpriteBatch(quad, pos, scaleX, scaleY)
    spriteBatch:add(quad, pos.x, pos.y, 0, scaleX or 1, scaleY or 1)
end

function drawSpriteBatch()
    love.graphics.draw(spriteBatch)
end

return spriteQuads, initializeSpriteBatch, addSpriteToSpriteBatch, drawSpriteBatch
