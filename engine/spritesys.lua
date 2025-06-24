local spritesys = {}

function spritesys:new(spritesheet, positions, animations, infos)
    local newSprite = {
        quads = {},
        animations = nil,
        infos = infos or {}
    }

    for i, pos in ipairs(positions) do
        newSprite.quads[i] = love.graphics.newQuad(pos[1], pos[2], 16, 16, spritesheet:getWidth(),
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

    return newSprite
end

function spritesys:initializeSpriteBatch(spritebatch)
    spritebatch:clear()
end

-- Adds a sprite to the sprite batch
-- @param quad: The quad representing the sprite
-- @param x: The x position to draw the sprite
-- @param y: The y position to draw the sprite
-- @param scaleX: The horizontal scale factor (default is 1)
-- @param scaleY: The vertical scale factor (default is 1)
-- @return: None
function spritesys:addSpriteToSpriteBatch(spritebatch, quad, x, y, scaleX, scaleY, flip)
    spritebatch:add(quad, x, y, 0, flip and -scaleX or scaleX or 1, scaleY or 1, 0, 3)
end

function spritesys:drawSpriteBatch(spritebatch)
    love.graphics.draw(spritebatch)
end

return spritesys
