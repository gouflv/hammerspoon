local grid = hs.grid

-- Settings
grid.setMargins({ w = 10, h = 10 })
grid.setGrid('6x4')

local M = {}

local setWindowCell = function(cell)
  return function(win, scr)
    win = win or hs.window.focusedWindow()
    grid.set(win, cell, scr)
  end
end

local center = function(win, scr)
  win = win or hs.window.focusedWindow()
  win:centerOnScreen(scr, true, 0.2)
end

local stack = function(option)
  return function(win, scr)
    local width = option.width
    local height = option.height
    local off_x = option.offset_x
    local off_y = option.offset_y

    win = win or hs.window.focusedWindow()
    local app = win:application()
    local win_all = hs.fnutils.filter(
      app:allWindows(),
      function(it) return string.len(it:title()) > 0 end
    )
    print('win_all', win_all)

    local win_first = win_all[1]
    if not win_first then return end

    local scr = win_first:screen()
    print(scr)

    local scr_rect = scr:frame()
    local count = #win_all
    local all_width = width + off_x * (count - 1)
    local all_height = height + off_y * (count - 1)
    local from_x = (scr_rect.w - all_width) / 2
    local from_y = (scr_rect.h - all_height) / 2

    local i = 0
    hs.fnutils.each(win_all, function(it)
      local rect = {}
      rect.x = from_x + off_x * i
      rect.y = from_y + off_y * i
      rect.w = width
      rect.h = height

      it:focus()
      it:move(rect, scr)
      i = i + 1
    end)
  end
end

M.t_half = setWindowCell('0,0 6x2')
M.b_half = setWindowCell('0,2 6x2')
M.l_half = setWindowCell('0,0 3x4')
M.r_half = setWindowCell('3,0 3x4')

M.lt_quarter = setWindowCell('0,0 3x2')
M.lb_quarter = setWindowCell('0,2 3x2')
M.rt_quarter = setWindowCell('3,0 3x2')
M.rb_quarter = setWindowCell('3,2 3x2')

M.rb_thrid = setWindowCell('3,1 3,4')

M.main_center = setWindowCell('1,0 5,4')
M.full = setWindowCell('0,0 6x4')

M.center = center
M.stack = stack

return M
