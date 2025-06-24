local sprite_sys = {}

local map_sys = require "engine.map_sys"

function sprite_sys:new(spritesheet, positions, animations, infos)
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

function sprite_sys:initializeSpriteBatch(spritebatch)
    spritebatch:clear()
end

-- Adds a sprite to the sprite batch
-- @param quad: The quad representing the sprite
-- @param x: The x position to draw the sprite
-- @param y: The y position to draw the sprite
-- @param scaleX: The horizontal scale factor (default is 1)
-- @param scaleY: The vertical scale factor (default is 1)
-- @return: None
function sprite_sys:addSpriteToSpriteBatch(spritebatch, quad, x, y, scaleX, scaleY, flip)
    spritebatch:add(quad, x, y, 0, flip and -scaleX or scaleX or 1, scaleY or 1, 0, 3)
end

function sprite_sys:drawSpriteBatch(spritebatch)
    love.graphics.draw(spritebatch)
end

function sprite_sys:drawMapSprites(sprites, spritebatch, map, spriteTypes)
    self:initializeSpriteBatch(spritebatch)
    for _, group in pairs(sprites) do
        self:drawSprites(group, spritebatch, map, spriteTypes)
    end
    self:drawSpriteBatch(spritebatch)

end

function sprite_sys:drawSprites(sprites, spritebatch, map, spriteTypes)
    for _, s in ipairs(sprites) do
        local spriteType = spriteTypes[s[1]]
        local pos = map_sys:mapToCanvas(map, s[2] % map.width, math.ceil(s[2] / map.width))

        local quadToDisplay = spriteType.quads[1]
        if spriteType.animations and s.animation then
            quadToDisplay = spriteType.quads[spriteType.animations[s.animation.state].frames[s.animation.current_frame]]
        end
        sprite_sys:addSpriteToSpriteBatch(spritebatch, quadToDisplay, pos.x, pos.y, map.zoom, map.zoom, s[3])
    end
end

return sprite_sys
