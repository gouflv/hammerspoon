local str_split = require('utils')
local log = hs.logger.new('space', 'info')

local M = {}

M.get_screens = function()
  return hs.screen.allScreens()
end

M.get_spaces = function(scr)
  return hs.spaces.allSpaces()[scr:getUUID()]
end

M.get_primary_screen = function()
  return hs.screen.primaryScreen()
end

M.get_external_screen = function()
  return hs.screen.primaryScreen():next()
end

M.get_space_id = function(scr, space_index)
  local spaces = M.get_spaces(scr)
  return spaces[space_index]
end

--[[
Move windoww into space

types: space_of_screen

['AppName'] = {
  BuiltIn = [SpaceIndex],
  Extennal = [SpaceIndex],
}
--]]
M.move = function(win, space_of_screen)
  local screen_list = M.get_screens()
  local hasExternal = #screen_list > 1

  local to_screen = M.get_primary_screen()
  local to_space_index = space_of_screen['BuiltIn']

  if hasExternal and space_of_screen['External'] ~= nil then
    to_screen = M.get_external_screen()
    to_space_index = space_of_screen['External']
  end

  log.i('target_screen', to_screen:name(), to_screen:getUUID())

  local space_id = M.get_space_id(to_screen, to_space_index)
  if not space_id then return end

  log.i('to_space_id', space_id)

  hs.spaces.moveWindowToSpace(win, space_id)
end

-- TODO move window to near space
M.move_prev = function (win)
  
end

M.move_next = function (win)
  
end

--[[
Find all window in all spaces for all screens
--]]
M.all_windows_of_spaces = function()
  local windows = {}
  hs.fnutils.each(hs.spaces.allSpaces(), function(spaces)
    hs.fnutils.each(spaces, function(space_id)
    end)
  end)
end

return M
