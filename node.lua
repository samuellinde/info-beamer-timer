gl.setup(NATIVE_WIDTH, NATIVE_HEIGHT)

local font = resource.load_font("silkscreen.ttf")

local time
local time_str
util.json_watch("config.json", function(config)
    time = config.time * 60
    time_str = config.time .. ":00"
end)

util.set_interval(1, function()
    time = time - 1
end)

function node.render()
    gl.clear(0, 0, 0, 1)
    font:write(120, 320, time, 100, 1, 1, 1, 1)
end