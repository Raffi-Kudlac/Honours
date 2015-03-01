--[[
Purpose:
This file is an object for the different kinds of group that can be influenced
throughout the game.
]]


local operatingData = {}
local operatingData_mt = { __index = operatingData }  -- metatable


-------------------------------------------------
-- PUBLIC FUNCTIONS
-------------------------------------------------

function operatingData.new()  -- constructor

  local operatingData = {
    workings = {},
    position = 1
  }

return setmetatable( operatingData, operatingData_mt )
end

function operatingData:insert(value)

    table.insert(self.workings, value)

end

-- reads the current index and then moves the pointer to the next location
-- if out of bounds then moves the pointer to the beggining again.
function operatingData:read()
    local temp = self.workings[self.position]
    
    self.position = self.position + 1
    
    if (self.position > #self.workings) then
        self.position = 1
    end
    
    return temp

end

function operatingData:removeAll()

    for x = #self.workings, 1, -1 do
        table.remove(self.workings,x)
    end
    position = 1

end

return operatingData