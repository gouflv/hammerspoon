local log = hs.logger.new('im-auto', 'info')

local M = {}

-- Input Sources
M.S = {
  ['abc'] = 'com.apple.keylayout.ABC',
  ['pinyin'] = 'com.apple.inputmethod.SCIM.ITABC'
}

M.CMD = '/usr/local/bin/im-select'

-- Default opptions
M.D = {}

M.D.default_source_name = M.S.abc

M.D.restore_default_source_on_leave = true

M.set = function(source)
  local curr_source = hs.keycodes.currentSourceID()
  log.i('current', curr_source)
  if curr_source == source then return end

  log.i('set', source)
  hs.execute(string.format('%s %s', M.CMD, source))
end

local app = {
  ['WeChat'] = M.S.pinyin
}

local function onApplicationChange(name)
  local target_source = app[name]

  if target_source then
    M.set(target_source)
    return
  end

  if M.D.restore_default_source_on_leave then
    M.set(M.D.default_source_name)
  end
end

hs.application.watcher.new(function(name, type)
  if (type == hs.application.watcher.activated) then
    onApplicationChange(name)
  end
end):start()
