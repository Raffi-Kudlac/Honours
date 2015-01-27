--[[
Purpose:
This is the object for the tiles on the natural screen, the screen for solar and wind power.
This object holds the data for the tile and what actions can be performed on it.
]]




local naturalTile = {}

local naturalTile_mt = { __index = naturalTile }  -- metatable

-------------------------------------------------
-- PUBLIC FUNCTIONS
-------------------------------------------------

function naturalTile.new(kind)  -- constructor

  local newnaturalTile = {
    type = kind,
    built = false,
    owned = false,
    cost = 5,         -- cost to build on this cell
  }

return setmetatable( newnaturalTile, naturalTile_mt )
end

function naturalTile: getType()

  return self.type
end

function naturalTile: setOwned()

  self.owned = true

end

function naturalTile: setBuilt(b)

  self.built = b

end

function naturalTile: setType(kind)

  self.Type = kind

end

return naturalTile