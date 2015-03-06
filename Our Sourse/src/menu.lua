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
    composer.gotoScene("loading")    
--    startingPower()
--    composer.gotoScene("city")   
  end
end

local function tutorial( event )

    if (event.phase == "ended" ) then    
        composer.gotoScene("tutorial")    
    end

end

local function about( event )
    
    if (event.phase == "began" ) then
        composer.gotoScene("about")
    end

end 


-------------------------------------------------
-- COMPOSER FUNCTIONS
-------------------------------------------------

-- "scene:create()"
function scene:create( event )

  local sceneGroup = self.view
  
  local btnWidth = widthCalculator(0.2)
  local btnHeight = heightCalculator(0.15)
  local gap = heightCalculator(0.2)
  local path = "Images/global_images/button1.png"

  local btnPlay = widget.newButton
    {
      width     = btnWidth,
      height    = btnHeight,
      defaultFile   = path,
      label     = "Play",
      left      = centerX(btnWidth),
      top       = centerY(btnHeight) - gap,
      onEvent   = play
  }
  
  local btnTutorial = widget.newButton
    {
      width     = btnWidth,
      height    = btnHeight,
      defaultFile   = path,
      label     = "Tutorial",
      left      = centerX(btnWidth),
      top       = centerY(btnHeight),
      onEvent   = tutorial
  }
  
  local btnAbout = widget.newButton
    {
      width       = btnWidth,
      height      = btnHeight,
      defaultFile   = path,
      label       = "About",
      left        = centerX(btnWidth),
      top         = centerY(btnHeight) + gap,
      onEvent     = about
  }
  
  
--  local array = {}
--  
--  array[0] = "Images/hydro_screen/hy_screen_river1small.png"
--  
--  local btnPlay = widget.newButton
--      {
--          width = display.contentWidth,
--          height = display.contentHeight,
--          left = 0,
--          top = 0,
--          defaultFile = array[0],
--          onEvent   = play,          
--      }
--      btnPlay.anchorY = 0
--      btnPlay.anchorX = 0
--      btnPlay.x = 0
--      btnPlay.y = 0
--      
--      local xScale = math.round(100*(btnPlay.width/1200))/100
--      local yScale = math.round(100*(btnPlay.height/800))/100     
--      
--     
--      local m = graphics.newMask( "Images/hydro_screen/hy_screen_river1_maskBORDER1.png" )
--      
--      btnPlay:setMask( m )
--      btnPlay.maskScaleX = xScale
--      btnPlay.maskScaleY = yScale
--      btnPlay.maskX = btnPlay.width/2
--      btnPlay.maskY = btnPlay.height/2
      
      
      sceneGroup:insert(btnPlay)      
      sceneGroup:insert(btnTutorial)
      sceneGroup:insert(btnAbout)
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