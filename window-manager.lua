local hotkey = hs.hotkey
local L = require('layout')
local S = require('space-utils')

local primaryKey = { 'option' }

--[[
Focus window to the direction

Keybind of directions:
          k
        h   l
          j
--]]
local focus_mode_timeout = 5
local focus_mode = hotkey.modal.new(primaryKey, 'd')

function focus_mode:entered()
  hs.alert.show('Focus Mode', { textSize = 16, radius = 6 }, focus_mode_timeout)
  hs.timer.doAfter(focus_mode_timeout, function() focus_mode:exit() end)
end

function focus_mode:exited() hs.alert.closeAll() end

local focus_window_filter = hs.window.filter.new()

local focus_window = function(dir)
  return function()
    local wf = focus_window_filter
    if (dir == 'h') then wf:focusWindowWest(nil, false, true) end
    if (dir == 'j') then wf:focusWindowSouth(nil, false, true) end
    if (dir == 'k') then wf:focusWindowNorth(nil, false, true) end
    if (dir == 'l') then wf:focusWindowEast(nil, false, true) end
    focus_mode:exit()
  end
end

focus_mode:bind('', 'h', focus_window('h'))
focus_mode:bind('', 'j', focus_window('j'))
focus_mode:bind('', 'k', focus_window('k'))
focus_mode:bind('', 'l', focus_window('l'))

--[[
Manual layouts

Keybind of directions:
          k        y  u
        h   l
          j        n  m
--]]
hotkey.bind(primaryKey, 'k', function() L.t_half() end)
hotkey.bind(primaryKey, 'j', function() L.b_half() end)
hotkey.bind(primaryKey, 'h', function() L.l_half() end)
hotkey.bind(primaryKey, 'l', function() L.r_half() end)

hotkey.bind(primaryKey, 'y', function() L.lt_quarter() end)
hotkey.bind(primaryKey, 'n', function() L.lb_quarter() end)
hotkey.bind(primaryKey, 'u', function() L.rt_quarter() end)
hotkey.bind(primaryKey, 'm', function() L.rb_quarter() end)

hotkey.bind(primaryKey, 'f', function() L.full() end)
hotkey.bind(primaryKey, 'c', function() L.center() end)

--[[
Auto layout for app window

options:
  [ pos ]
    fn - Default layout position function, running by `auto_layout`

  [ size ]
    {w, h} - Default window size, use on running `center`

  [ space_of_screen ]
    { BuiltIn = num, External = num } - Move window to the space of screen, running on `auto_move`

--]]
local DevSpace = { BuiltIn = 2, External = 1 }
local app_layouts = {
  ['Finder'] = { pos = L.stack({ w = 920, h = 620, offset_x = 50, offset_y = 50 }) },
  ['Safari'] = { pos = L.main_center, },
  ['Mail'] = { size = { w = 1100, h = 700 }, },
  ['Notes'] = { size = { w = 1100, h = 800 }, },
  ['Reminders'] = { size = { w = 680, h = 760 }, },
  ['Calendar'] = { size = { w = 1100, h = 800 }, },
  ['Logseq'] = { size = { w = 1000, h = 850 }, },
  ['WeChat'] = { pos = L.rb_3x3 },
  ['QQ'] = { pos = L.rb_3x3 },
  ['Google Chrome'] = { pos = L.lb_quarter, space_of_screen = DevSpace, },
  ['Firefox'] = { pos = L.l_half, space_of_screen = DevSpace, },
  ['Code'] = { pos = L.r_half, space_of_screen = DevSpace, },
  ['iTerm2'] = { pos = L.r_half, space_of_screen = DevSpace, },
  ['WebStorm'] = { pos = L.r_half, space_of_screen = DevSpace, },
  ['Dash'] = { pos = L.rb_quarter, space_of_screen = DevSpace, },
}

-- Auto layout
local auto_layout = function(win)
  win = win or hs.window.focusedWindow()
  local app_name = win:application():title()
  print('auto layout window', app_name)

  local app_config = app_layouts[app_name]
  if app_config and app_config.pos then
    app_config.pos(win)
  else
    print('app layout no defined', app_name)
    L.center(nil, nil, app_config and app_config.size)
  end
end

-- Moving between screen
local move_to_next_screen = function(win)
  win = win or hs.window.focusedWindow()
  local target_scr = hs.screen.mainScreen():next()
  win:moveToScreen(target_scr)
end

local auto_move = function(win)
  win = win or hs.window.focusedWindow()
  local app_name = win:application():title()
  local app_config = app_layouts[app_name]
  if app_config and app_config.space_of_screen then
    S.move(win, app_config.space_of_screen)
  end
end

local auto_move_all = function()
  -- TODO find window cross spaces 
  hs.window.desktop():focus()
  hs.fnutils.each(hs.window.allWindows(), auto_move)
  hs.timer.doAfter(0.5, function()
    hs.fnutils.each(hs.window.allWindows(), auto_layout)
  end)
end

hotkey.bind(primaryKey, '1', auto_layout)
hotkey.bind(primaryKey, ';', auto_layout)
hotkey.bind(primaryKey, 's', move_to_next_screen)

hotkey.bind(primaryKey, 'v', auto_move_all)

-- Layout GUI
hotkey.bind(primaryKey, 'g', function() hs.grid.show() end)
