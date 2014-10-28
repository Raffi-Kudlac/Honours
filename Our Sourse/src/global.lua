--[[
    Purpose: 
        This file is responcible for holding varibles that are accessable to other files that
        reference this one.
]]

local powerPlant        = require( "powerPlant" )
 
-- Used to hold the static images so they remain when scenes change
stage         = display.getCurrentStage()
seconds       = 0
year          = 2000
month         = 5000 --each month is five seconds
secondsTimer  = timer
yearTimer     = timer
population    = 10000
powerDemanded = 0
powerSupplied = 0
screen        = "city"
oilSpecs      = powerPlant
coalSpecs     = powerPlant
gasSpecs      = powerPlant
nuclearSpecs  = powerPlant
money         = 0
fontSize      = 0
font          = native.systemFont


local g       = {}

return g