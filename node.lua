gl.setup(NATIVE_WIDTH, NATIVE_HEIGHT)

local font = resource.load_font("silkscreen.ttf")

local timer
local timerStr
local timerX
timerSize = 300

local title
local titleX
titleSize = 120

util.json_watch("config.json", function(config)
    timer = config.time * 60
    local timerWidth = font:write(tostring(time), timerSize)
    timerX = (WIDTH / 2) - (timerWidth / 2)
    -- timerStr = config.time .. ":00"

    -- Setup title
    title = config.title
    local titleWidth = font:write(title, titleSize)
    titleX = (WIDTH / 2) - (titleWidth / 2)
end)

util.set_interval(1, function()
    timer = timer - 1
end)

function node.render()
    gl.clear(0, 0, 0, 1)
    font:write(titleX, 250, title, titleSize, 1, 1, 1, 1)
    font:write(timerX, 450, tostring(time), timerSize, 1, 1, 1, 1)
end