gl.setup(NATIVE_WIDTH, NATIVE_HEIGHT)

local json = require "json"

local initTimer

local timerStatus = 'running'

-- Timer and title variables, set dynamically via config.json
local timer, timerStr
local timerX, timerSize

local title
local titleX, titleSize

local font = resource.load_font("silkscreen.ttf")

-- Shown when timer runs out
local endImage = resource.load_image("endofround.png")

-- Load and reload config.json
util.file_watch("config.json", function(content)
    config = json.decode(content)
    -- Set initTimer on first load
    if not timer then
        initTimer = config.timer * 60
        timer = config.timer * 60
    end
    timerSize = config.timersize
    local timerWidth = font:width("00:00", timerSize)
    timerX, timerY = NATIVE_WIDTH / 2 - timerWidth / 2, 360
    timerStr = string.format("%02d:00", config.timer)

    -- Setup title
    title = config.title
    titleSize = config.titlesize
    local titleWidth = font:width(title, titleSize)
    titleX, titleY = NATIVE_WIDTH / 2 - titleWidth / 2, timerY - titleSize - 60
end)

-- Listen for external triggers
util.data_mapper {
    reset = function()
        timer = initTimer
    end,
    start = function()
        timerStatus = 'running'
    end,
    stop = function()
        timerStatus = 'stopped'
    end
}

-- Timer
util.set_interval(1, function()
    local minutes = math.floor(timer / 60)
    local seconds = timer - (minutes * 60)
    if timer == 0 then
        timerStr = "00:00"
    else
        if timerStatus == 'running' then
            timer = timer - 1
        end
        timerStr = string.format("%02d:%02d", minutes, seconds)
    end
end)

-- Render function, draws endImage if timer has run out
function node.render()
    if timer == 0 then
        gl.clear(0, 0, 0, 1)
        endImage:draw(0, 0, NATIVE_WIDTH, NATIVE_HEIGHT)
    else
        gl.clear(0, 0, 0, 1)
        font:write(titleX, titleY, title, titleSize, 1, 1, 1, 1)
        font:write(timerX, timerY, timerStr, timerSize, 1, 1, 1, 1)
    end
end