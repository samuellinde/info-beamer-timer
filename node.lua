gl.setup(NATIVE_WIDTH, NATIVE_HEIGHT)

local font = resource.load_font("silkscreen.ttf")

util.json_watch("config.json", function(config)
    time = config.time
end)

util.set_interval(1, function()


node.render()
    util.set_interval(1, function()
        time = time - 1
        gl.clear(0, 0, 0, 1)
        font:write(120, 320, time, 100, 1, 1, 1, 1)
    end)
end)