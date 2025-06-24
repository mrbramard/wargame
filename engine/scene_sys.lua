local scene_sys = {
    current = nil,
    scenes = {}
}

function scene_sys.register(name, scene)
    scene_sys.scenes[name] = scene
end

function scene_sys.switch(name, ...)
    assert(scene_sys.scenes[name], "Scene '" .. name .. "' not registered")
    scene_sys.current = scene_sys.scenes[name]
    if scene_sys.current.load then
        scene_sys.current.load(...)
    end
end

function scene_sys.update(...)
    if scene_sys.current and scene_sys.current.update then
        scene_sys.current.update(...)
    end
end

function scene_sys.draw(...)
    if scene_sys.current and scene_sys.current.draw then
        scene_sys.current.draw(...)
    end
end

function scene_sys.keypressed(...)
    if scene_sys.current and scene_sys.current.keypressed then
        scene_sys.current.keypressed(...)
    end
end

function scene_sys.mousepressed(...)
    if scene_sys.current and scene_sys.current.mousepressed then
        scene_sys.current.mousepressed(...)
    end
end

function scene_sys.mousemoved(...)
    if scene_sys.current and scene_sys.current.mousemoved then
        scene_sys.current.mousemoved(...)
    end
end

return scene_sys
