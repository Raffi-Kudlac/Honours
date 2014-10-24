--[[
    Purpose:
        This file is an object for the land Screen. Each grid section holds a object of this file.
        Here all the information is held of what kind of tile it is and other characteristic.

]]

-------------------------------------------------
--
-- landTile.lua
--
--
-------------------------------------------------
 
local landTile = {}

local landTile_mt = { __index = landTile }  -- metatable

function landTile.new(kind)  -- constructor
    
  local newLandTile = {
    type = kind,
    built = false,
    owned = false,    
  }
  
  return setmetatable( newLandTile, landTile_mt )
end
 
return landTile