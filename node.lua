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
    timer = initTimer
    timerSize = config.timersize
    local timerWidth = font:width(tostring(timer), timerSize)
    -- timerX = (NATIVE_WIDTH / 2) - (tointeger(timerWidth) / 2)
    timerStr = string.format("%02d:00", config.timer)

    -- Setup title
    title = config.title
    titleSize = config.titlesize
    local titleWidth = font:width(title, titleSize)
    -- titleX = (NATIVE_WIDTH / 2) - (tointeger(titleWidth) / 2)
end)

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
        font:write(360, 200, title, titleSize, 1, 1, 1, 1)
        font:write(320, 400, timerStr, timerSize, 1, 1, 1, 1)
    end
end