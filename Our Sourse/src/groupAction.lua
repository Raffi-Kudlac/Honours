--[[
Purpose:
This screen is the menu screen currently only holding the play button.

]]

local composer  = require( "composer" )
local gv        = require( "global" )
local widget    = require( "widget" )
local scene     = composer.newScene()

local d               = 280
local textWidth       = d*0.7
local textHeight      = 0

-------------------------------------------------
-- PRIVATE FUNCTIONS
-------------------------------------------------

local function okay( event )

  if ( event.phase == "began") then

    gv.groupActionWinner = -1
    composer.hideOverlay()
  end

end


-------------------------------------------------
-- COMPOSER FUNCTIONS
-------------------------------------------------

-- "scene:create()"
function scene:create( event )
  local sceneGroup = self.view
  local message = 0

  pause()

  if ( gv.groups[gv.groupActionWinner]:getNumberStatus() > 0) then
    message = gv.groups[gv.groupActionWinner]:getHappyText()
  else
    message = gv.groups[gv.groupActionWinner]:getMadText()
  end

  local groupDisplay = widget.newButton
    {
      width       = widthCalculator(0.4),
      height      = heightCalculator(0.45),
      defaultFile = "Images/global_images/Horizontal_Box.png",
      id          = "BO",
      left        = centerX(widthCalculator(0.4)),
      top         = centerY(heightCalculator(0.45)),
  }


  local text = display.newText(message, (groupDisplay.x - groupDisplay.width/2) + groupDisplay.width*0.05,
    (groupDisplay.y - groupDisplay.height/2) + groupDisplay.height*0.05, groupDisplay.width*0.85, textHeight, gv.font,gv.fontSize)
  text.anchorX, text.anchorY = 0,0
  text:setFillColor( gv.fontColourR, gv.fontColourG, gv.fontColourB )

  local btnOkay = widget.newButton
    {
      width         = widthCalculator(0.15),
      height        = heightCalculator(0.1),
      defaultFile = "Images/global_images/button1.png",
      label         = "Okay",
      id            = "btnOkay",
      top           =  text.y + text.height*0.6,
      left          =  centerX(widthCalculator(0.1)),
      labelColor = { default={ gv.buttonR, gv.buttonG, gv.buttonB }, over={ gv.buttonOver1,  gv.buttonOver2,  gv.buttonOver3,  gv.buttonOver4 } },
      onEvent       = okay
  }

  sceneGroup:insert( groupDisplay )
  sceneGroup:insert( text )
  sceneGroup:insert (btnOkay )

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
      resume()
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