gl.setup(NATIVE_WIDTH, NATIVE_HEIGHT)

local font = resource.load_font("silkscreen.ttf")

local timer
local timerStr
local timerX
local timerSize = 300

local title
local titleX
local titleSize = 120

util.json_watch("config.json", function(config)
    timer = config.time * 60
    -- local timerWidth = font:write(tostring(time), timerSize)
    -- timerX = (NATIVE_WIDTH / 2) - (tointeger(timerWidth) / 2)
    timerStr = config.time

    -- Setup title
    title = config.title
    -- local titleWidth = font:write(title, titleSize)
    -- titleX = (NATIVE_WIDTH / 2) - (tointeger(titleWidth) / 2)
end)

util.set_interval(1, function()
    timer = timer - 1
    local minutes = string.format("%.0f", timer / 60)
    -- local seconds = timer - (minutes * 60)
    timer = minutes
    -- timerStr = tostring(minutes) .. ':' .. tostring(seconds)
    timerStr = timer
end)

function node.render()
    gl.clear(0, 0, 0, 1)
    font:write(400, 250, title, titleSize, 1, 1, 1, 1)
    font:write(400, 450, timerStr, timerSize, 1, 1, 1, 1)
end