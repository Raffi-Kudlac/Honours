--[[
Purpose:
This screen is the menu screen currently only holding the play button.

]]

local composer  = require( "composer" )
local gv        = require( "global" )
local widget    = require( "widget" )
local scene     = composer.newScene()

-------------------------------------------------
-- PRIVATE FUNCTIONS
-------------------------------------------------

local function okay( event )

  if (event.phase == "began" ) then

    composer.hideOverlay()

  end

end


-------------------------------------------------
-- COMPOSER FUNCTIONS
-------------------------------------------------

-- "scene:create()"
function scene:create( event )

  local sceneGroup = self.view
  local infoText = {}
  local shiftConstant = 280
  local counter = 0
  local amount = {}
  local message = ""
  local pass = false

  BG = widget.newButton
    {
      width       = widthCalculator(0.35),
      height      = heightCalculator(0.6),
      defaultFile = "Images/global_images/Vertical_Box.png",
      id          = "BO",
      left        = centerX(widthCalculator(0.35)),
      top         = centerY(heightCalculator(0.6)),
  }

  sceneGroup:insert(BG)
  local xPosition = BG.x -- BG.width/2 + BG.width*0.1
  local yPosition = BG.y - BG.height/2 + BG.height*0.1

  for x = 0, 23, 1 do

    if ( gv.foundResourses[x] ~= -1) then
      pass = true
      amount = getCellData(gv.foundResourses[x])
      message = "Tile " .. (gv.foundResourses[x] + 1) .. " contains " .. amount[0] .. " Oil, " .. amount[1] .. " gas, " ..
        amount[2] .. " coal and " .. amount[3] .. " uranium "
      infoText[counter] = display.newText(message, xPosition, yPosition, BG.width*0.9, 0, gv.font, gv.fontSize )
      infoText.anchorX, infoText.anchorY = 0,0
      infoText:setFillColor( gv.fontColourR, gv.fontColourG, gv.fontColourB )
      yPosition = yPosition + 20
      sceneGroup:insert(infoText[counter])
      counter = counter + 1
    end
  end

  if (pass == false) then
    local emptyText = display.newText("Sorry, You do not know anyting about any tiles", xPosition, yPosition,
      BG.width*0.9, 0, gv.font, gv.fontSize)
    emptyText:setFillColor( gv.fontColourR, gv.fontColourG, gv.fontColourB )
    sceneGroup:insert(emptyText)
  end

  local btnOkay = widget.newButton
    {
      width         = 50,
      height        = 20,
      shape         = "roundedRect",
      cornerRadius  = 10,
      label         = "Okay",
      id            = "btnOkay",
      top           =  BG.y + BG.height/2 - BG.height*0.2,
      left          =  (BG.x + BG.width)/2,
      onEvent       = okay
  }

  sceneGroup:insert(btnOkay)

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