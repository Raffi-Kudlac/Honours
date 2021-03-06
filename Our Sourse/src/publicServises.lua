--[[
Purpose:
This file is an object for the different kinds of group that can be influenced
throughout the game.
]]

local gv        = require( "global" )
local publicServises = {}
local publicServises_mt = { __index = publicServises }  -- metatable

-------------------------------------------------
-- PUBLIC FUNCTIONS
-------------------------------------------------

function publicServises.new(nme, costToUse)  -- constructor
  
  local tempMonthPercent = 1 - (40)/100

    tempMonthPercent = tempMonthPercent^(1/12)
    tempMonthPercent = math.round(((1 - tempMonthPercent)*100)*10)/10


  local newservis = {
    name = nme,
    cost = costToUse,
    about = "",
    bought = false,
    timesActivated = 0,
    yearlyPercent = 40,
    monthlyPercent = tempMonthPercent,
  }

return setmetatable( newservis, publicServises_mt )
end

function publicServises:getYearlyPercent()

  return self.yearlyPercent
end

function publicServises:getTimesActivated()
    return self.timesActivated
end

-- this function also calculates the monthlyPercent as well
function publicServises:setYearlyPercent(p)

  self.yearlyPercent = p
end

function publicServises:getMonthlyPercent()

  return self.monthlyPercent
end

function publicServises:setMonthlyPercent(p)

  self.monthlyPercent = p
end

function publicServises:calculatePassFail()

  local randomNumber = math.random(1,100)
  print( "The yearly percent is " .. tostring(self.yearlyPercent))

  if ( self.monthlyPercent >= randomNumber) then
    self.yearlyPercent = self.yearlyPercent - 15

    if (self.yearlyPercent < 2 and gv.year < 2030 ) then
      self.yearlyPercent = 1
    elseif (self.yearlyPercent < 2 and gv.year >= 2030 ) then
        self.yearlyPercent = 0
    end

    local answer = 1 - (self.yearlyPercent)/100

    answer = answer^(1/12)
    self.monthlyPercent = math.round(((1 - answer)*100)*10)/10

    return true
  else
    return false
  end



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
  self.about = data
end


function publicServises:getBought()
  return self.bought
end


function publicServises:setBought( b )
  self.bought = b
  
  if (b) then
      self.timesActivated = self.timesActivated + 1
  end
end

function publicServises:flipBought()

  if self.bought then
    self.bought = false
  else
    self.bought = true
  end
end



return publicServises