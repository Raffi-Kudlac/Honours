--[[
Purpose:
This screen is the menu screen currently only holding the play button.

]]

local composer  = require( "composer" )
local gv        = require( "global" )
local widget    = require( "widget" )
local parse     = require ( "mod_parse")
local scene     = composer.newScene()
local sceneGroup

-------------------------------------------------
-- PRIVATE FUNCTIONS
-------------------------------------------------

local function createText()

    local startingX = widthCalculator(0.5)
    local startingY = heightCalculator(0.4)

    local title = display.newText("The Source", startingX,
    startingY, gv.font, gv.fontSize*4 )
   --title.anchorX, title.anchorY = 0,0
     title:setFillColor( gv.fontColourR, gv.fontColourG, gv.fontColourB )
     
     startingY = startingY + heightCalculator(0.15)
     local loading = display.newText("Loading...", startingX,
          startingY, gv.font, gv.fontSize*3 )        
     loading:setFillColor( gv.fontColourR, gv.fontColourG, gv.fontColourB )
     
     sceneGroup:insert(title)
     sceneGroup:insert(loading)

end

local function movingOn( event )

  composer.gotoScene("mining")    
  startingPower()
  composer.gotoScene("hydro")
  composer.gotoScene("natural")
  composer.gotoScene("busness")
  composer.gotoScene("groupScreen")
  composer.gotoScene("advertismentScreen")
  composer.gotoScene("publicServisesScreen")  
  composer.gotoScene("mining")
  composer.gotoScene("resourseMap")  
  composer.gotoScene("blackoutInfo")  
  composer.gotoScene("city")

end

-------------------------------------------------
-- COMPOSER FUNCTIONS
-------------------------------------------------

-- "scene:create()"
function scene:create( event )

  sceneGroup = self.view
  
  local bg = display.newImage("Images/natural_resource_screen/nr_Background.png")
  bg.anchorX, bg.anchorY = 0,0

  bg.height = display.contentHeight
  bg.width = display.contentWidth

  bg.x = 0
  bg.y = 0
  
  sceneGroup:insert(bg)
  createText()
  
  timer.performWithDelay(500, movingOn)
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