local sprite = {}

local spritesheet = love.graphics.newImage("assets/spritesheet.png")
local aw, ah = spritesheet:getWidth(), spritesheet:getHeight()
local spriteWidth, spriteHeight = 16, 16
local spriteBatch = love.graphics.newSpriteBatch(spritesheet)

sprite.sprites = {{
    quads = {love.graphics.newQuad(0, 0, spriteWidth, spriteHeight, aw, ah),
             love.graphics.newQuad(16, 0, spriteWidth, spriteHeight, aw, ah),
             love.graphics.newQuad(32, 0, spriteWidth, spriteHeight, aw, ah)},
    animations = {
        current_frame = 1,
        timer = 0,
        idle = {
            frames = {1, 2, 3, 2},
            duration = 0.2
        }
    }
}, {
    quads = {love.graphics.newQuad(0, 16, spriteWidth, spriteHeight, aw, ah)}
}}

-- Adds a sprite to the sprite batch
-- @param quad: The quad representing the sprite
-- @param x: The x position to draw the sprite
-- @param y: The y position to draw the sprite
-- @param scaleX: The horizontal scale factor (default is 1)
-- @param scaleY: The vertical scale factor (default is 1)
-- @return: None
function sprite:initializeSpriteBatch()
    spriteBatch:clear()
end

function sprite:addSpriteToSpriteBatch(quad, x, y, scaleX, scaleY, flip)
    spriteBatch:add(quad, x, y, 0, flip and -scaleX or scaleX or 1, scaleY or 1, 0, 3)
end

function sprite:drawSpriteBatch()
    love.graphics.draw(spriteBatch)
end

return sprite
