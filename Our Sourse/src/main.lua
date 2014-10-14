
-- NOTES FOR MYSELF------
-- Width is along the x axis
-- Height is along the y axis
-----------------

local widget        = require( "widget" )
local gv            = require( "global" )
local composer      = require( "composer" )
local monthCounter  = 1
local month         = {
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
      shape     = "rect",
      fillColor = { default={ 0.8, 0, 0, 1 }, over={ 1, 0.2, 0.5, 1 } },        
      id        = "stcBG",              
      left      = 0,
      top       = display.contentHeight - h                
  }
  
  stcBG:setEnabled( false )  
  gv.stage:insert( stcBG )
  
end


local function buildScreenButtons()

  local buttonFactorY = display.contentHeight - h + 5
  local buttonFactorX = 5
  local rad           = 15
    
    
   -- this is the resourse screen button 
   local btnRS = widget.newButton
   {
      radius      = rad,      
      shape       = "circle",
      fillColor   = { default={ 1, 1, 1, 1 }, over={ 1, 0.2, 0.5, 1 } },
      label       = "LS",
      id          = "rs",
      top         = buttonFactorY,
      left        = buttonFactorX
   }
   
   buttonFactorY = buttonFactorY + 5
   buttonFactorX = buttonFactorX + 40
   
   --This is the Land screen button
   local btnLND = widget.newButton
   {
      radius    = rad,      
      shape     = "circle",
      fillColor = { default={ 1, 1, 1, 1 }, over={ 1, 0.2, 0.5, 1 } },
      label     = "LD",
      id        = "LND",
      top       = buttonFactorY,
      left      = buttonFactorX
   }
   
   buttonFactorY = buttonFactorY + 10
   buttonFactorX = buttonFactorX + 40
   
   --This is the power plant screen button
   local btnPP = widget.newButton
   {
      radius    = rad,      
      shape     = "circle",
      fillColor = { default={ 1, 1, 1, 1 }, over={ 1, 0.2, 0.5, 1 } },
      label     = "PP",
      id        = "PP",
      top       = buttonFactorY,
      left      = buttonFactorX
   }
   
   
   buttonFactorY = buttonFactorY + 25
   buttonFactorX = buttonFactorX + 30
   
   --This is the city screen button
   local btnCY = widget.newButton
   {
      radius      = rad,      
      shape       = "circle",
      fillColor   = { default={ 1, 1, 1, 1 }, over={ 1, 0.2, 0.5, 1 } },
      label       = "CY",
      id          = "CY",
      top         = buttonFactorY,
      left        = buttonFactorX
   }
   
   buttonFactorY = buttonFactorY + 30
   buttonFactorX = buttonFactorX + 25
   
   --This is the busness screen button
   local btnBNS = widget.newButton
   {
      radius    = rad,      
      shape     = "circle",
      fillColor = { default={ 1, 1, 1, 1 }, over={ 1, 0.2, 0.5, 1 } },
      label     = "BS",
      id        = "BS",
      top       = buttonFactorY,
      left      = buttonFactorX
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
      shape     = "rect",
      fillColor = { default={ 0, 0, 0, 1 }, over={ 1, 0.2, 0.5, 1 } },        
      id        = "btnMenu",              
      left      = 5,
      label     = "Menu",
      top       =  menuFactorY               
  }
  gv.stage:insert( btnMenu )

end

    
local function buildMoneyBar()
    
  moneyBarFactorY = display.contentHeight - 30
    
  local MB = widget.newButton
  {        
      width         = 120,
      height        = 20,
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
  
  local TBwidth         = 130
  local toolBarFactorX  = display.contentWidth-TBwidth
    
  -- Tool bar Background   
  local TBBG = widget.newButton
  {        
      width     = TBwidth,
      height    = 70,
      shape     = "rect",      
      fillColor = { default={ 0.8, 0, 0, 1 }, over={ 1, 0.2, 0.5, 1 } },        
      id        = "btnTB",              
      left      = toolBarFactorX,      
      top       = 0              
  }
  
  -- The section that will hold the month and year
  timeLabel = widget.newButton
  {
    width         = TBwidth *0.95,
    height        = 20, 
    shape         = "roundedRect",
    cornerRadius  = 5,
    id            = "time",
    fillColor     = { default={ 0.5, 0, 0, 1 }, over={ 0.5, 0, 0.5, 0 } },
    label         = "January",
    top           = 15,
    left          = toolBarFactorX + 5  
  }
  
  -- the weather icon
  local weather = widget.newButton
  {
      radius    = 13,
      shape     = "circle",
      id        = "weather",
      label     = "W",
      top       = 40,
      left      = toolBarFactorX +30,
      fillColor = { default={ 0, 0, 1, 1 }, over={ 0.5, 0, 0.5, 0 } }             
  }
  
  
  -- The pause/play button. When pause is pressed it will turn into the play button.
  local btnPause = widget.newButton
  {
      radius    = 13,
      shape     = "circle",
      id        = "pause",
      label     = "P",
      top       = 40,
      left      = toolBarFactorX +80,
      fillColor = { default={ 0, 0, 1, 1 }, over={ 0.5, 0, 0.5, 0 } }             
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
