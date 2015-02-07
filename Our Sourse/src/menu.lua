--[[
Purpose:
This screen is the menu screen currently only holding the play button.

]]

local composer  = require( "composer" )
local gv        = require( "global" )
local widget    = require( "widget" )
local parse     = require ( "mod_parse")
local scene     = composer.newScene()

-------------------------------------------------
-- PRIVATE FUNCTIONS
-------------------------------------------------

local function play( event )

  if ( "ended" == event.phase ) then       
    composer.gotoScene("mining")    
    startingPower()
    composer.gotoScene("city")
    
--    gv.year = 2018
--    gv.month = 8
--    gv.blackoutLengthSum = 6
--    composer.gotoScene("gameOver")
  end
end


-------------------------------------------------
-- COMPOSER FUNCTIONS
-------------------------------------------------

-- "scene:create()"
function scene:create( event )

  local sceneGroup = self.view

  local btnPlay = widget.newButton
    {
      width     = 100,
      height    = 50,
      shape     = "roundedRect",
      fillColor = { default={ 1, 0.2, 0.5, 0.7 }, over={ 1, 0.2, 0.5, 1 } },
      id        = "btnPlay",
      label     = "PLay",
      left      = centerX(100),
      top       = centerY(50),
      onEvent   = play
  }
  
  
    
--    local myRectangle = display.newRect( 300, 
--    150, display.contentWidth, display.contentHeight )
--    myRectangle.strokeWidth = 1
--    myRectangle:setFillColor( 1 )
--    myRectangle:setStrokeColor( 1, 0, 0 )
    
--    local mask = graphics.newMask( "Images/land_screen/lnd_tile_forest_mask.png" )
--    
--    local btnPlay = widget.newButton
--        {
--          width       = 120,
--          height      = 120,
--          defaultFile = "Images/land_screen/lnd_tile_forest.png",
--          id          = "openLand",
--          left        = centerX(120),
--          top         = centerY(120),
--          onEvent = play,          
--      }
--      btnPlay.anchorX, btnPlay.anchorY = 0,0      
--      local xScale = btnPlay.width/512
--      local yScale = btnPlay.height/512
--      
--      btnPlay:setMask( mask )
--      --myRectangle:setMask(mask)
--      
--      
--      
----      myRectangle.maskScaleX = 0.5
----      myRectangle.maskScaleY = 0.5
--
--      btnPlay.maskScaleX = xScale
--      btnPlay.maskScaleY = yScale
------      
--      btnPlay.maskX = btnPlay.width/2  
--      btnPlay.maskY = btnPlay.height/2
------      
--      
--      print("The masks x is " .. btnPlay.maskX)
--      print("The masks y is " .. btnPlay.maskY)
--      print("The masks xscale is " .. btnPlay.maskScaleX)
--      print("The masks yscale is " .. btnPlay.maskScaleY)
--      



  
  
      
      --sceneGroup:insert(myRectangle)
      sceneGroup:insert(btnPlay)
end


-- "scene:show()"
function scene:show( event )

  local sceneGroup = self.view
  local phase = event.phase
  composer.removeHidden()

  if ( phase == "will" ) then
  -- Called when the scene is still off screen (but is about to come on screen).
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
  end
end


-- "scene:destroy()"
function scene:destroy( event )

  local sceneGroup = self.view

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