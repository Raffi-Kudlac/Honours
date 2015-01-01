--[[
    Purpose:
        This file is an object for the different kinds of group that can be influenced
        throughout the game. 
]]

 
local publicServises = {}
local publicServises_mt = { __index = publicServises }  -- metatable

-------------------------------------------------
-- PUBLIC FUNCTIONS
-------------------------------------------------

function publicServises.new(nme, costToUse)  -- constructor
    
  local newservis = {    
    name = nme,
    cost = costToUse,
    about = "",
    bought = false,
  }
  
  return setmetatable( newservis, publicServises_mt )
end

function publicServises:getName()
    return self.name
end


function publicServises:getCost()
    return self.cost
end


function publicServises:setCost( costToUse )
    self.cost = costToUse
end


function publicServises:getAbout()
    return self.about
end


function publicServises:setAbout( data )
    self.cost = data
end


function publicServises:getBought()
    return self.bought
end


function publicServises:setBought( b )
    self.bought = b
end

function publicServises:flipBought()

      if self.bought then
        self.bought = false
      else
        self.bought = true
      end
end


 
return publicServises