-- Run yabai command via hs.task
-- See https://github.com/Hammerspoon/hammerspoon/issues/2570

local run_task = require('utils').run_task
local Yabai = {}

Yabai.exec = function(args)
  return run_task('/usr/local/bin/yabai', args)
end

Yabai.init = function() end

Yabai.DirectionNameMap = {
  ['h'] = 'west',
  ['j'] = 'south',
  ['k'] = 'north',
  ['l'] = 'east',
}

Yabai.focus = function(dir)
  return function() Yabai.exec({ '-m', 'window', '--focus', Yabai.DirectionNameMap[dir] }) end
end

Yabai.move = function(dir)
  return function() Yabai.exec({ '-m', 'window', '--swap', Yabai.DirectionNameMap[dir] }) end
end

Yabai.stack = function(dir)
  return function() Yabai.exec({ '-m', 'window', '--stack', Yabai.DirectionNameMap[dir] }) end
end

Yabai.unstack = function()
  return function ()
    local float = Yabai.toggle('float')
    float()
    float()
  end
end

Yabai.toggle = function(action)
  return function() Yabai.exec({ '-m', 'window', '--toggle', action }) end
end

return Yabai
