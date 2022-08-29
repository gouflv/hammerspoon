-- Settings
hs.window.animationDuration = 0

-- Reload
hs.hotkey.bind({ 'option' }, 'escape', function()
  hs.reload()
end)


require('window-manager')
require('im-auto')
