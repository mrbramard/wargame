local sprite = {}

local spritesheet = love.graphics.newImage("assets/spritesheet.png")
local spriteWidth, spriteHeight = 16, 16
local spriteBatch = love.graphics.newSpriteBatch(spritesheet)

function sprite:new(positions, animations)
    local newSprite = {
        quads = {},
        animations = nil
    }

    for i, pos in ipairs(positions) do
        newSprite.quads[i] = love.graphics.newQuad(pos[1], pos[2], spriteWidth, spriteHeight, spritesheet:getWidth(),
            spritesheet:getHeight())
    end

    if animations then
        newSprite.animations = {
            current_frame = 1,
            timer = 0
        }

        for i, anim in ipairs(animations) do
            newSprite.animations[anim.id] = {
                frames = anim.frames,
                duration = anim.duration or 1
            }
        end
    end

    print "sprite created"
    return newSprite
end

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
