--[[
Purpose:
This file is responcible for holding varibles that are accessable to other files that
reference this one.
]]

local powerPlant        = require( "powerPlant" )

-- Used to hold the static images so they remain when scenes change
stage         = display.getCurrentStage()
seconds       = 0
monthCounter  = 0
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
solarSpecs    = powerPlant
windSpecs     = powerPlant
money         = 0
fontSize      = 0
font          = native.systemFont
resourseAmount =  0	-- holds the amount of resourses found for each type
resourcesHeld = 0   --holds the current amount of each resource. oil, gas, coal, uranium
coalBuildCounter = 0
oilBuildCounter = 0
gasBuildCounter = 0
nuclearBuildCounter = 0
solarBuildCounter = 0
windBuildCounter = 0
naturalLandUsedCounter = 0
rivers = 0
hydroCounter = 0
groups = 0
businessFont = 10
groupCounter = 4
advertisements = 0
addCounter = 5
moneyMadeFactor = 0 -- used to calculate how much each GW is worth
publicServises = 0
servisCounter = 5
demandFactor = 1.2
monthlyPopulationIncrease = 0
onCityScreen = true
groupActionWinner = -1
blackoutLengthCounter = 0 -- the length of the blackout in number of months, if over 10 then game over
blackoutCounter = 0       -- a counter holding the number of total blackouts that has occured unit is in months
blackoutTracker = 0       -- a tracker holding the number of blackout to be compared against the blackout rate
-- if the user triggers a certain number of blackouts within a certain time then, the game is over
blackoutAmountRate = 0
blackoutTimeRate   = 0    -- unit is in years

blackoutTimes ={}       -- beacuse this array uses provided functions the starting index is 1
blackoutLengthSum = 0   -- holds the sum of the lengths of all blackouts in units of months. note does not hold the current blackout

nuclearInfluence = 1    -- the amount of influence that will effect the envirmental group
coalInfluence = 2
gasInfluence = 1
oilInfluence = 1
monthTimer = 0
secondsTimer = 0
foundResourses = 0
-- an array holding text that will be displayed if a public servise passes
publicServisText = 0
submitionName = ""

addButtonCounter = 0      -- used for statistical purposes. counts how many times the add have been activated
publicServisButtonCounter = 0 -- used for statistical purposes. counts how many time the ps have been activated


buttonR = 0
buttonG = 0
buttonB = 0
buttonOver1 = 0
buttonOver2 = 0
buttonOver3 = 0
buttonOver4 = 0

gaveOver = false

local g       = {}
return g