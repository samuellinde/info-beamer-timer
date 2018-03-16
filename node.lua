gl.setup(NATIVE_WIDTH, NATIVE_HEIGHT)

local initTimer

local timer, timerStr
local timerX, timerSize

local title
local titleX, titleSize

local font = resource.load_font("silkscreen.ttf")
local endImage = resource.load_image("endofround.png")

util.json_watch("config.json", function(config)
    initTimer = config.timer * 60
    timer = config.timer * 60
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

util.data_mapper {
    reset = function()
        timer = initTimer
    end
}

util.set_interval(1, function()
    local minutes = math.floor(timer / 60)
    local seconds = timer - (minutes * 60)
    if timer == 0 then
        timerStr = "00:00"
    else
        timer = timer - 1
        timerStr = string.format("%02d:%02d", minutes, seconds)
    end
end)

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