--[[
Purpose:
This screen shows the user what rivers he/she can dam. Here the hydro plants are displayed.
Hydro plants can't be dismantled and are perminant.
]]


local composer  = require( "composer")
local widget    = require( "widget" )
local gv        = require( "global" )
local scene     = composer.newScene()
local streams   = {}

-------------------------------------------------
-- PRIVATE FUNCTIONS
-------------------------------------------------

local function dam(riverSelected,event)

  local options = {
    isModal = true
  }

  if ( "began" == event.phase ) then
    if (streams[riverSelected].river:getBuilt() == false) then
      gv.riverSelected = riverSelected
      composer.showOverlay("hydroOptions", options)
    end

  end
end

function changeImage()

  streams[gv.riverSelected]:setLabel("damed")

end


-------------------------------------------------
-- COMPOSER FUNCTIONS
-------------------------------------------------

-- "scene:create()"
function scene:create( event )

  local sceneGroup = self.view

  local bg = display.newImage("Images/hydro_screen/hy_screen_bg.png")
  bg.anchorX, bg.anchorY = 0,0

  bg.height = display.contentHeight
  bg.width = display.contentWidth

  bg.x = 0
  bg.y = 0
  
  -- river 1
  
  streams[0] = widget.newButton
  {
      width = display.contentWidth,
      height = display.contentHeight,
      left = 0,
      top = 0,
      defaultFile = "Images/hydro_screen/hy_screen_river1.png"
  }
  streams[0].anchorY, streams[0].anchorX = 0,0
  streams[0].x = 0
  streams[0].y = 0
  
  local mask = graphics.newMask( "Images/hydro_screen/hy_screen_river1_mask.png" )
  local xScale = streams[0].width/2400
  local yScale = streams[0].height/1600
  
  streams[0]:setMask( mask )
  streams[0].maskScaleX = xScale
  streams[0].maskScaleY = yScale
  streams[0].maskX = streams[0].width/2
  streams[0].maskY = streams[0].height/2


--  bg:setMask( mask )
--  bg.maskScaleX = xScale 
--  bg.maskScaleY = yScale
--  bg.maskX = 0
--  bg.maskY = 0
  
  
    sceneGroup:insert(bg)
  sceneGroup:insert(streams[0])
--  sceneGroup:insert(streams[1])

--  streams[0] = widget.newButton
--    {
--      width     = 100,
--      height    = 50,
--      shape     = "roundedRect",
--      id        = "btnRiver1",
--      label     = "River1",
--      left      = centerX(100) - 100,
--      top       = centerY(50),
--      onEvent   = function(event) return dam(0,event) end,
--  }
--
--  streams[0].river =  gv.rivers[0]
--
--  streams[1] = widget.newButton
--    {
--      width     = 100,
--      height    = 50,
--      shape     = "roundedRect",
--      id        = "btnRiver2",
--      label     = "River2",
--      left      = centerX(100) + 50,
--      top       = centerY(50),
--      onEvent   = function(event) return dam(1,event) end,
--  }
--
--  streams[1].river = gv.rivers[1]

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