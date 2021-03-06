--[[
Purpose:
This file is an object for the different kinds of group that can be influenced
throughout the game.
]]


local groups = {}
local groups_mt = { __index = groups }  -- metatable


-------------------------------------------------
-- PUBLIC FUNCTIONS
-------------------------------------------------

function groups.new(nme)  -- constructor

  local newgroup = {
    status = 0,
    name = nme,
    actionPercent = 0,
    happyText = "",
    madText   = "",
    about = ""
  }

return setmetatable( newgroup, groups_mt )
end

function groups:getHappyText()
  return self.happyText
end

function groups:getMadText()
  return self.madText
end

function groups:setHappyText(s)
  self.happyText = s
end

function groups:setMadText(s)
  self.madText = s
end

function groups:getName()
  return self.name
end

function groups:setStatus(n)
  -- 10 is really happy. -10 is really mad

  self.status = self.status + n

  if ( self.status > 10 ) then
    self.status = 10
  elseif ( self.status < -10 ) then
    self.status = -10
  end

  local temp = math.abs ( self.status)
  
  self.actionPercent = math.round(math.abs( self.status )*4)/10
end

function groups:getActionPercent()
  return self.actionPercent
end

function groups:getNumberStatus()
  return self.status
end

function groups:getStatus()

  if (self.status == 0) then
    return "Images/business_screen/bns_neutral.png"
  elseif(self.status < 0 and self.status >= -5) then
    return "Images/business_screen/bns_sad.png"
  elseif(self.status < -5) then
    return "Images/business_screen/bns_supersad.png"
  elseif(self.status > 0 and self.status < 5 ) then
    return "Images/business_screen/bns_happy.png"
  elseif (self.status > 5 ) then
    return "Images/business_screen/bns_superhappy.png"
  else
    return "X"
  end
end

function groups:setAbout(data)

  self.about = data
end

function groups:getAbout()

  return self.about
end


return groups