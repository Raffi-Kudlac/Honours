--[[
Purpose:
This file is an object for the land Screen. Each grid section holds a object of this file.
Here all the information is held of what kind of tile it is and other characteristic.

NOTE TO SELF:
--  the contians array holds the amount of resourses that the cell holds
-- 0 - oil
-- 1 - gas
-- 2 - coal
-- 3 - uranium
]]


local miningCell = {}

local miningCell_mt = { __index = miningCell }  -- metatable


function miningCell.new(kind)  -- constructor

  local miningCell = {
    empty = false,
    mined = false,
    contains = {},
  }

miningCell.contains[0] = 0
miningCell.contains[1] = 0
miningCell.contains[2] = 0
miningCell.contains[3] = 0


return setmetatable( miningCell, miningCell_mt )
end

function miningCell:setAmount(index,amount)

  self.contains[index]= amount

end

function miningCell:setEmpty()

  self.empty = true

end

function miningCell:isEmpty()

  return self.empty
end

function miningCell:getAmount(index)

  return self.contains[index]

end


function miningCell:setMined()

  self.mined = true
end

function miningCell:isMined()

  return self.mined
end

return miningCell