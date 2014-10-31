--[[
    Purpose:
        This file holds the static information about each type of power plant. All this files does is store information
        to be assessed when needed. One instance of this object will exist for each type of power.
]]

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
    type        = kind,
    cost        = 0,
    produces    = 0,
    pros        = "",
    consumption = 0,
    cons        = ""
  }
  
  return setmetatable( newPowerPlant, powerPlant_mt )
end


function powerPlant:setCost(money)

    self.cost = money
end


function powerPlant:setPros(advantage)

    self.pros = advantage    
end


function powerPlant:setCons(disadvantage)

    self.cons = disadvantage
end 


function powerPlant:setProduction(production)

  self.produces = production
end


function powerPlant:setConsumption(c)

    self.consumption = c
end


function powerPlant:getPros()

    return self.pros
end


function powerPlant:getCons()

    return self.cons
end
 

function powerPlant:getCost()

    return self.cost
end


function powerPlant:getProduces()

    return self.produces    
end


function powerPlant:getType()

    return self.type    
end


function powerPlant:getConsumption()

    return self.consumption    
end

 
return powerPlant