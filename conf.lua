function love.conf(t)
    t.window.title = "my game"
    t.window.height = 720
    t.window.width = t.window.height * 16 / 9
    t.window.resizable = true
    t.window.fullscreen = true

    t.version = "11.5"
    t.console = false
end
