--[[
Purpose:
This screen is a hub for the user to more specifically choose what resource he/she would like to invest in

The middle pixle of the overlay waterfall in reference to the
background is x = 1016 and y = 519. The top left is x = 791 and the y = 294

The width and height of the overlay waterfall sqaure is 450 pxl.
]]


local composer = require( "composer" )
local widget   = require( "widget" )
local gv       = require( "global" )
require "mining"

local scene    = composer.newScene()
local width    = 150
local height   = 150

local function setText()

    local hydroCount = 0
    local dugCount = 0
    local naturalCount = 0
    
    
    dugCount = numberOfTilesMined()
    local naturalCount = gv.windBuildCounter + gv.solarBuildCounter
    
    for x = 0, 5, 1 do 
        if gv.rivers[x]:getBuilt() then
            hydroCounter = hydroCounter + 1
        end
    end
    
    setDataBox("Natural Land Used", naturalCount, 1)
    setDataBox("Rivers Damned", hydroCount, 2)
    setDataBox("Areas Dug", dugCount, 3)

end

-------------------------------------------------
-- COMPOSER FUNCTIONS
-------------------------------------------------

-- "scene:create()"
function scene:create( event )

  local sceneGroup = self.view

  local bg = display.newImage("Images/resource_screen/rec_hub_screen.png")
  bg.anchorX, bg.anchorY = 0,0

  bg.height = display.contentHeight
  bg.width = display.contentWidth
  
  local BGwidthScale = bg.width/2400
  local BGheightScale = bg.height/1600
  
  local xMatchUp = BGwidthScale*791
  local yMatchUp = BGheightScale*294
  
  bg.x = 0
  bg.y = 0

  local fossile_fuels = widget.newButton
    {
      top = bg.height* 0.02,
      left = bg.width*0.55,
      width = width,
      height = height,
      defaultFile = "Images/resource_screen/rec_fossil.png",
      onEvent = function() return goToScreen("mining") end,
  }

  fossile_fuels.anchorX, fossile_fuels.anchorY = 0,0

  local natural = widget.newButton
    {
      top = bg.height*0.08,
      left = bg.width*0.15,
      width = width*0.8,
      height = height*1.2,
      defaultFile = "Images/resource_screen/rec_natural.png",
      onEvent = function() return goToScreen("natural") end,
  }
  natural.anchorX, natural.anchorY = 0,0
  
  local mask = graphics.newMask( "Images/resource_screen/rec_natural_mask.png" )
  local xScale = natural.width/300
  local yScale = natural.height/200
  
  natural:setMask( mask )
  natural.maskScaleX = xScale
  natural.maskScaleY = yScale
  natural.maskX = natural.width/2
  natural.maskY = natural.height/2
  


  local hydro = widget.newButton
    {
      top = yMatchUp,
      left = xMatchUp,
      width = 450*BGwidthScale,
      height = 450*BGheightScale,
      defaultFile = "Images/resource_screen/rec_hydro.png",
      onEvent = function() return goToScreen("hydro") end,
  }

  hydro.anchorX, hydro.anchorY = 0.5,0.5
    
  sceneGroup:insert(bg)
  sceneGroup:insert(fossile_fuels)
  sceneGroup:insert(hydro)
  sceneGroup:insert(natural)

end


-- "scene:show()"
function scene:show( event )

  local sceneGroup = self.view
  local phase = event.phase

  if ( phase == "will" ) then
  -- Called when the scene is still off screen (but is about to come on screen).
      setText()
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