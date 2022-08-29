local hs = hs
local hotkey = hs.hotkey
local log = hs.logger.new('layout', 'info')

local Yabai = require('yabai')
local run_shell_script = require('utils').run_shell_script
local run_task = require('utils').run_task

--
local layoutPrimaryKey = { 'option' }
Yabai.init()

hotkey.bind(layoutPrimaryKey, 'h', Yabai.focus 'h')
hotkey.bind(layoutPrimaryKey, 'j', Yabai.focus 'j')
hotkey.bind(layoutPrimaryKey, 'k', Yabai.focus 'k')
hotkey.bind(layoutPrimaryKey, 'l', Yabai.focus 'l')

local styledAlert = function(msg)
  hs.alert.closeAll()
  hs.alert(msg, { textSize = 16, radius = 8 })
end

local message = require('status-message').new('Layout Mode')

local layoutMode = hotkey.modal.new(layoutPrimaryKey, 'space')
function layoutMode:entered() styledAlert('Layout Mode') end
function layoutMode:exited() styledAlert('Layout Mode Exit') end
-- function layoutMode:entered() message:show() end
-- function layoutMode:exited() message:hide() end

layoutMode:bind('', 'escape', function() layoutMode:exit() end)
layoutMode:bind({ 'option' }, 'space', function() layoutMode:exit() end)

-- Focus windowy
layoutMode:bind('shift', 'h', Yabai.focus 'h')
layoutMode:bind('shift', 'j', Yabai.focus 'j')
layoutMode:bind('shift', 'k', Yabai.focus 'k')
layoutMode:bind('shift', 'l', Yabai.focus 'l')

-- Move window
layoutMode:bind('', 'h', Yabai.move 'h')
layoutMode:bind('', 'j', Yabai.move 'j')
layoutMode:bind('', 'k', Yabai.move 'k')
layoutMode:bind('', 'l', Yabai.move 'l')

-- Stack window
-- layoutMode:bind({ 'option', 'space' }, 'h', Yabai.stack 'h')
-- layoutMode:bind({ 'option', 'space' }, 'j', Yabai.stack 'j')
-- layoutMode:bind({ 'option', 'space' }, 'k', Yabai.stack 'k')
-- layoutMode:bind({ 'option', 'space' }, 'l', Yabai.stack 'l')
layoutMode:bind('', 's', function()
  run_task('~/.hammerspoon/scripts/yabai-stack.sh')
end)

layoutMode:bind('', 'r', function()
  run_task('~/.hammerspoon/scripts/yabai-swap-clockwise.sh')
end)

-- Split diration
layoutMode:bind('', 'v', Yabai.toggle 'split')

-- Toggle float or bsp
layoutMode:bind('', 'f', Yabai.toggle 'float')
