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
local me

local landTile_mt = { __index = landTile }  -- metatable

local function setCost()

      if (me.type == "owned") then
          me.cost = 0
      elseif(me.type == "forest") then
          me.cost = 4
      elseif (me.type == "city owned") then
          me.cost = 2
      elseif(me.type == "forest") then
          me.cost = 4
      else
          me.cost = -1
      end
end



function landTile.new(kind)  -- constructor
    
    
    local temp = 0
    local b = false
    
  if (kind == "owned") then
      temp = 0
      b = true
  elseif(kind == "forest") then
      temp = 4
  elseif (kind == "city owned") then
      temp = 2
  elseif(kind == "forest") then
      temp = 4
  else
      temp = -1
  end 
  
   
  local newLandTile = {
    type = kind,
    built = b,
    owned = false,
    cost = temp,    
  }
  
  
  return setmetatable( newLandTile, landTile_mt )
end

function landTile:getType()

    return self.type

end

function landTile:setType(t)
    
    me = self
    self.type = t
    setCost()
end

function landTile:setCost(c)

    self.cost = c

end

function landTile:getCost()

    return self.cost
    
end
 
return landTile