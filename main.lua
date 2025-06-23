current_scene = require("scene.title")

globals = {
    game_title = "wargame"
}

canvasConf = {
    height = 480,
    width = 480 * 16 / 9,
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
    local w, h = love.graphics.getDimensions()
    resizeCanvas(w, h)
end

function love.keypressed(key, isrepeat)
    if key == "f12" then
        love.window.setFullscreen(not love.window.getFullscreen())
    end

    current_scene:keypressed(key, isrepeat)
end

function love.update(dt)
    current_scene:update(dt)
end

function love.draw()
    love.graphics.setCanvas(canvas)
    love.graphics.clear()
    love.graphics.push()
    current_scene:draw()
    love.graphics.pop()
    love.graphics.setCanvas()

    love.graphics.draw(canvas, canvasConf.offset_x, canvasConf.offset_y, 0, canvasConf.scale, canvasConf.scale)
end

function love.resize(w, h)
    resizeCanvas(w, h)
end

function resizeCanvas(w, h)
    canvasConf.scale = math.min(w / canvasConf.width, h / canvasConf.height)
    local draw_w, draw_h = canvasConf.width * canvasConf.scale, canvasConf.height * canvasConf.scale
    canvasConf.offset_x = (w - draw_w) / 2
    canvasConf.offset_y = (h - draw_h) / 2
end
