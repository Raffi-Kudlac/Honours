--[[
    Purpose:
        This files holds the attributes for each river that the user will have the ability to dam.
]]

 
local river = {}
local river_mt = { __index = river }  -- metatable
  
-------------------------------------------------
-- PUBLIC FUNCTIONS
-------------------------------------------------
 
function river.new(nme,AD,CTB,PG,MC)  -- constructor
    
  local newRiver = {
    name = nme,
    currentSpeed = 0,
    areaDestroyed = AD,
    data = "",
    costToBuild = CTB,
    built = false,
    powerGenerated = PG,
    costToMaintain = MC,
  }
  
  return setmetatable( newRiver, river_mt )
end

function river:getMainteneceCost()
    return self.costToMaintain
end

function river:getBuilt()
    return self.built 
end

function river:setBuilt()
    self.built = true 
end


function river:getCost()
    return self.costToBuild 
end


function river:getAD()
    return self.areaDestroyed 
end

function river:getPowerGenerated()
    return self.powerGenerated 
end

function river:getName()
    return self.name 
end

function river:setData(message)
    self.data = message 
end

 
function river:getData()
    return self.data 
end 
 
return river