local anim_sys = {}

anim_sys.update = function(anim, spriteType, dt)
    if not spriteType.animations or not anim then
        return
    end

    if anim.timer + dt > spriteType.animations[anim.state].duration then
        anim.timer = 0
        anim.current_frame = anim.current_frame + 1
    else
        anim.timer = anim.timer + dt
    end

    if anim.current_frame > #spriteType.animations[anim.state].frames then
        anim.current_frame = 1
    end

    return anim
end

return anim_sys
