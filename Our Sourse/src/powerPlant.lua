-------------------------------------------------
--
-- powerPlant.lua
--
--
-------------------------------------------------
 
local powerPlant = {}

local powerPlant_mt = { __index = powerPlant }  -- metatable

function powerPlant.new(kind)  -- constructor
    
  local newPowerPlant = {
    type = kind,
    cost = 0,
    produces = 0           
  }
  
  return setmetatable( newPowerPlant, powerPlant_mt )
end

function powerPlant:setCost(money)

    self.cost = money
end
 
return powerPlant