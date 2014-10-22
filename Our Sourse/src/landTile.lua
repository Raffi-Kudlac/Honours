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