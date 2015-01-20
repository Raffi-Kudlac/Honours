
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

local startBlackoutTimeYear = 0
local startBlackoutTimeMonth = 0
local isPaused = false
local btnPausePlay 
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


function startingPower()
    
    composer.gotoScene("natural")
    setNaturalCurrentEnergySourse(gv.windSpecs)    
    for x = 1, 4, 1 do 
      gv.marker = x
      naturalPurchasedConfirmed()
    end    
    gv.money = gv.money + gv.windSpecs:getCost()*4    
    
    setNaturalCurrentEnergySourse(gv.solarSpecs)
    for x = 1, 2, 1 do 
        gv.marker = 5 + x
        naturalPurchasedConfirmed()            
    end
    gv.money = gv.money + gv.solarSpecs:getCost()*2
    
    
    composer.gotoScene("land")
    gv.marker = 2
    setLandCurrentEnergySourse(gv.coalSpecs)
    landPurchasedConfirmed()
    gv.money = gv.money + gv.coalSpecs:getCost()

end

local function main()  
  display.setStatusBar( display.HiddenStatusBar )
  composer.gotoScene("menu")
end

-- Initalizing the global variables 
local function initalize()
  
    local energyPros = "This Fossle Fueled power plant runs off of oil which is abundant and fairly cheap to obtain."..
    " In comparison to coal it will burn faily well and not polute the air as much."            
    local energyCons = "Oil has many other purposes other then just fueling power plants. Such as fueling cars and heating homes."..
    "These other uses drain the amount of oil that can be used. Investing in this kind of power plant will wont make envirmentalist ".. 
    " particularily happy."    
    local energyCost = 2    
    local energyProduction = 1
    local energyConsumption = 10
    local energyMaintenence = 1
    
    
    gv.monthTimer    = 0
    gv.secondsTimer  = 0 
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
    gv.hydroCounter = 2          
    gv.rivers[0] =  stream.new("Hudson",10,5,10,1)
    gv.rivers[1] =  stream.new("Tidal",20,7,13,1)
    
    local r0Data = "Dams produce clean energy at the expence of destroying large amounts of usable land. " .. 
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
    gv.groupActionWinner = -1
    
    gv.groups[0] = organization.new( "Envirmentalists" )
    gv.groups[0]:setAbout("This organization is deticated to protecting the earth and to care for the " .. 
    "envirment. Poluting the atmosphere or destroying the land in any way will generally make this organization " .. 
    "angry with you. This organization is effected and effects almost all forms of power It is very hard to keep them happy forever.")
    
    
    gv.groups[0]:setHappyText("The Envirmentalists are happy with you and have convinced the goverment to reduce taxes for you. " .. 
    "as a result the maintenence cost of fossile fueled and nuclear power plants has decreased by 1B")
    
    gv.groups[0]:setMadText("The Envirmentalists are mad that you are polluting the planet. They have convinced the goverment to " ..
    "add more taxes to your power plant. As a result the maintenence cost of your Nuclear and fossil fueled power plants has " .. 
    "inceased by 1B")
    
    gv.groups[1] = organization.new( "Anti-Nuclear" )
    gv.groups[1]:setAbout("This organization of people is composed of people who are scared of nuclear power and believe that it " .. 
    "is to dangerious to be used close to thier homes and loved ones. Building nuclear power plants will upset this group. " .. 
    "A good way to deal with them would be to educate them and assure them that although nuclear power is dangerious, all " .. 
    "the safety procations are being taken so there is nothing to fear.")
    
    gv.groups[1]:setHappyText("The Anti-Nuclear group aren't seaming so Anti-Nuclear any more and they have gotten off your ".. 
    "back for the time being. With some extra breathing room and not having to deal with them you have reduced the maintenece cost" .. 
    "of nuclear power Plants by 3B")
    
    gv.groups[1]:setMadText("The Anti-Nuclear groups is mad at you for building nuclear power plants. They feel unsafe and worried. "
    .. "They have complained to the goverment and as a result you have been forced to increase security checks and add " .. 
    "extra safety procations. This has increased the maintenence cost of all nuclear power plants by 3B")
    
        
    gv.groups[2] = organization.new( "The Population" )
    gv.groups[2]:setAbout("The people you serve generally don't care how they get thier power as long as they get it. " .. 
    "Keeping the lights on will keep them happy but if blackouts occure then they are going to get mad. If too many blackouts" .. 
    "happen then you have to give some money back to the people to compinsate. Be careful, if to many blackouts " .. 
    "happen to frequently then you lose the game")
    
    gv.groups[2]:setHappyText("The people are happy with your production of power. You don't get anything but at least" .. 
    "they are not rioting and making your life difficult.")
    
    gv.groups[2]:setMadText("To many blackouts have happened and the people have rioted and made inpropriate signs" .. 
    "protesting your capabilities of producing power. You paya fine of 10B for the damages and getting rid of the protestors.")
    
    gv.groups[3] = organization.new( "Anti-Windmillists" )
--    gv.groups[3]:setAbout("You would think, 'Who protests Windmills. Clean energy and no envirmental hazards' well " .. 
--    "aparently living by windmills is not the most pleasent expeareance, they are loud noisy machines that generally don't " .. 
--    "give the landscape any beauty points eigher. They are also the reason for a lot avian deaths when they don't like to ".. 
--    "look where they are flying." )

    gv.groups[3]:setAbout("You would think, 'Who protests Windmills. Clean energy and no envirmental hazards' well you can't " ..
    "everybody happy. This groups is usually composed of people who live around windmills. They don't like the noise and the " ..
    "appearence of these big machines. This population of this groups is generally small and they don't a lot of attention " .. 
    "as windmills are a source of clean energy.")
    
    gv.groups[3]:setHappyText("although windmills are noisy and not nice to live around you have convinced the " .. 
    "Anti-Windmillists that they are worth it. The cost of building windmills has reduced by 2B.")
    
    gv.groups[3]:setMadText("Farmers and countrymen are not happy about the windmills that you have been putting up." .. 
    "They have rallied and spoken to the goverment. The cost of building future windmills has increased by 2B")
    
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
    gv.advertisements[5] = adds.new( "Public Appeal", 4 )
           
    gv.publicServises = {}
    gv.servisCounter = 8
    gv.publicServises[0] = publicServises.new("Geologist",4)
    gv.publicServises[0]:setAbout("Hire a Geologist to analise the land and tell you where resourses are. Say goodbye to guessing")
    
    gv.publicServises[1] = publicServises.new("Fossil Fuel Advances",4)
    gv.publicServises[2] = publicServises.new("Nuclear Advances",4)
    gv.publicServises[3] = publicServises.new("Wind Power Advances",3)
    gv.publicServises[4] = publicServises.new("Solar Advances",4)
    gv.publicServises[5] = publicServises.new("Hydro Advances",5)    
    gv.publicServises[6] = publicServises.new("Generator Advances",3)
    gv.publicServises[7] = publicServises.new("Corrupt Envirmentalists",8)
    
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
    gv.blackoutTimeRate   = 3    -- this varible and the one above represents the rate of blackouts. 5 blackouts in three years    
    gv.blackoutTimes = {}
    
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
    
    -- power demanded = population + a little more for businesses and such
     gv.powerDemanded = math.round ( 10*(gv.population*2.4/1000) )/10 --1.2
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

function changePauseImage(imagePath)
    
  local x = btnPausePlay.x - btnPausePlay.width/2
  
  gv.stage:remove( btnPausePlay )
    
  btnPausePlay = widget.newButton
  {
      
      width       = circleWidth,
      height      = circleHeight,
      defaultFile = imagePath,
      id          = "pausePlay",      
      top         = 25,
      left        = x,    
      onEvent     = pausedPressed,              
  }
  
  gv.stage:insert(btnPausePlay)

end


local function showMenu( event )

    if (event.phase == "began") then
        pause()
        composer.showOverlay("inGameMenu")
    end

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
      width         = w*0.6,
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
  btnPausePlay = widget.newButton
  {
      
      width       = circleWidth,
      height      = circleHeight,
      defaultFile = "Images/static_screen/st_pause.png",
      id          = "pausePlay",      
      top         = 25,
      left        = toolBarFactorX + 110,    
      onEvent     = pausedPressed,              
  }
  
  
  TBBG:setEnabled( false )
  timeLabel:setEnabled( false )
  weather:setEnabled( false )
    
  gv.stage:insert( TBBG )
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
    
    --wind
    productionFunction(gv.windBuildCounter,gv.windSpecs)
    
    --Hydro
    
    for i = 1,gv.hydroCounter - 1,1 do        
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

    for i = 0, servisCounter, 1 do
            
        if (gv.publicServises[i]:getBought()) then
            minus = minus + gv.publicServises[i]:getCost()            
            --print ( "The cost of the add is " .. gv.publicServises[i]:getCost())
        end    
    end
    
    return minus
    

end

local function calculateMoney()

    local add = (gv.powerSupplied + gv.powerDemanded)/2
    
    add = add - math.abs((gv.powerSupplied - gv.powerDemanded)/2)
    
    gv.money = gv.money + add
    
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

    gv.money = gv.money - 10
    gv.groups[0]:setStatus(2)

end

local function checkPublicServisPercent()

    local randomNumber = math.random(1,10)
    local pass = false
    
    --for x = 0, servisCounter -1, 1 do
      for x = 0, 0, 1 do    
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
                      gv.publicServisText[1] = "Due to improvements in technologie the maintenence cost " .. 
                      " of all fossile fueled power plants has decreased by 1"
                  else
                      gv.gasSpecs:setProduction(gv.gasSpecs:getProduction() + 1)
                      gv.coalSpecs:setProduction(gv.coalSpecs:getProduction() + 1)
                      gv.oilSpecs:setProduction(gv.oilSpecs:getProduction() + 1)
                      gv.publicServisText[1] = "Due to improvements in technologie " .. 
                      "all fossile fueled power plants now produce 1 GW more power"
                  end
                  
                  -- inform user of change
              
              elseif ( x == 2 ) then 
                  
                  if ( randomNumber > 5) then
                      gv.nuclearSpecs:setMaintenenceCost(gv.nuclearSpecs:getsetMaintenenceCost() - 2)
                      gv.publicServisText[2] = "Due to improvements in technologie the maintenence cost " .. 
                      " of all nuclear power plants has decreased by 2"
                  else
                      gv.nuclearSpecs:setProduction(gv.nuclearSpecs:getProduction() + 2)
                      gv.publicServisText[2] = "Due to improvements in technologie " .. 
                      "all nuclear power plants now produce 2 GW more power"
                  end
              elseif ( x == 3 ) then
                  
                  gv.windSpecs:setProduction(gv.windSpecs:getProduction() + 2)
                  gv.publicServisText[3] = "Due to improvements in technologie " .. 
                      "all windmills have become more efficient and produce 2 GW more power"
                                                      
              elseif ( x == 4 ) then
                  
                  gv.solarSpecs:setProduction(gv.solarSpecs:getProduction() + 2)
                  gv.publicServisText[4] = "Due to improvements in technologie " .. 
                      "all solar panals have become more efficient and produce 2 GW more power"
              elseif ( x == 5) then
              
                  if ( randomNumber > 5) then
                      gv.hydroSpecs:setMaintenenceCost(gv.hydroSpecs:getsetMaintenenceCost() - 2)
                      gv.publicServisText[5] = "Due to improvements in technologie the maintenence cost " .. 
                      " of all hydro power plants has decreased by 2"
                  else
                      gv.hydroSpecs:setProduction(gv.hydroSpecs:getProduction() + 2)
                      gv.publicServisText[5] = "Due to improvements in technologie " .. 
                      "all hydro plants have become more efficient and produce 2 GW more power"
                  end
              elseif ( x == 6) then
                    
                  gv.gasSpecs:setProduction(gv.gasSpecs:getProduction() + 1)
                  gv.coalSpecs:setProduction(gv.coalSpecs:getProduction() + 1)
                  gv.oilSpecs:setProduction(gv.oilSpecs:getProduction() + 1)
                  gv.hydroSpecs:setProduction(gv.hydroSpecs:getProduction() + 1)                  
                  gv.windSpecs:setProduction(gv.windSpecs:getProduction() + 1)
                  gv.nuclearSpecs:setProduction(gv.nuclearSpecs:getProduction() + 1)
                  gv.publicServisText[6] = "Due to your investment in researching more efficient generators " .. 
                      "all energy sources except solar panels can produce an extra GW of power"                  
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

    local yearDiff = gv.year - gv.blackoutTimes[index][0]
    local monthDiff = gv.month - gv.blackoutTimes[index][1]
    
    if (monthDiff  < 0 ) then
        yearDiff = yearDiff - 1
        monthDiff = -1*MonthDiff
    end
        
    return yearDiff       
end

local function addBlackoutTime()

    -- wipes out any blackouts outside of the time range
    for x = 1, #gv.blachoutTimes, 1 do
        if( calculateYearDifferene(1) > gv.blackoutTimeRate ) then
            table.remove(gv.blackoutTimes, 1)
        end
    end
    
    
    -- insert new blackout time
    if(#gv.blackoutTimes == 5) then
        -- game over
    else
        timeData = {startBlackoutTimeYear, startBlackoutTimeMonth, gv.blackoutLengthCounter}
        table.insert(gv.blackoutTimes,timeData)
    end                     
end

local function isBlackout()

    if (gv.powerDemanded > gv.powerSupplied) then   -- there is a blackout
    
        gv.blackoutLengthCounter = gv.blackoutLengthCounter + 1
        gv.blackoutCounter = gv.blackoutCounter + 1        

        if(gv.blackoutLengthCounter >= 10) then
            -- game over
        elseif (gv.blackoutLengthCounter == 1) then
            startBlackoutTimeYear = gv.year
            startBlackoutTimeMonth = gv.month            
        end
        
        if ( gv.blackoutLengthSum + gv.blackoutLengthCounter >= 12) then
            -- game over
        end
        
    else
        
        if(gv.blackoutLengthCounter ~= 0) then
            addBlackoutTime()
            gv.blackoutLengthCounter = 0
        end
                
    end
end

local function isGameOver()

    local isGameOver = false

    if (gv.money <= -30) then
        isGameOver = true
    end

end

local function checkGroupActionPercent()

    local spaceArray = {}
    local percent = math.random(1,100)
    
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
                     gv.nuclearSpecs:addMaintenenceCost(-3)                   
                else
                    gv.nuclearSpecs:addMaintenenceCost(3)
                end
            
            elseif (x == 2) then
            -- this is for the population group, thinking this should be taken out and replaced in the blackout Method
                if ( gv.groups[2]:getNumberStatus() > 0 ) then
                                        
                else
                    gv.money = gv.money - 10
                end
            
            elseif (x == 3) then
            
                if ( gv.groups[3]:getNumberStatus() > 0 ) then                    
                    gv.windSpecs:setCost(gv.windSpecs:getCost() - 2)              
                else
                    gv.windSpecs:setCost(gv.windSpecs:getCost() + 2)
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
  calculateMoney()
  checkPublicServisPercent()
  checkGroupActionPercent()
  --showData()
  
  if(gv.onCityScreen) then
      setDataBox("Population", gv.population, 1)
      calcPowerDemanded()
      setDataBox("Demanded", gv.powerDemanded.."GW", 2)
      setDataBox("Supplied", gv.powerSupplied.."GW", 3)
  end
  
  --isGameOver()
  
  gv.monthTimer = timer.performWithDelay(gv.month,timerFunction)
end


-- Responcible for the seconds counter to telll how long the user
-- has played for
local function secondsCounter(event)

    gv.seconds = gv.seconds + 1
    gv.secondsTimer = timer.performWithDelay(1000, secondsCounter)
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
