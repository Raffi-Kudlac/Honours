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
    about = ""
  }
  
  return setmetatable( newgroup, groups_mt )
end

function groups:getName()
    return self.name
end

function groups:setStatus(n)
    -- 10 is really happy. -10 is really mad
    -- could have done this all in the first check but i thought it would have been too long
    if (self.status < 10 and self.status > -10) then
        self.status = self.status + n
    elseif ( self.status < 10 and n < 0) then
        self.status = self.status + n
    elseif ( self.status > -10 and n > 0) then
        self.status = self.status + n       
    end    
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
  elseif (self.status > 10 ) then
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