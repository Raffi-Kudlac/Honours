
--[[ 
  Purpose: 
      By Lua default all files have access to this file and this is the first file that is executed by the program.
      This holds all global methods and is responcible for setting up the static components of the game, as well as timers,
      and iinitalizing global variables.     

    NOTES FOR MYSELF------
  Width is along the x axis
  Height is along the y axis
  function() return setText(gv.oilSpecs) end, used for passing parameters to a button call

]]

local widget          = require( "widget" )
local gv              = require( "global" )
local composer        = require( "composer" )
local powerPlant      = require( "powerPlant" )
local monthCounter    = 1
local circleWidth     = 30
local circleHeight    = 30
local MB = widget
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
    
    
    gv.stage         = display.getCurrentStage()
    gv.seconds       = 0
    gv.year          = 2000
    gv.month         = 5000 --each month is five seconds
    gv.secondsTimer  = timer
    gv.yearTimer     = timer
    gv.population    = 10000
    gv.money = 10
    calcPowerDemanded()
    gv.powerSupplied = gv.powerDemanded*1.1    
    gv.screen = "city"
    gv.font = native.systemFont
    gv.fontSize = 8
    
    gv.oilSpecs = powerPlant.new("oil")
    gv.oilSpecs:setCost(energyCost)
    gv.oilSpecs:setProduction(energyProduction)
    gv.oilSpecs:setCons(energyCons)
    gv.oilSpecs:setPros(energyPros)
    gv.oilSpecs:setConsumption(energyConsumption)
    
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
                          
end

function setMoney()

    MB:setLabel("$ "..gv.money)

end


function calcPowerDemanded()
    
    -- power demanded = population + a little more for businesses and such
    gv.powerDemanded = gv.population*1.2/1000

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
      left        = buttonFactorX
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
      left        = buttonFactorX
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
  
  local TBwidth         = 150
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


function buildStaticScreen()
    gv.stage = display.getCurrentStage()
    buildStaticBG()
    buildScreenButtons()
    buildMenu()
    buildMoneyBar()
    buildDataBar()
    buildToolBar()    

end

-- Responcible for the month/year timer
local function timerFunction(event) 
  
  timeLabel:setLabel(month[monthCounter] .. " " .. gv.year)
 
  monthCounter = monthCounter + 1
  
  if monthCounter == 13 then
      gv.year = gv.year +1
      monthCounter = 1
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

initalize()
main()
