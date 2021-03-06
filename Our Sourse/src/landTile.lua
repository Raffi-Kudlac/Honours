--[[
Purpose:
This file is an object for the land Screen. Each grid section holds a object of this file.
Here all the information is held of what kind of tile it is and other characteristic.
]]


local landTile = {}
local me
local landTile_mt = { __index = landTile }  -- metatable


-------------------------------------------------
-- PRIVATE FUNCTIONS
-------------------------------------------------

local function setCost()

  if (me.type == "owned") then
    me.cost = 0
  elseif(me.type == "forest") then
    me.cost = 50
  elseif (me.type == "city owned") then
    me.cost = 90  
  else
    me.cost = -1
  end
end

-- ppType can be oil, gas, nuclear, coal or none.
function landTile.new(kind, ppType)  -- constructor


  local temp = 0
  local b = false

  if (kind == "owned") then
    temp = 0
    b = true
  elseif(kind == "forest") then
    temp = 50
  elseif (kind == "city owned") then
    temp = 90  
  else
    temp = -1
  end


  local newLandTile = {
    type = kind,
    built = b,
    owned = false,
    cost = temp,
    typeOfPowerPlant = ppType,
  }


  return setmetatable( newLandTile, landTile_mt )
end


function landTile:getType()

  return self.type

end

function landTile:getTypeOfPowerPlant()

  return self.typeOfPowerPlant
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