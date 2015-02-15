--[[
Purpose:
This screen is the menu screen currently only holding the play button.

]]

local composer  = require( "composer" )
local gv        = require( "global" )
local widget    = require( "widget" )
local scene     = composer.newScene()
local BG
-------------------------------------------------
-- PRIVATE FUNCTIONS
-------------------------------------------------


local function resumePlay( event )


  if (event.phase == "began") then
    composer.hideOverlay()
  end

end

-------------------------------------------------
-- COMPOSER FUNCTIONS
-------------------------------------------------

-- "scene:create()"
function scene:create( event )

  local sceneGroup = self.view
  local boxWidth = widthCalculator(0.25)
  local boxHeight = heightCalculator(0.7)
  local btnWidth = boxWidth*0.8
  local btnHeight = boxHeight*0.2
  

  BG = widget.newButton
    {
      width       = boxWidth,
      height      = boxHeight,
      defaultFile = "Images/global_images/Vertical_Box.png",
      id          = "BO",
      left        = centerX(boxWidth),
      top         = centerY(boxHeight),
  }

  local verticalShift = BG.height*0.2

  local btnNewGame = widget.newButton
    {
      width     = btnWidth,
      height    = btnHeight,
      defaultFile = "Images/global_images/button1.png",
      id        = "btnPlay",
      label     = "New Game",
      left      = BG.x - BG.width/2 + BG.width*0.1,
      top       = BG.y - BG.height/2 + BG.height*0.1,
      onEvent   = newGame, 
  }
  btnNewGame.anchorx, btnNewGame.anchory = 0,0


  local btnQuit = widget.newButton
    {
      width     = btnWidth,
      height    = btnHeight,
      defaultFile = "Images/global_images/button1.png",
      id        = "btnPlay",
      label     = "Quit",
      left      = btnNewGame.x - btnWidth/2,
      top       = btnNewGame.y + verticalShift,
      onEvent   = returnToMainMenu, 
  }
  
  btnQuit.anchorx, btnQuit.anchory = 0,0

  local btnResume = widget.newButton
    {
      width     = btnWidth,
      height    = btnHeight,
      defaultFile = "Images/global_images/button1.png",
      id        = "btnPlay",
      label     = "Resume",
      left      = btnNewGame.x - btnWidth/2,
      top       = btnQuit.y + verticalShift,
      onEvent   = resumePlay,
  }

  sceneGroup:insert(BG)
  sceneGroup:insert(btnNewGame)
  sceneGroup:insert(btnQuit)
  sceneGroup:insert(btnResume)

end


-- "scene:show()"
function scene:show( event )

  local sceneGroup = self.view
  local phase = event.phase

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