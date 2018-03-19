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
-- local bouchsans = resource.load_font("bouchsans.ttf")
local bouchblkb = resource.load_font("bouchblkb.ttf")

-- Images
local bgImage -- = resource.load_image("redwedding.jpg")
local endImage = resource.load_image("endofround.png")

-- Textures/overlays
local stdTexture = resource.create_colored_texture(0, 0, 0, 0.8)
local yTexture = resource.create_colored_texture(1, 1, 0, 0.6)

-- Load and reload config.json
util.file_watch("config.json", function(content)
    config = json.decode(content)

    bgImage = resource.load_image(config.bgimage.asset_image)

    -- Set initTimer on first load
    local configTimer = config.timer * 60
    if (not timer) or (configTimer ~= initTimer) then
        initTimer = configTimer
        halfTime = configTimer / 2
        timer = configTimer
        timerStr = string.format("%02d:00", config.timer)
    end

    -- Setup timer
    if timer > 5999 then
        timerApprox = "000:00"
    else
        timerApprox = "00:00"
    end
    timerSize = config.timersize
    local timerWidth = font:width(timerApprox, timerSize)
    timerX, timerY = NATIVE_WIDTH / 2 - timerWidth / 2, 360

    -- Setup title
    title = config.title
    titleSize = config.titlesize
    local titleWidth = bouchblkb:width(title, titleSize)
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
    if timer < 6000 then
        local timerWidth = font:width("00:00", timerSize)
        timerX = NATIVE_WIDTH / 2 - timerWidth / 2
    end
    if timer == 0 then
        timerStr = "00:00"
    else
        timerStr = string.format("%02d:%02d", minutes, seconds)
    end
    if timerStatus == 'running' then
        timer = timer - 1
    end

end)

-- Render function, draws endImage if timer has run out
function node.render()
    gl.clear(0, 0, 0, 1)
    bgImage:draw(0, 0, NATIVE_WIDTH, NATIVE_HEIGHT)
    if timer < 0 then
        endImage:draw(0, 0, NATIVE_WIDTH, NATIVE_HEIGHT)
    -- Draw black on yellow around half time left
    -- elseif (timer > halfTime - 10) and (timer < halfTime + 10) then
    --     gl.clear(1, 1, 0, 1)
    --     font:write(titleX, titleY, title, titleSize, 0, 0, 0, 1)
    --     font:write(timerX, timerY, timerStr, timerSize, 0, 0, 0, 1)
    elseif timer < 180 then
        yTexture:draw(0, 0, NATIVE_WIDTH, NATIVE_HEIGHT)
        bouchblkb:write(titleX, titleY, title, titleSize, 0, 0, 0, 1)
        font:write(timerX, timerY, timerStr, timerSize, 0, 0, 0, 1)
    else
        stdTexture:draw(0, 0, NATIVE_WIDTH, NATIVE_HEIGHT)
        bouchblkb:write(titleX, titleY, title, titleSize, 1, 1, 1, 1)
        font:write(timerX, timerY, timerStr, timerSize, 1, 1, 1, 1)
    end
end