--[[
Purpose:
This screen is the menu screen currently only holding the play button.

]]

local composer  = require( "composer" )
local gv        = require( "global" )
local widget    = require( "widget" )
local scene     = composer.newScene()

local consequativeBlackout
local blackoutRateText
local blackoutLengthText
local textRefreshTimer 

-------------------------------------------------
-- PRIVATE FUNCTIONS
-------------------------------------------------

local function refreshText()

    local message = gv.blackoutLengthCounter .. " month(s) of no power \n At 10 the game will end"
    consequativeBlackout.text = message
    
    message = #gv.blackoutTimes .. " blackout(s) in 3 years \n At 5 the game will end"
    blackoutRateText.text = message
    
    message = gv.blackoutLengthSum + gv.blackoutLengthCounter .. " blackout month(s) in 3 years" .. 
      "\n At 12 the game will end"
      
    blackoutLengthText.text = message  
      
end

local function createText(sceneGroup, BG)

  local rectX = BG.x - (BG.width/2)*0.9
  local rectY = BG.y - (BG.height/2)*0.80
  local textX = rectX*1.1
  local textY = rectY*1.2 
  local messsage = ""
  local textWidth = BG.width*0.8
  local rectWidth = BG.width*0.9
  local rectHeight = BG.height*0.2
  local textHeight = 0
    

  trimBlackoutRateArray()
  message = gv.blackoutLengthCounter .. " month(s) of no power \n At 10 the game will end"

  local firstRect = display.newRoundedRect( rectX, rectY, rectWidth,  rectHeight, 10)
  firstRect.anchorX,firstRect.anchorY = 0,0
  firstRect:setFillColor(224/256, 224/256, 224/256, 0.5)
  
  textX = firstRect.x + firstRect.width/2
  textY = firstRect.y + firstRect.height/2
  
  local center = 
{          
    text = message,    
    x = textX,
    y = textY,
    width = textWidth,
    height = textHeight,
    font = gv.font,
    fontSize = gv.fontSize,
    align = "center"  --new alignment parameter
}
  
--  local consequativeBlackout = display.newText(center, message, textX,
--    textY, textWidth, textHeight, gv.font, gv.fontSize)

  consequativeBlackout = display.newText(center)
  consequativeBlackout.anchorX,consequativeBlackout.anchorY = 0.5,0.5  
  consequativeBlackout.x = textX
  
  consequativeBlackout.y = textY 
  consequativeBlackout:setFillColor( gv.fontColourR, gv.fontColourG, gv.fontColourB )
  
  
  rectY = rectY + BG.height*0.25

  message = #gv.blackoutTimes .. " blackout(s) in 3 years \n At 5 the game will end"
  
  
  local secondRect = display.newRoundedRect( rectX, rectY, rectWidth,  rectHeight, 10)
  secondRect.anchorX,secondRect.anchorY = 0,0
  secondRect:setFillColor(224/256, 224/256, 224/256, 0.5)
  
  textY = secondRect.y + secondRect.height/2
  
  center = 
{          
    text = message,    
    x = textX,
    y = textY,
    width = textWidth,
    height = textHeight,
    font = gv.font,
    fontSize = gv.fontSize,
    align = "center"  --new alignment parameter
}
  
  
  blackoutRateText = display.newText(center)
  blackoutRateText.anchorX,blackoutRateText.anchorY = 0.5,0.5
  blackoutRateText:setFillColor( gv.fontColourR, gv.fontColourG, gv.fontColourB )
  
  
  rectY = rectY + BG.height*0.25
  
  message = gv.blackoutLengthSum + gv.blackoutLengthCounter .. " blackout month(s) in 3 years" .. 
  "\n At 12 the game will end"
  
  local thirdRect = display.newRoundedRect( rectX, rectY, rectWidth,  rectHeight, 10)
  thirdRect.anchorX,thirdRect.anchorY = 0,0
  thirdRect:setFillColor(224/256, 224/256, 224/256, 0.5)
  
  textY = thirdRect.y + thirdRect.height/2
  
  center = 
{          
    text = message,    
    x = textX,
    y = textY,
    width = textWidth,
    height = textHeight,
    font = gv.font,
    fontSize = gv.fontSize,
    align = "center"  --new alignment parameter
}
  
  blackoutLengthText = display.newText( center )
  blackoutLengthText.anchorX,blackoutLengthText.anchorY = 0.5,0.5
  blackoutLengthText:setFillColor( gv.fontColourR, gv.fontColourG, gv.fontColourB )
 
  sceneGroup:insert( firstRect )
  sceneGroup:insert( consequativeBlackout )
  sceneGroup:insert( secondRect )
  sceneGroup:insert( blackoutRateText )
  sceneGroup:insert( thirdRect )
  sceneGroup:insert( blackoutLengthText )

end

local function back( event )

    if ( event.phase == "ended") then
        composer.hideOverlay()
    end 
end


-------------------------------------------------
-- COMPOSER FUNCTIONS
-------------------------------------------------

-- "scene:create()"
function scene:create( event )

  local sceneGroup = self.view
  
  local BGWidth = widthCalculator(0.4)
  local BGHeight = heightCalculator(0.8)
  
  local BG = widget.newButton
  {
      width     = BGWidth,
      height    = BGHeight,           
      id        = "btnPlay",
      defaultFile = "Images/global_images/Vertical_Box.png",
      left      = centerX(BGWidth),
      top       = centerY(BGHeight),      
  }
  
  local btnWidth = BG.width*0.3
  local btnHeight = BG.height*0.15
  

  local btnBack = widget.newButton
    {
      width     = btnWidth,
      height    = btnHeight,      
      defaultFile = "Images/global_images/button1.png",
      id        = "btnPlay",
      label     = "Back",
      left      = centerX(btnWidth),
      top       = BG.y + BG.height/2 - btnHeight,
      labelColor = { default={ gv.buttonR, gv.buttonG, gv.buttonB }, over={ gv.buttonOver1,  gv.buttonOver2,  gv.buttonOver3,  gv.buttonOver4 } },
      onEvent   = back
  }
      
  sceneGroup:insert(BG)    
  createText(sceneGroup,BG)    
  sceneGroup:insert(btnBack)
  
  textRefreshTimer = timer.performWithDelay(1000,refreshText, -1)
end


-- "scene:show()"
function scene:show( event )

  local sceneGroup = self.view
  local phase = event.phase  

  if ( phase == "will" ) then
  -- Called when the scene is still off screen (but is about to come on screen).
    shiftMovie()
  elseif ( phase == "did" ) then
  -- Called when the scene is now on screen.
  -- Insert code here to make the scene come alive.
  -- Example: start timers, begin animation, play audio, etc.
  end
end


-- "scene:hide()"
function scene:hide( event )

  local sceneGroup = self.view
  local phase = event.phase

  if ( phase == "will" ) then
  -- Called when the scene is on screen (but is about to go off screen).
  -- Insert code here to "pause" the scene.
  -- Example: stop timers, stop animation, stop audio, etc.
  elseif ( phase == "did" ) then
  -- Called immediately after scene goes off screen.
   returnMovie()
  end
end


-- "scene:destroy()"
function scene:destroy( event )

  local sceneGroup = self.view
  timer.cancel(textRefreshTimer)
  -- Called prior to the removal of scene's view ("sceneGroup").
  -- Insert code here to clean up the scene.
  -- Example: remove display objects, save state, etc.
end


-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene