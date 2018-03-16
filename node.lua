gl.setup(NATIVE_WIDTH, NATIVE_HEIGHT)

local font = resource.load_font("silkscreen.ttf")

local time
local time_str
local title
local title_size = 120
local timer_size = 200

util.json_watch("config.json", function(config)
    time = config.time * 60
    title = config.title
    -- time_str = config.time .. ":00"
end)

util.set_interval(1, function()
    time = time - 1
    -- time_str = 
end)

function node.render()
    gl.clear(0, 0, 0, 1)
    -- title_width = font:write(title, title_size)
    -- title_x = WIDTH / 2 - title_width / 2
    time_width = font:write(time, timer_size)
    -- time_x = WIDTH / 2 - time_width / 2
    -- font:write(400, 250, title, title_size, 1, 1, 1, 1)
    font:write(400, 450, time, timer_size, 1, 1, 1, 1)
end