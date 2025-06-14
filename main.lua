local x = 0
local y = 0
local scrollSpeed = 300

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")

    map = require "hexmap"
    map.load()
end

function love.update(dt)
    if love.keyboard.isDown("escape") then
        love.event.quit()
    end

    if love.keyboard.isDown("right") then --and x > 0 then
        x = x - scrollSpeed * dt
    elseif love.keyboard.isDown("left") then -- and x < love.graphics.getWidth() - map:getWidth() then
        x = x + scrollSpeed * dt
    end

    if love.keyboard.isDown("up") then --and y < love.graphics.getHeight() - map:getHeight() then
        y = y + scrollSpeed * dt
    elseif love.keyboard.isDown("down") then --and y > 0 then
        y = y - scrollSpeed * dt
    end

    map.update(dt)
end

function love.draw()
    love.graphics.translate(x, y)
    map.draw()
end
