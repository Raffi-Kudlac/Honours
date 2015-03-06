--[[
Purpose:
This file is an object for the different kinds of advertisements that the
user can purchase throughout the game to help influence the groups.
]]


local advertisements = {}
local advertisements_mt = { __index = advertisements }  -- metatable

-------------------------------------------------
-- PUBLIC FUNCTIONS
-------------------------------------------------

function advertisements.new( nme, costToUse )  -- constructor

  local newAdvertisement = {
    bought = false,
    name = nme,
    cost = costToUse,
    effect = "",
    timesActivated = 0
  }

return setmetatable( newAdvertisement, advertisements_mt )
end

function advertisements:getTimesActivated()
    return self.timesActivated
end

function advertisements:getName( )
  return self.name
end

function advertisements:setEffect( information )
  self.effect = information
end

function advertisements:getEffect( )
  return self.effect
end

function advertisements:getBought( )
  return self.bought
end

function advertisements:setBought( status )
  self.bought = status
  
  if(status) then
      self.timesActivated = self.timesActivated + 1
  end 
end

function advertisements:flipBought( )

  if self.bought then
    self.bought = false
  else
    self.bought = true
  end
end

function advertisements:getCost( )
  return self.cost
end

function advertisements:setCost( costToUse )
  self.cost = costToUse
end


return advertisements