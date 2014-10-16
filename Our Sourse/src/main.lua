
-- NOTES FOR MYSELF------
-- Width is along the x axis
-- Height is along the y axis
-----------------

local widget          = require( "widget" )
local gv              = require( "global" )
local composer        = require( "composer" )
local monthCounter    = 1
local circleWidth     = 30
  local circleHeight  = 30
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
  
  composer.gotoScene("menu")
end

-- Initalizing the global variables 
local function initalize()

    gv.stage         = display.getCurrentStage()
    gv.seconds       = 0
    gv.year          = 2000
    gv.month         = 5000 --each month is five seconds
    gv.secondsTimer  = timer
    gv.yearTimer     = timer

end


function centerY(height)
  return (display.contentHeight-height)/2 
end


function centerX(width)
   return (display.contentWidth-width)/2 
end


local function buildStaticBG()
  
  h = 120
  w = 175

  local stcBG = widget.newButton
  {        
      width     = w,
      height    = h,
--      shape     = "rect",
--      fillColor = { default={ 0.8, 0, 0, 1 }, over={ 1, 0.2, 0.5, 1 } },
      defaultFile = "Images/st_UICorner.png",              
      id        = "stcBG",              
      left      = 0,
      top       = display.contentHeight - h                
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
      defaultFile = "Images/st_ff.png",
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
      defaultFile = "Images/st_land.png",
      id          = "land",
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
      defaultFile = "Images/st_plant.png",
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
      defaultFile = "Images/st_city.png",
      top         = buttonFactorY,
      left        = buttonFactorX
   }
   
   buttonFactorY = buttonFactorY + 25
   buttonFactorX = buttonFactorX + 25
   
   --This is the busness screen button
   local btnBNS = widget.newButton
   {
      width       = circleWidth,
      height      = circleHeight,
      defaultFile = "Images/st_business.png",
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
      defaultFile = "Images/st_menu.png",        
      id        = "btnMenu",              
      left      = 5,      
      top       =  menuFactorY               
  }
  gv.stage:insert( btnMenu )

end

    
local function buildMoneyBar()
    
  moneyBarFactorY = display.contentHeight - 30
    
  local MB = widget.newButton
  {        
      width         = w*0.6,
      height        = 20,
      labelAlign    = "left",
      shape         = "roundedRect",
      cornerRadius  = 10,
      fillColor     = { default={ 0, 1, 0, 1 }, over={ 1, 0.2, 0.5, 1 } },        
      id            = "btnMB",              
      left          = 5,
      label         = "$",
      top           =  moneyBarFactorY              
  }
  
  MB:setEnabled( false )
  gv.stage:insert( MB )
    

end


local function buildDataBar()

  dataBarX = display.contentWidth - w +5
    
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
  
  dataBar:setEnabled( false )
  gv.stage:insert( dataBar )

end


local function buildToolBar()
  
  local TBwidth         = 150
  local toolBarFactorX  = display.contentWidth-TBwidth
    
  -- Tool bar Background   
  local TBBG = widget.newButton
  {        
      width     = TBwidth,
      height    = 85,
      defaultFile = "Images/st_dateControl.png",        
      id        = "btnTB",              
      left      = toolBarFactorX,      
      top       = 15              
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
    top           = 17,
    left          = toolBarFactorX + 10  
  }
  
  -- the weather icon
  local weather = widget.newButton
  {   
      width       = circleWidth,
      height      = circleHeight,
      defaultFile = "Images/st_weather_Sun.png",   
      id          = "weather",      
      top         = 40,
      left        = toolBarFactorX + 70,                   
  }
  
  
  -- The pause/play button. When pause is pressed it will turn into the play button.
  local btnPause = widget.newButton
  {
      
      width       = circleWidth,
      height      = circleHeight,
      defaultFile = "Images/st_pause.png",
      id          = "pause",      
      top         = 40,
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

initalize()
main()
