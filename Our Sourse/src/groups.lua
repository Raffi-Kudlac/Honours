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
    
    if (temp == 0) then
        self.actionPercent = 0 
    elseif(temp > 0 and temp < 5 ) then
        self.actionPercent = 5
    elseif (temp > 5 ) then
        self.actionPercent = 10    
    end
    
end

function groups:getActionPercent()
    return self.actionPercent
end

function groups:getNumberStatus()
    return self.status
end

function groups:getStatus()
  
  if (self.status == 0) then
      return ":|"
  elseif(self.status < 0 and self.status >= -5) then
      return ":("
  elseif(self.status > -5) then
      return " :x"
  elseif(self.status > 0 and self.status < 5 ) then
      return ":)"
  elseif (self.status > 5 ) then
      return "XD"
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