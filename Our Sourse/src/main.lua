
--[[
Purpose:
By Lua default all files have access to this file and this is the first file that is executed by the program.
This holds all global methods and is responcible for setting up the static components of the game, as well as timers,
and iinitalizing global variables.

NOTES FOR MYSELF------
Width is along the x axis
Height is along the y axis
top = height
left = width
function() return setText(gv.oilSpecs) end, used for passing parameters to a button call

-- oil = 0
-- gas = 1
-- coal = 2
-- nuclear = 3

]]

local widget          = require( "widget" )
local gv              = require( "global" )
local composer        = require( "composer" )
local powerPlant      = require( "powerPlant" )
local stream          = require( "river" )
local organization    = require( "groups" )
local adds            = require( "advertisements" )
local publicServises  = require( "publicServises" )
require( "mining" )
require( "naturalOptions" )


local onInnerWorkings = false
local stcBG
local btnBNS
local btnCY
local btnPP
local btnLND
local btnRS
local btnBlackout
local btnPausePlay
local btnMenu
local MB
local dataBar
local dataBox1
local dataBox2
local dataBox3
local TBBG
local timeBar
local timeLabel
local weather
local btnPausePlay
local blackoutSwap = nil
    

local startBlackoutTimeYear = 0
local startBlackoutTimeMonth = 0
local populationFine = 25 
local isPaused = false
local initalPopulation = 10000
local btnPausePlay
local monthCounter    = 1
local circleWidth     = 30
local circleHeight    = 30
local MB = widget
local populationVariable = 1.07
local month           = {
  "January",
  "February",
  "March",
  "April",
  "May",
  "June",
  "July",
  "August",
  "September",
  "October",
  "November",
  "December"
}

-- year not being used right now.
local function populationFunction(year)
  
  local yearsPassed = gv.year- 200
  local populationRateArray = {}
  local index = math.random(1,4)
  
  
  if (yearsPassed > 10 ) then   -- make population growth rate slower
      populationRateArray[1] = 1.07
      populationRateArray[2] = 1.06
      populationRateArray[3] = 1.08
      populationRateArray[4] = 1.05
      return math.round (gv.population*populationRateArray[index])
      
  else    -- make population growth rate larger
      populationRateArray[1] = 1.09
      populationRateArray[2] = 1.1
      populationRateArray[3] = 1.11
      populationRateArray[4] = 1.12
       return math.round (gv.population*populationRateArray[index])
  end
  
  return math.round (gv.population*populationVariable)

end

local function removeStage()
    
      gv.stage:remove( stcBG )
      gv.stage:remove(btnBNS)
      gv.stage:remove(btnCY)
      gv.stage:remove(btnPP)
      gv.stage:remove(btnLND)
      gv.stage:remove(btnRS)
      gv.stage:remove( btnBlackout )
      gv.stage:remove(btnPausePlay)
      gv.stage:remove( btnMenu )
      gv.stage:remove( MB )
      gv.stage:remove( dataBar )
      gv.stage:remove( dataBox1)
      gv.stage:remove( dataBox2)
      gv.stage:remove( dataBox3)
      
      gv.stage:remove( TBBG )
      gv.stage:remove(timeBar)
      gv.stage:remove( timeLabel )
      gv.stage:remove( weather )
      gv.stage:remove( btnPausePlay )

end

function widthCalculator(percent)

  return display.contentWidth*percent
end

function heightCalculator(percent)

  return display.contentHeight*percent
end


local function calculateMonthlyPopulationIncrease()

  return  math.round ( (populationFunction(year+1) - gv.population)/12)

end


function startingPower()

  composer.gotoScene("natural")
  setNaturalCurrentEnergySourse(gv.windSpecs)
  for x = 1, 1, 1 do
    gv.marker = x
    naturalPurchasedConfirmed()
  end
  gv.money = gv.money + gv.windSpecs:getCost()*2

  setNaturalCurrentEnergySourse(gv.solarSpecs)
  for x = 1, 3, 1 do
    gv.marker = 5 + x
    naturalPurchasedConfirmed()
  end
  gv.money = gv.money + gv.solarSpecs:getCost()*2


  composer.gotoScene("land")
  gv.marker = 2
  setLandCurrentEnergySourse(gv.coalSpecs)
  landPurchasedConfirmed()
  gv.money = gv.money + gv.coalSpecs:getCost()
  
  startingOffTiles()

end

local function main()
  display.setStatusBar( display.HiddenStatusBar )
  composer.gotoScene("menu")
end

-- Initalizing the global variables
local function initalize()

  monthCounter    = 0
  gv.monthCounter = 0
  gv.monthTimer    = 0
  gv.secondsTimer  = 0
  gv.stage         = display.getCurrentStage()
  gv.seconds       = 0
  gv.businessFont = 14
  gv.year          = 2000
  gv.month         = 5000 --each month is five seconds
  gv.secondsTimer  = timer
  gv.yearTimer     = timer
  gv.population    = 10000--populationFunction(year)
  gv.onCityScreen  = true
  gv.gameOver = false
  
  gv.monthlyPopulationIncrease = calculateMonthlyPopulationIncrease()
  
  gv.submitionName = ""
  gv.demandFactor  = 1.2
  gv.money = 10
  gv.moneyMadeFactor = 0.9
  calcPowerDemanded()
  gv.powerSupplied = 13.1 -- manually calculated starting power. 4.3 + 2.8 + 2*3
  gv.screen = "city"
  gv.font = native.newFont( "Chunkfive Ex", 8 )--"Chunkfive Ex"--native.systemFontBold
  gv.fontSize = 10
  gv.fontColourR = 255/255
  gv.fontColourG = 255/255
  gv.fontColourB = 255/255
  gv.resourseAmount = {}
  gv.resourcesHeld = {}

  gv.resourcesHeld[0] = 0
  gv.resourcesHeld[1] = 0
  gv.resourcesHeld[2] = 0
  gv.resourcesHeld[3] = 0

  gv.coalBuildCounter = 0
  gv.oilBuildCounter = 0
  gv.gasBuildCounter = 0
  gv.nuclearBuildCounter = 0
  gv.solarBuildCounter = 0
  gv.windBuildCounter = 0
  gv.naturalLandUsedCounter = 0

  gv.plantBuildIndex = 0
  gv.resourseAmount[0] = 0
  gv.resourseAmount[1] = 0
  gv.resourseAmount[2] = 0
  gv.resourseAmount[3] = 0
  
  gv.nuclearInfluence = 1
  gv.coalInfluence = 2
  gv.gasInfluence = 1
  gv.oilInfluence = 1


  local energyPros = "This fossil fueled power plant runs off of oil which is abundant and fairly cheap to obtain."..
    " In comparison to coal it will burn faily well and not pollute the air as much. It will produce good amounts of power"
  local energyCons = "Oil is a finite resource on the plantet and it has other uses for cars and heating homes. Although it " .. 
  "does not pollute as much as coal it still releases small green house emitions and getting thos stuff " .. 
  "out of the ground is no clean task. Environmentalists wont be too happy."
  local energyCost = 110
  local energyProduction = 4.1
  local energyConsumption = 1
  local energyMaintenence = 4

  gv.oilSpecs = powerPlant.new("oil")
  gv.oilSpecs:setCost(energyCost)
  gv.oilSpecs:setProduction(energyProduction)
  gv.oilSpecs:setCons(energyCons)
  gv.oilSpecs:setPros(energyPros)
  gv.oilSpecs:setConsumption(energyConsumption)
  gv.oilSpecs:setMaintenenceCost(energyMaintenence)

  -- For Hydro
  gv.rivers = {}
  gv.hydroCounter = 6
  -- name, area Distroyed, cost to build, power generated, cost to mainTain
  gv.rivers[0] =  stream.new("Hudson",15,120,4.0,3)
  gv.rivers[1] =  stream.new("Amazon River",25,150,4.5,3)  
  gv.rivers[2] =  stream.new("Colorado River",20,130,3.8,3)
  gv.rivers[3] =  stream.new("The Nile",30,170,4.6,3)
  gv.rivers[4] =  stream.new("Niagra Falls",5,140,3.8,3)
  gv.rivers[5] =  stream.new("Mississippi River",17,120,4.3,3)

  local r0Data = "The Hudson river is a prime source of clean hydro electric power. Only destroying 15 square kilometers " .. 
  "the environmentalist will protest but there are worse places to build dams. "

  gv.rivers[0]:setData(r0Data)
  
  r0Data = "A water source with high power outage but unfortunately destroys a large amount of " .. 
  "habited land. If we build here the environmentalist will go nuts. Only " ..
  "build here if we have no other options."
  gv.rivers[1]:setData(r0Data)
  
  r0Data = "The Colorado River. Similar to the Hudson but because of geography slightly more area is destroyed if " .. 
  "we deside to build here."
  
  gv.rivers[2]:setData(r0Data)
  
  r0Data = "The Nile. A river of life and prosperity. daming this river would have huge environmental effects and " .. 
  "repercussions as well as a shift in the stability in the environment after the dam was built due to the change in " ..
  "levels of water. Building here is not recommended."
  
  gv.rivers[3]:setData(r0Data)
  
  
  r0Data = "Niagra Falls. Due to the height of the falls, the speed of the water and the amount of flowing water we can build a " ..
  "dam here for minimal environmental effects and get decent amounts of power back. It would be nice if all dams could be built " .. 
  "on sites like these but they are rare. Building here is strongly recommended." 
  
  gv.rivers[4]:setData(r0Data)
  
  
  r0Data = "A river with the capability to produce clean energy and not to destroy too much land in the " ..
  "process. Environmentalists will be displeased but we can live with that. People need power."
  
  gv.rivers[5]:setData(r0Data)
  

  energyPros = "This fossil fueled power plant runs off of coal which is the most abundant and energy rich of the fossil fuels."..
    " Coal is cheap and fairly easy to obtain."

  energyCons = "Coal puts carbon dioxide into the air and its supplies are not infinite. Environmentalists will not"..
    " like you for building this kind of power plant"

  energyCost = 100
  energyProduction = 4.3
  energyConsumption = 1.7    -- factor of 1000 killo tonnes
  energyMaintenence = 4

  gv.coalSpecs = powerPlant.new("coal")
  gv.coalSpecs:setCost(energyCost)
  gv.coalSpecs:setProduction(energyProduction)
  gv.coalSpecs:setCons(energyCons)
  gv.coalSpecs:setPros(energyPros)
  gv.coalSpecs:setConsumption(energyConsumption)
  gv.coalSpecs:setMaintenenceCost(energyMaintenence)

  energyPros = "This fossil fueled power plant runs off of gas. Gas is the most expensive of the fossil fuels but burns the cleanest"..
    " and has the least impact on the atmosphere"
  energyCons = "Gas is can be dangerious to handle and requires proper containment. It must be handled properly and " .. 
  "carefully. Don't want any acidents to happen. There is also a finite amount of gas on the plant."
  energyCost = 120
  energyProduction = 4
  energyConsumption = 1.5

  gv.gasSpecs = powerPlant.new("gas")
  gv.gasSpecs:setCost(energyCost)
  gv.gasSpecs:setProduction(energyProduction)
  gv.gasSpecs:setCons(energyCons)
  gv.gasSpecs:setPros(energyPros)
  gv.gasSpecs:setConsumption(energyConsumption)
  gv.gasSpecs:setMaintenenceCost(energyMaintenence)

  energyPros = "Nuclear power is the cleanest of the natural resources. With uranium being the most abundant resource it can long outlast fossil fuels. " .. 
  " And there is way more energy per unit of uranium then there is per unit of coal."
  energyCons = "Uranium is radio active and getting at its pool of energy can be dangerious. The radio active waste that " .. 
  " the plant produces can't just be hucked in the garbage it must be properly disposed of. Some people are scared " .. 
  "of nuclear power and even though there are no envirmental hazards we still have to dig for uranium."
  energyCost = 150
  energyProduction = 4.8
  energyConsumption = 1

  gv.nuclearSpecs = powerPlant.new("nuclear")
  gv.nuclearSpecs:setCost(energyCost)
  gv.nuclearSpecs:setProduction(energyProduction)
  gv.nuclearSpecs:setCons(energyCons)
  gv.nuclearSpecs:setPros(energyPros)
  gv.nuclearSpecs:setConsumption(energyConsumption)
  gv.nuclearSpecs:setMaintenenceCost(energyMaintenence)

  energyPros = "Solar power is the only power source that works differently. By turning light into energy there are no environmental"..
    " consequences and it is self sustaining. As long as the sun is around, we can have solar power. Environmentalists will " .. 
    "like it if we decide to build these."
  energyCons = "Although well liked, solar panels are expensive and have a low conversion rate of light to energy. This " ..
    "doesn't make them an ideal source of power for a large population. They also only work during the day."
  energyCost = 50
  energyProduction = 2
  energyConsumption = 0

  gv.solarSpecs = powerPlant.new("solar")
  gv.solarSpecs:setCost(energyCost)
  gv.solarSpecs:setProduction(energyProduction)
  gv.solarSpecs:setCons(energyCons)
  gv.solarSpecs:setPros(energyPros)
  gv.solarSpecs:setConsumption(energyConsumption)
  gv.solarSpecs:setMaintenenceCost(1)

  energyPros = "Wind power is one of the main natural resources. Running off of flowing air it is capable of producing " ..
    "clean energy. Windmills will produce power as long as there is moving air so no need to worry about running out of wind. " .. 
    "Environmentalists will like it if we decide to build these."


  energyCons = "Windmills are expensive to build and don't produce a lot of energy compared to fossile fuels so they can not " ..
    "sustain a large population. They also take up large amounts of room. People who live near windmills don't like the noise " ..
    "contant rotating shadows and view. Windmills cause many bird casualties so bird watchers are not fans as well"

  energyCost = 60
  energyProduction = 2.8
  energyConsumption = 0

  gv.windSpecs = powerPlant.new("wind")
  gv.windSpecs:setCost(energyCost)
  gv.windSpecs:setProduction(energyProduction)
  gv.windSpecs:setCons(energyCons)
  gv.windSpecs:setPros(energyPros)
  gv.windSpecs:setConsumption(energyConsumption)
  gv.windSpecs:setMaintenenceCost(1)

  gv.groups = {}
  gv.groupCounter = 4
  gv.groupActionWinner = -1

  gv.groups[0] = organization.new( "Environmentalists" )
  gv.groups[0]:setAbout("\nThis organization is dedicated to protecting the earth and to caring for the " ..
    "environment. Polluting the atmosphere or destroying the land in any way will generally make this organization " ..
    "angry with you. This organization is affected by and effects almost all forms of power. It is very hard to keep them happy forever." .. 
    " Building clean sources of energy will help keep them happy.")


  gv.groups[0]:setHappyText("The Environmentalists are happy with you and have convinced the government to reduce taxes for you. " ..
    "as a result the maintenance cost of fossil fueled, nuclear and hydro power plants has decreased by $1")

  gv.groups[0]:setMadText("\nThe Environmentalists are mad that you are polluting the planet. They have convinced the government to " ..
    "add more taxes to your power plants. As a result the maintenance cost of your nuclear, fossil fueled and hydro power plants has " ..
    "increased by $1")

  gv.groups[1] = organization.new( "Anti-Nuclear" )
  gv.groups[1]:setAbout("\nThis organization of people is composed of people who are scared of nuclear power and believe that it " ..
    "is too dangerous to be used close to their homes and loved ones. Building nuclear power plants will upset this group. " ..
    "A good way to deal with them would be to educate them and assure them that although nuclear power is dangerous, all " ..
    "the safety precautions are being taken so there is nothing to fear.")

  gv.groups[1]:setHappyText("The Anti-Nuclear group aren't seeming so Anti-Nuclear any more and they have gotten off your "..
    "back for the time being. With some extra breathing room and not having to deal with them you have reduced the maintenance cost" ..
    "of nuclear power Plants by $2")

  gv.groups[1]:setMadText("The Anti-Nuclear group is mad at you for building nuclear power plants. They feel unsafe and worried. "
    .. "They have complained to the government and as a result you have been forced to increase security checks and add " ..
    "extra safety precautions. This has increased the maintenance cost of all nuclear power plants by $2")


  gv.groups[2] = organization.new( "The Population" )
  gv.groups[2]:setAbout("\nThe people you serve generally don't care how they get their power as long as they get it. " ..
    "Keeping the lights on will keep them happy but if blackouts occur then they are going to get mad. If too many blackouts" ..
    " happen then you have to give some money back to the people to compensate, and if too many " ..
    "happen too frequently then you will lose.")

  gv.groups[2]:setHappyText("The people are happy with your production of power. You don't get anything but at least" ..
    "they are not rioting and making your life difficult.")

  gv.groups[2]:setMadText("Too many blackouts have happened and the people have rioted and made inappropriate signs" ..
    " protesting your capabilities of producing power. You pay a fine of $" .. populationFine ..  
    " for the damages and getting rid of the protestors.")

  gv.groups[3] = organization.new( "Anti-Windmillists" )
  --    gv.groups[3]:setAbout("You would think, 'Who protests Windmills. Clean energy and no envirmental hazards' well " ..
  --    "aparently living by windmills is not the most pleasent expeareance, they are loud noisy machines that generally don't " ..
  --    "give the landscape any beauty points eigher. They are also the reason for a lot avian deaths when they don't like to "..
  --    "look where they are flying." )

  gv.groups[3]:setAbout("\nYou would think, 'Who would protest windmills? Clean energy and no major environmental hazards.' Well you can't " ..
    "make everybody happy. This group is usually composed of people who live around windmills. They don't like the noise and " ..
    "appearance of these big machines. The population of this group is generally small and they don't get a lot of attention " ..
    "as windmills are a source of clean energy.")

  gv.groups[3]:setHappyText("although windmills are noisy and not nice to live around you have convinced the " ..
    "Anti-Windmillists that they are worth it. The cost of building windmills has reduced by $5.")

  gv.groups[3]:setMadText("Farmers and countrymen are not happy about the windmills that you have been putting up." ..
    "They have rallied and spoken to the government. The cost of building future windmills has increased by $5 and " .. 
    "you have been fined $10")

  gv.advertisements = {}
  gv.addCounter = 5
  local adCost = 4
  
  gv.advertisements[0] = adds.new( "Save Power", adCost )
  gv.advertisements[0]:setEffect("Costs $".. adCost .." per month. \nEducate the population" .. 
   " to intelligently use power so they don't waste it."..
    " This ad is useful if you are having trouble keeping up with demand and it makes the environmentalists less mad.")

  adCost = 5
  gv.advertisements[1] = adds.new( "Safe Nuclear Power", adCost )  
  gv.advertisements[1]:setEffect("Costs $" .. adCost .." per month. \nAdvertise to the population" ..
   " about the workings of nuclear power. Show them that " .. 
    "although nuclear power can be dangerous, you have all the necessary safety precautions in place.")
  
  adCost = 4
  gv.advertisements[2] = adds.new( "Pro Windmills", adCost )
      gv.advertisements[2]:setEffect( "Costs $" .. adCost .." per month. \nAre those anti-windmillists causing trouble for you?" ..  
      " Hire this ad and it will show " .. 
      "them how lucky they are to have a energy-generating machine in their backyard.")

--  gv.advertisements[3] = adds.new( "Pro Hydro", 3 )
--  gv.advertisements[3]:setEffect("Advertise what the world would be like without hydro power and all the perks it bring us. " ..
--   " Yeah some land gets a little wet but hey, fish have to live somewhere too right")
  
  adCost = 4
  gv.advertisements[3] = adds.new( "Fossil Power", adCost )
  gv.advertisements[3]:setEffect( "Costs $" .. adCost .." per month. \nYes fossil fueled power plants pollute" ..
   " the planet on massive scales and are no " .. 
  "friend to wildlife, but it's cheap and effective. You want the cost of energy to be 10 times what it is now. That's " ..
   "what it would be without fossil fuels.")
  
  gv.advertisements[4] = adds.new( "Public Appeal", adCost )
  gv.advertisements[4]:setEffect("Costs $" .. adCost .." per month. \nIs the population upset with you?" .. 
   " Are they complaining about your capability to provide power? " .. 
    "I'll calm the public down and show them that creating energy is no easy task.")

  gv.publicServises = {}
  gv.servisCounter = 8
  
  local publicServisCost = 6
  gv.publicServises[0] = publicServises.new("Geologist",publicServisCost)
  gv.publicServises[0]:setAbout("\nCosts $" .. publicServisCost .. " per month\nAre you hitting blanks trying to get the " ..
  "resources you need? Tired of wasting money? Hire a Geologist to find what tiles hold. Give her some time to work " .. 
  "and she will get back to you with some information. Say good bye to guessing.")

  publicServisCost = 6
  gv.publicServises[1] = publicServises.new("Fossil Fuel Advances",publicServisCost)
  gv.publicServises[1]:setAbout("\nCosts $" .. publicServisCost .. " per month\nInvest in research in the fossil fuels."
  .. " If successful you will discover information " .. 
  "that will make your fossil fueled power plants more efficient, which could possibly increase power generation " .. 
  " or reduce maintenance. Be careful though as you make advancements it becomes harder to make more.")
      
      
  gv.publicServises[2] = publicServises.new("Nuclear Advances",publicServisCost)  
  gv.publicServises[2]:setAbout("\nCosts $" .. publicServisCost .. " per month\nInvest in research in nuclear reactors."
  .. " If successful you will discover information " .. 
  "that will make nuclear power plants more efficient, which could possibly increase power generation " .. 
  " or reduce maintenance. Be careful though as you make advancements it becomes harder to make more.")
  
  publicServisCost = 4 
  gv.publicServises[3] = publicServises.new("Wind Advances",publicServisCost)
  gv.publicServises[3]:setAbout("\nCosts $" .. publicServisCost .. " per month\nInvest in research in windmills."
  .. " If successful you will discover information " .. 
  "that will make your windmills more efficient, which increases power generation. You can't really reduce maintenance cost. " .. 
  "Be careful though as you make advancements it becomes harder to make more.")
  
  
  gv.publicServises[4] = publicServises.new("Solar Advances",publicServisCost)
  gv.publicServises[4]:setAbout("\nCosts $" .. publicServisCost .. " per month\nInvest in research in solar panels."
  .. " If successful you will discover information " .. 
  "that will make your solar panels more efficient, which increases power generation. You can't really reduce maintenance. " .. 
  "Be careful though as you make advancements it becomes harder to make more.")
  
  publicServisCost = 8
  gv.publicServises[5] = publicServises.new("Hydro Advances",publicServisCost)
  gv.publicServises[5]:setAbout("\nCosts $" .. publicServisCost .. " per month\nInvest in research in dams."
  .. " If successful you will discover information " .. 
  "that will make dams more efficient, which possibly increases power generation " .. 
  " or reduces maintenance. Be careful though as you make advancements it becomes harder to make more.")
  
  publicServisCost = 6
  gv.publicServises[6] = publicServises.new("Generator Advances",publicServisCost)
  gv.publicServises[6]:setAbout("\nCosts $" .. publicServisCost .. " per month\n"
  .. "Generators are at the heart of all forms of power except solar. If successful you will discover information " .. 
  "that will make all forms of power more efficient by a little bit. Increasing power generation of all types of" .. 
  " power except solar. Be careful though as you make advancements it becomes harder to make more.")
  
  publicServisCost = 6
  gv.publicServises[7] = publicServises.new("Corrupt Environmentalists",publicServisCost)
  gv.publicServises[7]:setAbout("\nCosts $" .. publicServisCost .. " per month\nAre those environmentalists groups giving " .. 
  "you a hard time? It's time to infiltrate their ranks and take a load off your back. Hire someone to go behind enemy lines " .. 
  "and convince the environmentalists to give you a break\n\n\n")
  gv.foundResourses = {}

  for x = 0, 23,1 do
    gv.foundResourses[x] = -1
  end

  gv.publicServisText = {}

  for x =0, gv.servisCounter, 1 do
    gv.publicServisText[x] = ""
  end

  gv.blackoutLengthCounter = 0 -- the length of the blackout in number of months
  gv.blackoutCounter = 0       -- a counter holding the number of total blackouts that has occured
  gv.blackoutLengthSum = 0
  gv.blackoutAmountRate = 5
  gv.blackoutTimeRate   = 3    -- this varible and the one above represents the rate of blackouts. 5 blackouts in 3 years
  -- gv.blackoutTimes hold a two D array of all the blackouts within the blackout rate. In this case 5 blackouts in 3 years
  -- index 1: start year; index 2 start month; index 3 length in months
  gv.blackoutTimes = {}
  
  gv.buttonR = 0/255
  gv.buttonG = 128/255
  gv.buttonB = 255/255
  
  gv.buttonOver1 = 0
  gv.buttonOver2 = 0
  gv.buttonOver3 = 0
  gv.buttonOver4 = 0.5   
  
end

local function swapBlackoutButton(path, stopTimer)

    local temp = btnBlackout
    if(btnBlackout ~= nil) then
      gv.stage:remove(btnBlackout)
    end
    
    if (stopTimer and blackoutSwap ~= nil) then
        timer.cancel(blackoutSwap)
        blackoutSwap = nil
    end
    
    buildBlackoutButton(path)    
end


local function gettingCloseToBlackout(file)
  
  if (file) then
      swapBlackoutButton("Images/static_screen/st_lightbulb2.png", false)
  else
      swapBlackoutButton("Images/static_screen/st_lightbulb.png", false)
  end
  
  blackoutSwap = timer.performWithDelay(500,function() gettingCloseToBlackout( not file) end )
end

function returnToMainMenuFromGameOver( event )

    if ( event.phase == "ended" ) then
        
        composer.gotoScene("menu")       
        composer.removeHidden()                                
        cancelTimers()
        initalize()                 
        composer.removeScene("mining")
    end
end

function  returnToMainMenu( event )

    if ( event.phase == "ended" ) then
        
        composer.gotoScene("menu")       
        composer.removeHidden()                
        removeStage()        
        cancelTimers()
        initalize()                 
        composer.removeScene("mining")
    end
end

function newGameFromGameOver( event )

    if (event.phase == "ended" ) then            
        returnToMainMenuFromGameOver( event )        
        composer.gotoScene("mining")    
        startingPower()
        composer.gotoScene("city")
    end

end

function newGame( event )

    if (event.phase == "ended" ) then
            
        returnToMainMenu( event )        
        composer.gotoScene("mining")    
        startingPower()
        composer.gotoScene("city")
    end

end

function cancelTimers()

  timer.cancel(gv.monthTimer)
  timer.cancel(gv.secondsTimer)

end

function pause()
  timer.pause(gv.monthTimer)
  timer.pause(gv.secondsTimer)
end


function resume()
  timer.resume(gv.monthTimer)
  timer.resume(gv.secondsTimer)
end

function alterDemand(shouldBeAltered)

  if(shouldBeAltered) then
    gv.demandFactor = 1
  else
    gv.demandFactor = 1.2
  end

end


function setMoney()

  MB:setLabel("$ "..math.round( gv.money))
end


function calcPowerDemanded()

  -- this function results in a max of 1.4 and a min of 1. Max occures in july.
  -- min accures in jan
  local pdConstant = math.sin((monthCounter-4) * (math.pi/6)) *0.1 + 1.2
  
  -- power demanded = population + a little more for businesses and such
  gv.powerDemanded = math.round ( 10*(gv.population*pdConstant/1000) )/10 --1.2
  
end

function centerY(height)
  return (display.contentHeight-height)/2
end


function centerX(width)
  return (display.contentWidth-width)/2
end

function goToScreen(destination)


  if gv.screen ~= destination then
    gv.screen = destination
    print(destination)
    composer.gotoScene(destination)
  end
end

local function buildStaticBG()

  h = 120
  w = 175

  stcBG = widget.newButton
    {
      width       = w,
      height      = h,
      defaultFile = "Images/static_screen/st_UICorner.png",
      id          = "stcBG",
      left        = 0,
      top         = display.contentHeight - h
  }
  
  local mask = graphics.newMask( "Images/static_screen/st_UICorner_mask.png" )
  local xScale = stcBG.width/1024
  local yScale = stcBG.height/512
  
  stcBG:setMask( mask )
  stcBG.maskScaleX = xScale
  stcBG.maskScaleY = yScale
  stcBG.maskX = stcBG.width/2
  stcBG.maskY = stcBG.height/2

  stcBG:setEnabled( false )
  gv.stage:insert( stcBG )

end


local function buildScreenButtons()

  local buttonFactorY = display.contentHeight - h + 8
  local buttonFactorX = 5

  -- this is the resourse screen button
  btnRS = widget.newButton
    {
      width       = circleWidth,
      height      = circleHeight,
      id          = "rs",
      defaultFile = "Images/static_screen/st_map.png",
      top         = buttonFactorY,
      left        = buttonFactorX,
      onEvent     = function() return goToScreen("resourseMap") end,
  }

  buttonFactorY = buttonFactorY + 15
  buttonFactorX = buttonFactorX + 35

  --This is the Land screen button
  btnLND = widget.newButton
    {
      width       = circleWidth,
      height      = circleHeight,
      defaultFile = "Images/static_screen/st_land.png",
      id          = "land",
      onEvent     = function() return goToScreen("land") end,
      top         = buttonFactorY,
      left        = buttonFactorX
  }

  buttonFactorY = buttonFactorY + 20
  buttonFactorX = buttonFactorX + 35

  --This is the power plant screen button
  btnPP = widget.newButton
    {
      width       = circleWidth,
      height      = circleHeight,
      defaultFile = "Images/static_screen/st_plant.png",
      id          = "plant",
      top         = buttonFactorY,
      left        = buttonFactorX,
      onEvent     = function() return goToScreen("innerWorkings") end,
  }


  buttonFactorY = buttonFactorY + 20
  buttonFactorX = buttonFactorX + 30

  --This is the city screen button
  btnCY = widget.newButton
    {
      width       = circleWidth,
      height      = circleHeight,
      id          = "city",
      defaultFile = "Images/static_screen/st_city.png",
      top         = buttonFactorY,
      onEvent     = function() return goToScreen("city") end,
      left        = buttonFactorX
  }

  buttonFactorY = buttonFactorY + 25
  buttonFactorX = buttonFactorX + 25

  --This is the busness screen button
  btnBNS = widget.newButton
    {
      width       = circleWidth,
      height      = circleHeight,
      defaultFile = "Images/static_screen/st_business.png",
      id          = "BS",
      top         = buttonFactorY,
      left        = buttonFactorX,
      onEvent     = function() return goToScreen("busness") end,
  }

  gv.stage:insert(btnBNS)
  gv.stage:insert(btnCY)
  gv.stage:insert(btnPP)
  gv.stage:insert(btnLND)
  gv.stage:insert(btnRS)

end


local function pausedPressed(event)

  if ( event.phase == "began") then
    if (isPaused) then
      changePauseImage("Images/static_screen/st_pause.png")
      resume()
      isPaused = false
    else
      changePauseImage("Images/static_screen/st_play.png")
      isPaused = true
      pause()
    end
  end
end


local function fastForward( event )
  
    if ( event.phase == "ended" ) then
        
        if (gv.month == 5000 ) then
            gv.month = 2500
            changeFastForwardButton("Images/static_screen/st_FF_Green.png")
            print("fast forward being called")
        else
            gv.month = 5000
            changeFastForwardButton("Images/static_screen/st_fastforward.png")
        end     
    end

end

function changeFastForwardButton(imagePath)

  local x = weather.x - weather.width/2

  gv.stage:remove( weather )

  weather = widget.newButton
    {
      width       = circleWidth,
      height      = circleHeight,
      defaultFile = imagePath,
      id          = "weather",
      top         = timeBar.y - circleHeight*0.5,
      left        = x,
      onEvent     = fastForward,
  }
  gv.stage:insert(weather)
    

end

function changePauseImage(imagePath)

  local x = btnPausePlay.x - btnPausePlay.width/2

  gv.stage:remove( btnPausePlay )

  btnPausePlay = widget.newButton
    {

      width       = circleWidth,
      height      = circleHeight,
      defaultFile = imagePath,
      id          = "pausePlay",
      top         = timeBar.y - circleHeight*0.5,
      left        = x,
      onEvent     = pausedPressed,
  }

  gv.stage:insert(btnPausePlay)

end


local function showMenu( event )

  if (event.phase == "began") then    
    composer.showOverlay("inGameMenu")
  end

end

local function buildMenu()

  local menuFactorY = display.contentHeight - h + 55

  btnMenu = widget.newButton
    {
      width     = 75,
      height    = 30,
      defaultFile = "Images/static_screen/st_menu.png",
      id        = "btnMenu",
      left      = 5,
      top       =  menuFactorY,
      onEvent   = showMenu
  }
  gv.stage:insert( btnMenu )

end


local function showMoneyData( event )

  if (event.phase == "began") then
    composer.showOverlay("moneyData")
  end

end

local function buildMoneyBar()

  moneyBarFactorY = display.contentHeight - 30

  MB = widget.newButton
    {
      width         = stcBG.width*0.4,
      height        = 20,
      labelAlign    = "left",
      shape         = "roundedRect",
      cornerRadius  = 10,
      fillColor     = { default={ 0, 1, 0, 1 }, over={ 1, 0.2, 0.5, 1 } },
      id            = "btnMB",
      left          = 5,
      label         = "$ ",
      top           =  moneyBarFactorY,
      onEvent       = showMoneyData
  }

  setMoney()
  gv.stage:insert( MB )
end

local function showBlackoutData( event ) 

    if ( event.phase == "ended" ) then
        composer.showOverlay("blackoutInfo")    
    end

end

function buildBlackoutButton(path)
    
    btnBlackout = widget.newButton
    {
      width       = circleWidth,
      height      = circleHeight,
      defaultFile = path,
      id          = "plant",
      top         = MB.y - (MB.height/2)*1.3,
      left        = MB.x + (MB.width/2)*1.1,
      onEvent     = showBlackoutData
    }

   gv.stage:insert( btnBlackout )

end


local function buildDataBar()

  -- w is the width of the static BG
  dataBarX = display.contentWidth - w +5
  local dataBoxShift = w + 10
  local dataBoxWidth = ((dataBarX/3) - 20)
  local dataBoxHeightPos = 17
  local datatBarColour = 68/255
  local dataBoxColour = 224/255  
  local dataBoxTextR = 0/255
  local dataBoxTextG = 128/255
  local dataBoxTextB = 255/255

  dataBar = widget.newButton
    {
      width     = dataBarX,
      height    = 30,
      shape     = "rect",
      fillColor = { default={ datatBarColour, datatBarColour,datatBarColour, 1 }, over={ 1, 0.2, 0.5, 1 } },
      id        = "DB",
      left      =  w - 4,
      top       =  display.contentHeight -20
  }

  dataBox1 = widget.newButton
    {
      height    = 15,
      width     = dataBoxWidth,
      shape     = "roundedRect",
      cornerRadius = 5,
      fillColor = { default={ dataBoxColour, dataBoxColour, dataBoxColour, 1 }, over={ 1, 0.2, 0.5, 1 } },
      labelColor = { default={ dataBoxTextR, dataBoxTextG, dataBoxTextB }, over={ 0, 0, 0, 0.5 } },
      id        = "dataBox1",
      left      =  dataBoxShift,
      fontSize  = 10,
      top       =  display.contentHeight - dataBoxHeightPos

  }

  dataBoxShift = dataBoxShift + 15 + dataBoxWidth

  dataBox2 = widget.newButton
    {
      height    = 15,
      width     = dataBoxWidth,
      shape     = "roundedRect",
      cornerRadius = 5,
      fillColor = { default={ dataBoxColour, dataBoxColour, dataBoxColour, 1 }, over={ 1, 0.2, 0.5, 1 } },
      labelColor = { default={ dataBoxTextR, dataBoxTextG, dataBoxTextB }, over={ 0, 0, 0, 0.5 } },
      id        = "dataBox2",
      left      =  dataBoxShift,
      fontSize  = 10,
      top       =  display.contentHeight - dataBoxHeightPos

  }

  dataBoxShift = dataBoxShift + 15 + dataBoxWidth

  dataBox3 = widget.newButton
    {
      height    = 15,
      width     = dataBoxWidth,
      shape     = "roundedRect",
      cornerRadius = 5,
      fillColor = { default={ dataBoxColour, dataBoxColour, dataBoxColour, 1 }, over={ 1, 0.2, 0.5, 1 } },
      labelColor = { default={ dataBoxTextR, dataBoxTextG, dataBoxTextB }, over={ 0, 0, 0, 0.5 } },
      id        = "dataBox3",
      left      =  dataBoxShift,
      fontSize  = 10,
      top       =  display.contentHeight - dataBoxHeightPos
  }

  dataBox1:setEnabled( false )
  dataBox2:setEnabled( false )
  dataBox3:setEnabled( false )
  dataBar:setEnabled( false )
  gv.stage:insert( dataBar )
  gv.stage:insert( dataBox1)
  gv.stage:insert( dataBox2)
  gv.stage:insert( dataBox3)

end


local function buildToolBar()

  local TBwidth         = display.contentWidth*0.32
  local TBheight        = TBwidth*0.17     
  local toolBarFactorX  = display.contentWidth-TBwidth

  -- Tool bar Background
  TBBG = widget.newButton
    {
      width     = TBwidth,
      height    = TBheight,
      defaultFile = "Images/static_screen/st_dateControl.png",
      id        = "btnTB",
      left      = toolBarFactorX,
      top       = 0
  }

  -- The section that will hold the month and year
  timeLabel = widget.newButton
    {
      width         = TBwidth *0.9,
      height        = TBheight*0.75,
      shape         = "roundedRect",
      cornerRadius  = 6,
      labelColor = { default = {gv.fontColourR, gv.fontColourG, gv.fontColourB} },
      id            = "time",
      fillColor     = { default={ 0.5, 0, 0, 1 }, over={ 0.5, 0, 0.5, 0 } },
      label         = "January",
      top           = 2,
      left          = toolBarFactorX + 10
  }
  
  local timeBarWidth = TBwidth*0.57
  local timeBarHeight = 30
  
  timeBar = widget.newButton
    {
      width     = timeBarWidth,
      height    = timeBarHeight,
      defaultFile = "Images/static_screen/st_speedControl.png",      
      left      = display.contentWidth - timeBarWidth,
      top       = TBBG.y + TBheight/2,
  }
  

  -- the fast forward icon
  weather = widget.newButton
    {
      width       = circleWidth,
      height      = circleHeight,
      defaultFile = "Images/static_screen/st_fastforward.png",
      id          = "weather",
      top         = timeBar.y - circleHeight*0.5,
      left        = timeBar.x - timeBarWidth/3,
      onEvent     = fastForward,
  }


  -- The pause/play button. When pause is pressed it will turn into the play button.
  btnPausePlay = widget.newButton
    {

      width       = circleWidth,
      height      = circleHeight,
      defaultFile = "Images/static_screen/st_pause.png",
      id          = "pausePlay",
      top         = timeBar.y - circleHeight*0.5,
      left        = timeBar.x + timeBarWidth/7,
      onEvent     = pausedPressed,
  }


  TBBG:setEnabled( false )
  timeLabel:setEnabled( false )  

  gv.stage:insert( TBBG )
  gv.stage:insert(timeBar)
  gv.stage:insert( timeLabel )
  gv.stage:insert( weather )
  gv.stage:insert( btnPausePlay )

end

local function productionFunction(passing, specs)

  gv.powerSupplied = gv.powerSupplied + passing* specs:getProduces()

  math.round (gv.powerSupplied)

end

local function calculateMaintenenceCost(pass,specs)

  return specs:getMaintenenceCost()*pass
end


-- should doc resources depending on how many plants are built
local function docResources()

  gv.powerSupplied = 0
  local docMoney = 0
  -- coal

  local pass = 0
  local consumption = gv.coalSpecs:getConsumption()

  for i = 1,gv.coalBuildCounter,1 do

    if (gv.resourcesHeld[2]-consumption >= 0) then
      gv.resourcesHeld[2] = gv.resourcesHeld[2]-consumption
      pass = pass +1
    else
      break
    end
  end

  productionFunction(pass, gv.coalSpecs)
  docMoney = docMoney + calculateMaintenenceCost(pass,gv.coalSpecs)


  -- gas

  pass = 0
  consumption = gv.gasSpecs:getConsumption()

  for i = 1, gv.gasBuildCounter, 1 do

    if (gv.resourcesHeld[1]-consumption >= 0) then
      gv.resourcesHeld[1] = gv.resourcesHeld[1]-consumption
      pass = pass +1
    else
      break
    end
  end

  productionFunction(pass, gv.gasSpecs)
  docMoney = docMoney + calculateMaintenenceCost(pass,gv.gasSpecs)

  -- oil
  pass = 0
  consumption = gv.oilSpecs:getConsumption()

  for i = 1,gv.oilBuildCounter,1 do

    if (gv.resourcesHeld[0]-consumption >= 0) then
      gv.resourcesHeld[0] = gv.resourcesHeld[0]-consumption
      pass = pass +1
    else
      break
    end
  end

  productionFunction(pass,gv.oilSpecs)
  docMoney = docMoney + calculateMaintenenceCost(pass,gv.oilSpecs)

  -- nuclear
  pass = 0
  consumption = gv.nuclearSpecs:getConsumption()

  for i = 1,gv.nuclearBuildCounter,1 do

    if (gv.resourcesHeld[3]-consumption >= 0) then
      gv.resourcesHeld[3] = gv.resourcesHeld[3]-consumption
      pass = pass +1
    else
      break
    end
  end

  productionFunction(pass,gv.nuclearSpecs)
  docMoney = docMoney + calculateMaintenenceCost(pass,gv.nuclearSpecs)

  --solar
  productionFunction(gv.solarBuildCounter,gv.solarSpecs)
  docMoney = docMoney + calculateMaintenenceCost(gv.solarBuildCounter, gv.solarSpecs)

  --wind
  productionFunction(gv.windBuildCounter,gv.windSpecs)
  docMoney = docMoney + calculateMaintenenceCost(gv.windBuildCounter, gv.windSpecs)

  --Hydro

  for i = 0,gv.hydroCounter - 1,1 do      
    if( gv.rivers[i]:getBuilt() ) then
        print("Damn ".. i .. "got triggered")
      gv.powerSupplied = gv.powerSupplied + gv.rivers[i]:getPowerGenerated()
      docMoney = docMoney + gv.rivers[i]:getMainteneceCost()
      
    end
  end

  gv.money = gv.money -docMoney
  setMoney()
  gv.powerSupplied = math.round (gv.powerSupplied *10)/10

end


function buildStaticScreen() 
  gv.stage = display.getCurrentStage()
  buildStaticBG()
  buildScreenButtons()
  buildMenu()
  buildMoneyBar()
  buildBlackoutButton("Images/static_screen/st_lightbulb.png")
  buildDataBar()
  buildToolBar()
end


function advertisementFee()

  local temp = 0

  for i = 0, gv.addCounter - 1,1 do
    if( gv.advertisements[i]:getBought() ) then
      temp = temp + gv.advertisements[i]:getCost()
    end
  end

  return temp

end


function publicServisFee()

  local minus = 0

  for i = 0, gv.servisCounter-1, 1 do

    if (gv.publicServises[i]:getBought()) then
      minus = minus + gv.publicServises[i]:getCost()      
    end
  end

  return minus


end

local function calculateMoney()


  local moneyMade = 0

  if (gv.powerDemanded > gv.powerSupplied ) then
    moneyMade = 0
  else
    moneyMade = math.round(gv.powerDemanded*gv.moneyMadeFactor)
  end

  gv.money = gv.money + moneyMade

  local addFee = advertisementFee()
  local publicServisFee = publicServisFee()

  gv.money = gv.money - publicServisFee
  gv.money = gv.money - addFee
  setMoney()

end


local function isResearched(index)

  for x = 0, 23, 1 do

    if (gv.foundResourses[x] == index ) then
      return true
    end
  end

  return false
end


local function geologist()


  -- 50% 2 tiles are found
  -- 10% 3 tiles are found
  -- 40% 1 tile is found

  local numberOfTilesToBeFound = 0
  local randomNumber = math.random(1,100)
  local justFound = ""

  if (randomNumber <= 50 ) then
    numberOfTilesToBeFound = 2
  elseif (randomNumber > 50 and randomNumber <= 60 ) then
    numberOfTilesToBeFound = 3
  else
    numberOfTilesToBeFound = 1
  end

  local index = 0

  while ( numberOfTilesToBeFound > 0 and numberOfTilesMined() <= (24 - numberOfTilesToBeFound) ) do

    index = math.random(0,23)

    if( isMined(index) == false and isResearched(index) == false) then

      for x = 0, 23,1 do
        if (gv.foundResourses[x] == -1 ) then
          gv.foundResourses[x] = index
          justFound = justFound .. tostring(index + 1) ..", "
          break
        end
      end

      numberOfTilesToBeFound = numberOfTilesToBeFound - 1
    end

  end

  return justFound
end


local function corruptEnvirmentalists()

  --gv.money = gv.money - 10
  gv.groups[0]:setStatus(3)

end

local function checkPublicServisPercent()

  local randomNumber = math.random(1,10)
  local pass = false

  for x = 0, gv.servisCounter -1, 1 do  
    if( gv.publicServises[x]:getBought() and gv.publicServises[x]:calculatePassFail() ) then
      pass = true
      if(x == 0 ) then

        local text = geologist()
        if(text == "") then
          gv.publicServisText[0] = " there are no more resources for us to find. You should fire the " ..
            "geologist"
        else
          gv.publicServisText[0] = " The Geologist you hired found resources in tiles " .. text ..
            "take at the mining screen to see what was found"
        end


      elseif (x == 1) then

        if (randomNumber > 5) then
          gv.coalSpecs:setMaintenenceCost( gv.coalSpecs:getMaintenenceCost() - 1)
          gv.gasSpecs:setMaintenenceCost( gv.gasSpecs:getMaintenenceCost() - 1)
          gv.oilSpecs:setMaintenenceCost( gv.oilSpecs:getMaintenenceCost() - 1)
          gv.publicServisText[1] = "Due to improvements in technology the maintenence cost " ..
            " of all fossile fueled power plants has decreased by 1"
        else
          gv.gasSpecs:setProduction(gv.gasSpecs:getProduction() + 1)
          gv.coalSpecs:setProduction(gv.coalSpecs:getProduction() + 1)
          gv.oilSpecs:setProduction(gv.oilSpecs:getProduction() + 1)
          gv.publicServisText[1] = "Due to improvements in technology " ..
            "all fossile fueled power plants now produce 1 GW more power"
        end

        -- inform user of change

      elseif ( x == 2 ) then

        if ( randomNumber > 5) then
          gv.nuclearSpecs:setMaintenenceCost(gv.nuclearSpecs:getsetMaintenenceCost() - 1)
          gv.publicServisText[2] = "Due to improvements in technology the maintenence cost " ..
            " of all nuclear power plants has decreased by 1"
        else
          gv.nuclearSpecs:setProduction(gv.nuclearSpecs:getProduces() + 0.7)
          gv.publicServisText[2] = "Due to improvements in technology " ..
            "all nuclear power plants now produce 0.7 GW more power"
        end
      elseif ( x == 3 ) then

        gv.windSpecs:setProduction(gv.windSpecs:getProduces() + 0.3)
        gv.publicServisText[3] = "Due to improvements in technology " ..
          "all windmills have become more efficient and produce 0.3 GW more power"

      elseif ( x == 4 ) then

        gv.solarSpecs:setProduction(gv.solarSpecs:getProduces() + 0.3)
        gv.publicServisText[4] = "Due to improvements in technology " ..
          "all solar panals have become more efficient and produce 0.3 GW more power"
      elseif ( x == 5) then

        if ( randomNumber > 5) then
          gv.hydroSpecs:setMaintenenceCost(gv.hydroSpecs:getsetMaintenenceCost() - 1)
          gv.publicServisText[5] = "Due to improvements in technology the maintenence cost " ..
            " of all hydro power plants has decreased by 1"
        else
          gv.hydroSpecs:setProduction(gv.hydroSpecs:getProduces() + 0.5)
          gv.publicServisText[5] = "Due to improvements in technology " ..
            "all hydro plants have become more efficient and produce 0.5 GW more power"
        end
      elseif ( x == 6) then

        gv.gasSpecs:setProduction(gv.gasSpecs:getProduces() + 0.2)
        gv.coalSpecs:setProduction(gv.coalSpecs:getProduces() + 0.2)
        gv.oilSpecs:setProduction(gv.oilSpecs:getProduces() + 0.2)
        gv.hydroSpecs:setProduction(gv.hydroSpecs:getProduces() + 0.2)
        gv.windSpecs:setProduction(gv.windSpecs:getProduces() + 0.2)
        gv.nuclearSpecs:setProduction(gv.nuclearSpecs:getProduces() + 0.2)
        gv.publicServisText[6] = "Due to your investment in researching more efficient generators " ..
          "all energy sources except solar panels produce an extra 0.2 GW of power"
      elseif ( x == 7) then
        corruptEnvirmentalists()
        gv.publicServisText[7] = " You have been successful in briding the envirmentalists to get off your back " ..
          "for all intence of purposes thier happyness with you has increased"
      end

      local options = {
        isModal = true
      }

      composer.showOverlay("advancements", options)
    end
  end
end

local function calculateYearDifferene(index)

  local yearDiff = gv.year - gv.blackoutTimes[index][1]
  local monthDiff = gv.month - gv.blackoutTimes[index][2]

  if (monthDiff  < 0 ) then
    yearDiff = yearDiff - 1
    monthDiff = -1*MonthDiff
  end

  return yearDiff
end

local function gameOver()

  pause()
  gv.gameOver = true
  gv.monthCounter = monthCounter -1
  removeStage()
  composer.gotoScene("gameOver")
  
end

local function addBlackoutTime()

  trimBlackoutRateArray()  

  -- insert new blackout time
  if(#gv.blackoutTimes >= 5) then
      gameOver()
  else
    timeData = {startBlackoutTimeYear, startBlackoutTimeMonth, gv.blackoutLengthCounter}
    table.insert(gv.blackoutTimes,timeData)      
  end

  gv.blackoutLengthSum = 0
  for x = 1, #gv.blackoutTimes, 1 do
    gv.blackoutLengthSum = gv.blackoutTimes[x][3] + gv.blackoutLengthSum
  end

end


function trimBlackoutRateArray()

    -- wipes out any blackouts outside of the time range       
  for x = #gv.blackoutTimes, -1 do    
    if( calculateYearDifferene(x) > gv.blackoutTimeRate ) then
      table.remove(gv.blackoutTimes, x)
    end  
  end

end

local function isBlackout()

  if (gv.powerDemanded > gv.powerSupplied) then   -- there is a blackout
    swapBlackoutButton( "Images/static_screen/st_lightbulb3.png",true )
    gv.blackoutLengthCounter = gv.blackoutLengthCounter + 1
    gv.blackoutCounter = gv.blackoutCounter + 1
    gv.groups[2]:setStatus(-0.5)

    if(gv.blackoutLengthCounter >= 10) then   -- blackout has lasted longer then 10 months straight
        gameOver()
    elseif ( #gv.blackoutTimes == 4 ) then -- 4 blackouts have happened. this is the fifth. game over
        gameOver()    
    elseif (gv.blackoutLengthCounter == 1) then --blcakout just started
      startBlackoutTimeYear = gv.year
      startBlackoutTimeMonth = gv.month
      gv.groups[2]:setStatus(-0.5)      
    end

    if ( gv.blackoutLengthSum + gv.blackoutLengthCounter >= 12) then
        gameOver()
    end

  else

    if(gv.blackoutLengthCounter ~= 0) then
      addBlackoutTime()
      gv.blackoutLengthCounter = 0
    end

  end
end

local function inDept()
  
  if (gv.money <= -100) then
      gameOver()
  end
end

local function checkGroupActionPercent()

  local spaceArray = {}
  local percent = math.random(1,1000)/10

  for x = 0, gv.groupCounter -1, 1 do
    spaceArray[x] = x*10
  end


  for x = 0, gv.groupCounter -1, 1 do

    if (percent < spaceArray[x] + gv.groups[x]:getActionPercent() and
      percent > spaceArray[x]) then

      if(x == 0) then
        if (gv.groups[0]:getNumberStatus() > 0) then
          gv.coalSpecs:addMaintenenceCost(-1)
          gv.oilSpecs:addMaintenenceCost(-1)
          gv.gasSpecs:addMaintenenceCost(-1)
          gv.nuclearSpecs:addMaintenenceCost(-1)
          for k = 0, gv.hydroCounter -1, 1 do
            gv.rivers[k]:addMaintenenceCost(-1)
          end
        else
          gv.coalSpecs:addMaintenenceCost(1)
          gv.oilSpecs:addMaintenenceCost(1)
          gv.gasSpecs:addMaintenenceCost(1)
          gv.nuclearSpecs:addMaintenenceCost(1)
          for k = 0, gv.hydroCounter -1, 1 do
            gv.rivers[k]:addMaintenenceCost(1)
          end
        end

      elseif (x == 1) then

        if ( gv.groups[1]:getNumberStatus() > 0 ) then
          gv.nuclearSpecs:addMaintenenceCost(-2)
        else
          gv.nuclearSpecs:addMaintenenceCost(2)
        end

      elseif (x == 2) then
        -- this is for the population group, thinking this should be taken out and replaced in the blackout Method
        if ( gv.groups[2]:getNumberStatus() > 0 ) then
              -- do nothing as there is no benifit from this group
        else
          gv.money = gv.money - populationFine
        end

      elseif (x == 3) then

        if ( gv.groups[3]:getNumberStatus() > 0 ) then
          gv.windSpecs:setCost(gv.windSpecs:getCost() - 5)
        else
          gv.windSpecs:setCost(gv.windSpecs:getCost() + 5)
          gv.money = gv.money - 10
          setMoney()
        end

      end

      local options = {
        isModal = true
      }

      gv.groupActionWinner = x
      composer.showOverlay("groupAction", options)

      break

    end
  end

end

local function populationAction()

    -- Currently there is a five percent chance that the population mood increases  
    local  n = math.random(1,100)
    
    if ( n >= 1 and n <= 5 ) then
         return true
     else
        return false
    end

end

-- Responcible for the month/year timer
local function timerFunction(event)
  
  if (gv.gameOver) then
      --do nothing 
  else
      monthCounter = monthCounter + 1 
                 
      if monthCounter == 13 then
        gv.year = gv.year + 1
        --gv.population = populationFunction(gv.year)
        gv.monthlyPopulationIncrease = calculateMonthlyPopulationIncrease()
        monthCounter = 1
        
        if (gv.year > 2004 and (#gv.blackoutTimes == 2 or #gv.blackoutTimes == 1) ) then
            gv.groups[2]:setStatus(0.5)
        elseif (gv.year > 2005 and #gv.blackoutTimes == 0 and populationAction()) then
            gv.groups[2]:setStatus(1)
        end

      end
      
      timeLabel:setLabel(month[monthCounter] .. " " .. gv.year)
    
      gv.population = gv.population + gv.monthlyPopulationIncrease
      docResources()
      calculateMoney()
      calcPowerDemanded()
      isBlackout()
      
      local dif = gv.powerSupplied - gv.powerDemanded
      -- if getting close to a blackout. Flash the lightbulb at the user
      if(dif < 0.8 and dif >=0 ) then
          gettingCloseToBlackout(true)
      elseif(dif >= 0.8) then
          swapBlackoutButton( "Images/static_screen/st_lightbulb.png",true)    
      end
      
      checkPublicServisPercent()
      if (gv.year > 2000) then    
          checkGroupActionPercent()
      end
      showData()
      inDept()
    
      if(gv.onCityScreen) then
        setDataBox("Population", gv.population, 1)        
        setDataBox("Demanded", gv.powerDemanded.."GW", 2)
        setDataBox("Supplied", gv.powerSupplied.."GW", 3)
      end
    
      gv.monthTimer = timer.performWithDelay(gv.month,timerFunction)
  end
end


-- Responcible for the seconds counter to telll how long the user
-- has played for
local function secondsCounter(event)

  gv.seconds = gv.seconds + 1  
end


-- Setting up timers
function timeStart()

  gv.yearTimer    = timer.performWithDelay(1, timerFunction)
  gv.secondsTimer = timer.performWithDelay(1000, secondsCounter, -1)

end


function setDataBox(title, message, number)

  if number == 1 then
    dataBox1:setLabel(title .. ": ".. message)
  elseif number == 2 then
    dataBox2:setLabel(title .. ": ".. message)
  elseif number == 3 then
    dataBox3:setLabel(title .. ": ".. message)
  else
  -- do nothing
  end
end

function setDataBoxNoColon(title, message, number)

  if number == 1 then
    dataBox1:setLabel(title .. message)
  elseif number == 2 then
    dataBox2:setLabel(title .. message)
  elseif number == 3 then
    dataBox3:setLabel(title .. message)
  else
  -- do nothing
  end
end

function mainSetInnerWorkingsVariable(status)
    onInnerWorkings = status
end

function getInnerWorkingsVariable()

    return onInnerWorkings
end

function returnMovie()
    
    if(onInnerWorkings) then
        revealVideo()
    else
        -- do nothing
    end
end

function shiftMovie()

    if(onInnerWorkings) then
        hideVideo()
    else
        -- do nothing
    end
end


-- used for testing purposes 
function showData()

    print("The envirmentalists are at level " .. gv.groups[0]:getNumberStatus())

end

initalize()
require( "innerWorkings" )
main()
