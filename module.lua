local localized, CHILDS, CONTENTS = ...

local M = {}

local json = require "json"

-- Timer and title variables, set dynamically via config.json
local timer_status = 'stopped'
local init_timer
local rendered_timer
local timer_x
local timer_size -- = 400

local title
local title_x, title_size

local font = resource.load_font(localized "robotob.ttf")
local bouchblkb = resource.load_font(localized "bouchblkb.ttf")

-- Images
local bg_image_name = "no image"
local bg_image = resource.load_image(localized "redwedding.jpg")
local end_image = resource.load_image(localized "endofround.png")

-- Textures/overlays
local std_texture = resource.create_colored_texture(0, 0, 0, 0.8)
local yellow = resource.create_colored_texture(1, 1, 0, 0.6)

print "sub module init"

local function setup_timer(t, s)
  -- Set init_timer on first load
  local t = t or 50
  local s = s or 400
  local cfg_timer = t * 60
  if cfg_timer ~= init_timer then
    init_timer = cfg_timer
    timer = cfg_timer
    rendered_timer = string.format("%02d:00", t)
  end

  -- Setup timer
  if timer > 5999 then
    timer_approx = "000:00"
  else
    timer_approx = "00:00"
  end
  timer_size = s
  local timer_width = font:width(timer_approx, timer_size)
  timer_x, timer_y = NATIVE_WIDTH / 2 - timer_width / 2, 400
end

function M.unload()
  print "sub module is unloaded"
end

-- Load and reload config.json
function M.content_update(name)
  print("sub module content update", name)
  if name == 'config.json' then
    json_file = resource.load_file(localized(name))
    config = json.decode(json_file)

    -- Load background image, replace if new
    if config.bg_image.asset_name ~= bg_image_name then
      bg_image_name = config.bg_image.asset_name
      bg_image = resource.load_image(localized(bg_image_name))
    end

    -- Set init_timer on first load
    local cfg_timer = config.timer * 60
    if cfg_timer ~= init_timer then
      init_timer = cfg_timer
      timer = cfg_timer
      rendered_timer = string.format("%02d:00", config.timer)
    end

    -- Setup timer
    if timer > 5999 then
      timer_approx = "000:00"
    else
      timer_approx = "00:00"
    end
    timer_size = config.timersize
    local timer_width = font:width(timer_approx, timer_size)
    timer_x, timer_y = NATIVE_WIDTH / 2 - timer_width / 2, 400

    -- Setup title
    title = config.title
    title_size = config.title_size
    local title_width = bouchblkb:width(title, title_size)
    title_x, titleY = NATIVE_WIDTH / 2 - title_width / 2, timer_y - title_size - 60
  end
end

function M.content_remove(name)
  print("sub module content delete", name)
end

util.data_mapper {
  reset = function()
    setup_timer(init_timer)
  end,
  start = function()
    timer_status = 'running'
  end,
  stop = function()
    timer_status = 'stopped'
  end
}

-- Timer
util.set_interval(1, function()
  local minutes = math.floor(timer / 60)
  local seconds = timer - (minutes * 60)
  if timer < 6000 then
    local timer_width = font:width("00:00", timer_size)
    timer_x = NATIVE_WIDTH / 2 - timer_width / 2
  end
  if timer == 0 then
    rendered_timer = "00:00"
  else
    rendered_timer = string.format("%02d:%02d", minutes, seconds)
  end
  if timer_status == 'running' then
    timer = timer - 1
  end
end)

-- Render function, draws end_image if timer has run out
function M.draw()
  -- font:write(100, 100, timer, timer_size, 1,1,1,1)
  bg_image:draw(0, 0, NATIVE_WIDTH, NATIVE_HEIGHT)
  if timer < 0 then
    end_image:draw(0, 0, NATIVE_WIDTH, NATIVE_HEIGHT)
  elseif timer < 180 then
    yellow:draw(0, 0, NATIVE_WIDTH, NATIVE_HEIGHT)
    bouchblkb:write(title_x, titleY, title, title_size, 0, 0, 0, 1)
    font:write(timer_x, timer_y, rendered_timer, timer_size, 0, 0, 0, 1)
  else
    std_texture:draw(0, 0, NATIVE_WIDTH, NATIVE_HEIGHT)
    bouchblkb:write(title_x, titleY, title, title_size, 1, 1, 1, 1)
    font:write(timer_x, timer_y, rendered_timer, timer_size, 1, 1, 1, 1)
  end
end

return M