
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
local monthCounter    = 1
local circleWidth     = 30
local circleHeight    = 30
local MB = widget
local populationVariable = 1.05
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

    return math.round (gv.population*populationVariable)

end


local function calculateMonthlyPopulationIncrease()

   return  math.round ( (populationFunction(year+1)*populationVariable - populationFunction(gv.year))/12) 

end


local function main()

  display.setStatusBar( display.HiddenStatusBar )
  composer.gotoScene("menu")
end

-- Initalizing the global variables 
local function initalize()
  
    local energyPros = "This Fossle Fueled power plant runs off of oil which is abundant and fairly cheap to obtain."..
    "It burns fairly well compared to coal."            
    local energyCons = "Oil has many other purposes other then just fueling power plants. Such as fueling cars and heating homes."..
    "These other uses drain the amount of oil that can be used"    
    local energyCost = 2    
    local energyProduction = 1
    local energyConsumption = 10
    local energyMaintenence = 1
    
    
    gv.stage         = display.getCurrentStage()
    gv.seconds       = 0
    gv.year          = 2000
    gv.month         = 5000 --each month is five seconds
    gv.secondsTimer  = timer
    gv.yearTimer     = timer
    gv.population    = 10000--populationFunction(year)
    gv.onCityScreen  = true
    
    gv.monthlyPopulationIncrease = calculateMonthlyPopulationIncrease()    
    
    gv.demandFactor  = 1.2
    gv.money = 10
    calcPowerDemanded()
    gv.powerSupplied = gv.powerDemanded*1.1    
    gv.screen = "city"
    gv.font = native.systemFont
    gv.fontSize = 8
    gv.resourseAmount = {}
    gv.resourcesHeld = {}
    
    gv.resourcesHeld[0] = 100
    gv.resourcesHeld[1] = 100
    gv.resourcesHeld[2] = 100
    gv.resourcesHeld[3] = 100  
       
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
    
    gv.oilSpecs = powerPlant.new("oil")
    gv.oilSpecs:setCost(energyCost)
    gv.oilSpecs:setProduction(energyProduction)
    gv.oilSpecs:setCons(energyCons)
    gv.oilSpecs:setPros(energyPros)
    gv.oilSpecs:setConsumption(energyConsumption)
    gv.oilSpecs:setMaintenenceCost(energyMaintenence)
    
    -- For Hydro
    gv.rivers = {}
    gv.hydroCounter = 0           
    gv.rivers[0] =  stream.new("Hudson",10,5,10,1)
    gv.rivers[1] =  stream.new("Tidal",20,7,13,1)
    
    local r0Data = "Dams produce clean energy at the expence of destroying large amounts of habital land. " .. 
    "although no gasses are expelled envirmentalists still dislike dams being built"
    
    gv.rivers[0]:setData(r0Data)
    gv.rivers[1]:setData(r0Data)
    
    energyPros = "This Fossil fueled power plant runs off of coal which is the most abundant and energy rich of the fossle fuels."..
    "Coal is cheap and fairly easy to obtain."
    
    energyCons = "Coal puts carbon dioxide into the air and its supplies are not infinite. Envirmentatilist will not"..
    "like you for building this kind of power plant"
    
    energyCost = 3
    energyProduction = 4
    energyConsumption = 12
    
    gv.coalSpecs = powerPlant.new("coal")
    gv.coalSpecs:setCost(energyCost)
    gv.coalSpecs:setProduction(energyProduction)
    gv.coalSpecs:setCons(energyCons)
    gv.coalSpecs:setPros(energyPros)
    gv.coalSpecs:setConsumption(energyConsumption)
    gv.coalSpecs:setMaintenenceCost(energyMaintenence)
    
    energyPros = "This Fossil fueled power plant runs off of gas. Gas is the most expensive of the fossle fuels but burns the cleanest"..
    "and has the lest impact on the atmosphere"    
    energyCons = "There is a finite amount of gas on the planet"
    energyCost = 3
    energyProduction = 4
    energyConsumption = 15
    
    gv.gasSpecs = powerPlant.new("gas")
    gv.gasSpecs:setCost(energyCost)
    gv.gasSpecs:setProduction(energyProduction)
    gv.gasSpecs:setCons(energyCons)
    gv.gasSpecs:setPros(energyPros)
    gv.gasSpecs:setConsumption(energyConsumption)
    gv.gasSpecs:setMaintenenceCost(energyMaintenence)
    
    energyPros = "Nuclear Power is the cleanest of the natural resourses. With uranium being the most abundant it can long outlast fossil fuels"
    energyCons = "Uranium is limited and plants are expensive. Some of the population is scared of nuclear power"
    energyCost = 4
    energyProduction = 8
    energyConsumption = 10
    
    gv.nuclearSpecs = powerPlant.new("nuclear")
    gv.nuclearSpecs:setCost(energyCost)
    gv.nuclearSpecs:setProduction(energyProduction)
    gv.nuclearSpecs:setCons(energyCons)
    gv.nuclearSpecs:setPros(energyPros)
    gv.nuclearSpecs:setConsumption(energyConsumption)
    gv.nuclearSpecs:setMaintenenceCost(energyMaintenence)
    
    energyPros = "Solar power is the only power source that works differently. By turning light into energy there are no envirmental"..
    "consiquences and they are self sustaining. As long as the sun is around, we can have solar power"
    energyCons = "Although well liked, solar panels are expensive and have a low conversion rate of light to energy. This " .. 
    "doesn't make them an ideal source of power for a large population. They also only work during the day."
    energyCost = 7
    energyProduction = 2
    energyConsumption = 0
    
    gv.solarSpecs = powerPlant.new("solar")
    gv.solarSpecs:setCost(energyCost)
    gv.solarSpecs:setProduction(energyProduction)
    gv.solarSpecs:setCons(energyCons)
    gv.solarSpecs:setPros(energyPros)
    gv.solarSpecs:setConsumption(energyConsumption)
    gv.solarSpecs:setMaintenenceCost(0)
    
    energyPros = "Wind power is one of the main natural resources. Running off of flowing air it is capable of producing " .. 
    "clean energy. Windmills will produce power as long as there is moving air so no need to worry about running out of wind. " 
    
    
    energyCons = "Windmills are expensive to build and don't produce a lot of energy compared to fossile fuels so they can not " ..
    "sustain a large population. They also take up large amounts of room. People who live near windmills don't like the noise " .. 
    "contant rotating shadows and view. Windmills cause many bird casulties so bird watchers are no fan as well" 
    
    energyCost = 8
    energyProduction = 3
    energyConsumption = 0
    
    gv.windSpecs = powerPlant.new("wind")
    gv.windSpecs:setCost(energyCost)
    gv.windSpecs:setProduction(energyProduction)
    gv.windSpecs:setCons(energyCons)
    gv.windSpecs:setPros(energyPros)
    gv.windSpecs:setConsumption(energyConsumption)
    gv.windSpecs:setMaintenenceCost(0)        
    
    
    gv.groups = {}    
    gv.groupCounter = 4
    
    gv.groups[0] = organization.new( "Envirmentalists" )
    gv.groups[0]:setAbout("This organization is deticated to protecting the earth and to care for the " .. 
    "envirment. Poluting the atmosphere or destroying the land in any way will generally make this organization " .. 
    "angry with you. It is very hard to keep them happy forever.")
    
    gv.groups[1] = organization.new( "anti-Nuclear" )
    gv.groups[2] = organization.new( "Population" )
    gv.groups[3] = organization.new( "anti_Windmillists" )
    
    gv.nuclearInfluence = 2
    gv.coalInfluence = 3
    gv.gasInfluence = 2
    gv.oilInfluence = 2
    
    
    gv.advertisements = {}
    gv.addCounter = 5
    gv.advertisements[0] = adds.new( "Save Power", 2 )
    gv.advertisements[0]:setEffect("Educate the population to intelligently use power so they don't waste it.".. 
    "This add is useful if you are having trouble keeping up with demand and it makes the envirmentalists happy")
     
    gv.advertisements[1] = adds.new( "Safe Nuclear Power", 3 )
    gv.advertisements[2] = adds.new( "Pro Windmills", 2 )
    gv.advertisements[3] = adds.new( "Pro Hydro", 3 )
    gv.advertisements[4] = adds.new( "Fossil Power", 2 )
    
    gv.publicServises = {}
    gv.servisCounter = 9
    gv.publicServises[0] = publicServises.new("Geologist",4)
    gv.publicServises[0]:setAbout("Hire a Geologist to analise the land and tell you where resourses are. Say goodbye to guessing")
    
    gv.publicServises[1] = publicServises.new("Fossil Fuel Advances",4)
    gv.publicServises[2] = publicServises.new("Nuclear Advances",4)
    gv.publicServises[3] = publicServises.new("Wind Power Advances",3)
    gv.publicServises[4] = publicServises.new("Solar Advances",4)
    gv.publicServises[5] = publicServises.new("Hydro Advances",5)
    gv.publicServises[6] = publicServises.new("Corupt Education",6)
    gv.publicServises[7] = publicServises.new("Generator Advances",3)
    gv.publicServises[8] = publicServises.new("Corrupt Envirmentalists",8) 
              
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
    
    -- power demanded = population + a little more for businesses and such
     gv.powerDemanded = math.round ( 10*(gv.population*1.2/1000) )/10
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

  local stcBG = widget.newButton
  {        
      width       = w,
      height      = h,
      defaultFile = "Images/static_screen/st_UICorner.png",              
      id          = "stcBG",              
      left        = 0,
      top         = display.contentHeight - h                
  }
  
  stcBG:setEnabled( false )  
  gv.stage:insert( stcBG )
  
end


local function buildScreenButtons()

  local buttonFactorY = display.contentHeight - h + 8
  local buttonFactorX = 5  
    
   -- this is the resourse screen button 
   local btnRS = widget.newButton
   {           
      width       = circleWidth,
      height      = circleHeight, 
      id          = "rs",
      defaultFile = "Images/static_screen/st_ff.png",
      top         = buttonFactorY,
      left        = buttonFactorX,
      onEvent     = function() return goToScreen("resourseMap") end, 
   }
   
   buttonFactorY = buttonFactorY + 15
   buttonFactorX = buttonFactorX + 35
   
   --This is the Land screen button
   local btnLND = widget.newButton
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
   local btnPP = widget.newButton
   {
      width       = circleWidth,
      height      = circleHeight,
      defaultFile = "Images/static_screen/st_plant.png",
      id          = "plant",
      top         = buttonFactorY,
      left        = buttonFactorX
   }
   
   
   buttonFactorY = buttonFactorY + 20
   buttonFactorX = buttonFactorX + 30
   
   --This is the city screen button
   local btnCY = widget.newButton
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
   local btnBNS = widget.newButton
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


local function buildMenu()

  local menuFactorY = display.contentHeight - h + 55 
  
  local btnMenu = widget.newButton
  {        
      width     = 75,
      height    = 30,
      defaultFile = "Images/static_screen/st_menu.png",        
      id        = "btnMenu",              
      left      = 5,      
      top       =  menuFactorY               
  }
  gv.stage:insert( btnMenu )

end

    
local function buildMoneyBar()
    
  moneyBarFactorY = display.contentHeight - 30
    
  MB = widget.newButton
  {        
      width         = w*0.6,
      height        = 20,
      labelAlign    = "left",
      shape         = "roundedRect",
      cornerRadius  = 10,
      fillColor     = { default={ 0, 1, 0, 1 }, over={ 1, 0.2, 0.5, 1 } },        
      id            = "btnMB",              
      left          = 5,
      label         = "$ ",
      top           =  moneyBarFactorY              
  }
  
  setMoney()
  MB:setEnabled( false )
  gv.stage:insert( MB )
    

end


local function buildDataBar()

   -- w is the width of the static BG
  dataBarX = display.contentWidth - w +5
  local dataBoxShift = w + 10
  local dataBoxWidth = ((dataBarX/3) - 20) 
  local dataBoxHeightPos = 17
    
  local dataBar = widget.newButton
  {        
      width     = dataBarX,
      height    = 30,
      shape     = "rect",      
      fillColor = { default={ 0.8, 0, 0, 1 }, over={ 1, 0.2, 0.5, 1 } },        
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
      fillColor = { default={ 0, 1, 0, 1 }, over={ 1, 0.2, 0.5, 1 } },        
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
      fillColor = { default={ 0, 1, 0, 1 }, over={ 1, 0.2, 0.5, 1 } },        
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
      fillColor = { default={ 0, 1, 0, 1 }, over={ 1, 0.2, 0.5, 1 } },        
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
  
  local TBwidth         = display.contentWidth*0.28
  local toolBarFactorX  = display.contentWidth-TBwidth
    
  -- Tool bar Background   
  local TBBG = widget.newButton
  {        
      width     = TBwidth,
      height    = 85,
      defaultFile = "Images/static_screen/st_dateControl.png",        
      id        = "btnTB",              
      left      = toolBarFactorX,      
      top       = 0              
  }
  
  -- The section that will hold the month and year
  timeLabel = widget.newButton
  {
    width         = TBwidth *0.9,
    height        = 20, 
    shape         = "roundedRect",
    cornerRadius  = 6,
    id            = "time",
    fillColor     = { default={ 0.5, 0, 0, 1 }, over={ 0.5, 0, 0.5, 0 } },
    label         = "January",
    top           = 2,
    left          = toolBarFactorX + 10  
  }
  
  -- the weather icon
  local weather = widget.newButton
  {   
      width       = circleWidth,
      height      = circleHeight,
      defaultFile = "Images/static_screen/st_weather_Sun.png",   
      id          = "weather",      
      top         = 25,
      left        = toolBarFactorX + 70,                   
  }
  
  
  -- The pause/play button. When pause is pressed it will turn into the play button.
  local btnPause = widget.newButton
  {
      
      width       = circleWidth,
      height      = circleHeight,
      defaultFile = "Images/static_screen/st_pause.png",
      id          = "pause",      
      top         = 25,
      left        = toolBarFactorX + 110,                  
  }
  
  
  TBBG:setEnabled( false )
  timeLabel:setEnabled( false )
  weather:setEnabled( false )
    
  gv.stage:insert( TBBG )
  gv.stage:insert( timeLabel )
  gv.stage:insert( weather )  
  gv.stage:insert( btnPause )

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

    gv.powerSupplied = gv.powerDemanded*1.1  
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
    
    --wind
    productionFunction(gv.windBuildCounter,gv.windSpecs)
    
    --Hydro
    
    for i = 1,gv.hydroCounter,1 do        
        if( gv.rivers[i]:getBuilt() ) then
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
    buildDataBar()
    buildToolBar()    
end


local function advertisementFee()

    local temp = 0

    for i = 0, gv.addCounter - 1,1 do
        if( gv.advertisements[i]:getBought() ) then            
            temp = temp + gv.advertisements[i]:getCost()
        end
    end
    
    return temp

end

local function calculateMoney()

    local add = (gv.powerSupplied + gv.powerDemanded)/2
    
    add = add - math.abs((gv.powerSupplied - gv.powerDemanded)/2)
    
    gv.money = gv.money + add
    
    local addFee = advertisementFee()
    
    gv.money = gv.money - addFee
    setMoney()
    
end


local function advertisementEffects()
    
    --if (gv.advertisements[1]:getBought()) then
        

end

-- Responcible for the month/year timer
local function timerFunction(event) 
    
  timeLabel:setLabel(month[monthCounter] .. " " .. gv.year)
 
  monthCounter = monthCounter + 1
  
  if monthCounter == 13 then      
      gv.year = gv.year +1  
      gv.population = populationFunction(gv.year) 
      gv.monthlyPopulationIncrease = calculateMonthlyPopulationIncrease()      
      monthCounter = 1
  end
  
  gv.population = gv.population + gv.monthlyPopulationIncrease   
  docResources()
  advertisementEffects()
  calculateMoney()
  showData()
  
  if(gv.onCityScreen) then
      setDataBox("Population", gv.population, 1)
      calcPowerDemanded()
      setDataBox("Demanded", gv.powerDemanded.."GW", 2)
      setDataBox("Supplied", gv.powerSupplied.."GW", 3)
  end
  
  timer.performWithDelay(gv.month,timerFunction)
end


-- Responcible for the seconds counter to telll how long the user
-- has played for
local function secondsCounter(event)

    gv.seconds = gv.seconds + 1
    timer.performWithDelay(1000, secondsCounter)
end


-- Setting up timers
function timeStart()

  gv.yearTimer    = timer.performWithDelay(1, timerFunction)
  gv.secondsTimer = timer.performWithDelay(1000, secondsCounter)

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


-- used for testing purposes to see recourses owned and rate of consumption
function showData()

    local amount = gv.nuclearBuildCounter*gv.nuclearSpecs:getConsumption()
    print("Amount of Uranium currently owned "..tostring(gv.resourcesHeld[3]))
    print("Amount of Uranium being used each month "..tostring(amount))
    
    amount = gv.oilBuildCounter*gv.oilSpecs:getConsumption()
    print("Amount of Oil currently owned "..tostring(gv.resourcesHeld[0]))
    print("Amount of Oil being used each month "..tostring(amount))


end

initalize()
main()
