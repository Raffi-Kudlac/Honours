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
local g       = {}

return g