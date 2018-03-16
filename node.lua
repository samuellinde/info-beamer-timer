gl.setup(NATIVE_WIDTH, NATIVE_HEIGHT)

local font = resource.load_font("silkscreen.ttf")

local time
local time_str
local title
local title_size = 120
local time_size = 200

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
    title_width = font:write(title, 120)
    title_x = NATIVE_WIDTH / 2 - title_width / 2
    time_width = font:write(time, 200)
    time_x = NATIVE_WIDTH / 2 - time_width / 2
    font:write(title_x, 250, title, 120, 1, 1, 1, 1)
    font:write(time_x, 450, time, 200, 1, 1, 1, 1)
end