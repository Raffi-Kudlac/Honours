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

function advertisements.new( nme, CostToUse )  -- constructor
    
  local newAdvertisement = {
    bought = false,
    name = nme,
    cost = costToUse,
    effect = ""
  }
  
  return setmetatable( newAdvertisement, advertisements_mt )
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