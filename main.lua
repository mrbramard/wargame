current_scene = require "scene.title"

globals = {
    game_title = "wargame"
}

canvasConf = {
    height = 10 * 16 * 3,
    width = 15 * 16 * 3,
    scale = 1,
    offset_x = 0,
    offset_y = 0
}

function love.load()
    love.graphics.setDefaultFilter("nearest")
    canvas = love.graphics.newCanvas(canvasConf.width, canvasConf.height)
    font = love.graphics.newImageFont("assets/imagefont.png", " abcdefghijklmnopqrstuvwxyz" ..
        "ABCDEFGHIJKLMNOPQRSTUVWXYZ0" .. "123456789.,!?-+/():;%&`'*#=[]\"")
    love.graphics.setFont(font)
    resizeCanvas()
    -- love.mouse.setGrabbed(true)
end

function love.keypressed(key, isrepeat)
    if key == "f12" then
        love.window.setFullscreen(not love.window.getFullscreen())
    end

    current_scene:keypressed(key, isrepeat)
end

function love.mousepressed(x, y, button, istouch)
    current_scene:mousepressed(x, y, button, istouch)
end

function love.update(dt)
    current_scene:update(dt)
end

function love.draw()
    love.graphics.setCanvas(canvas)
    love.graphics.clear()
    love.graphics.push()
    current_scene:draw()
    love.graphics.print('FPS : ' .. love.timer.getFPS(), 0, 0)
    love.graphics.print('Mouse : ' .. love.mouse.getX() .. ' ' .. love.mouse.getY(), 0, 16)
    love.graphics.pop()
    love.graphics.setCanvas()

    love.graphics.draw(canvas, canvasConf.offset_x, canvasConf.offset_y, 0, canvasConf.scale, canvasConf.scale)
end

function love.resize(w, h)
    resizeCanvas(w, h)
end

function resizeCanvas()
    local windowWidth, windowHeight = love.graphics.getDimensions()
    canvasConf.scale = math.min(windowWidth / canvasConf.width, windowHeight / canvasConf.height)
    canvasConf.offset_x = (windowWidth - canvasConf.width * canvasConf.scale) / 2
    canvasConf.offset_y = (windowHeight - canvasConf.height * canvasConf.scale) / 2
end

function screenToCanvas(x, y)
    local screenWidth, screenHeight = love.graphics.getDimensions()
    local canvasx = (x - canvasConf.offset_x) / ((screenWidth - canvasConf.offset_x * 2) / canvasConf.width)
    local canvasy = (y - canvasConf.offset_y) / ((screenHeight - canvasConf.offset_y * 2) / canvasConf.height)
    return canvasx >= 0 and canvasx <= canvasConf.width and canvasx or -1,
        canvasy >= 0 and canvasy <= canvasConf.height and canvasy or -1
end
