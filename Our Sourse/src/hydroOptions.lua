--[[
Purpose:
This screen is for displaying specific info to the user about the river he/she has selected.
The user will also be presented with the option to dam the current river.
]]

local composer = require( "composer" )
local widget   = require( "widget" )
local gv       = require( "global" )

local scene           = composer.newScene()
local d               = 280
local damOptionsLeft  = 0
local damOptionsTop   = 0
local textWidth       = d*0.7
local textHeight      = 0

-------------------------------------------------
-- PRIVATE FUNCTIONS
-------------------------------------------------

local function createText(sceneGroup)

  local textVerticalShift = 15


  local nme = " The " .. gv.rivers[gv.riverSelected]:getName() .. " river"

  local riverName = display.newText(nme, damOptionsLeft + 55,
    damOptionsTop + 20, gv.font, gv.fontSize )
  riverName.anchorX,riverName.anchorY = 0,0

  local costMessage = "Cost to build: $" .. tostring(gv.rivers[gv.riverSelected]:getCost()) .. " B"

  local costText = display.newText(costMessage, damOptionsLeft + 55,
    riverName.y + textVerticalShift, gv.font, gv.fontSize )
  costText.anchorX,costText.anchorY = 0,0

  local destruction = "Area flooded: " .. tostring(gv.rivers[gv.riverSelected]:getAD()) .. " m cubed"

  local adText = display.newText(destruction, damOptionsLeft + 55,
    costText.y + textVerticalShift, gv.font, gv.fontSize )
  adText.anchorX,adText.anchorY = 0,0

  local powerProduced = "Power Produced: " .. tostring(gv.rivers[gv.riverSelected]:getPowerGenerated()) .. " GW"

  local powerText = display.newText(powerProduced, damOptionsLeft + 55,
    adText.y + textVerticalShift, gv.font, gv.fontSize )
  powerText.anchorX,powerText.anchorY = 0,0


  local info = display.newText(gv.rivers[gv.riverSelected]:getData(), damOptionsLeft + 55, costText.y + 100,textWidth, textHeight, gv.font,gv.fontSize)
  info.anchorX, info.anchorY = 0,0

  sceneGroup:insert(riverName)
  sceneGroup:insert(costText)
  sceneGroup:insert(adText)
  sceneGroup:insert(powerText)
  sceneGroup:insert(info)
end


local function cancel(event)

  if(event.phase == "began") then
    composer.hideOverlay()
  end
end


local function confirmPurchase()

  gv.money = gv.money - gv.rivers[gv.riverSelected]:getCost()
  gv.rivers[gv.riverSelected]:setBuilt()
  setMoney()
end


local function damed(event)

  if (event.phase == "began") then
    if (gv.money >= gv.rivers[gv.riverSelected]:getCost()) then
      confirmPurchase()
      changeImage()
      composer.hideOverlay()
    end
  end
end

-------------------------------------------------
-- COMPOSER FUNCTIONS
-------------------------------------------------

-- "scene:create()"
function scene:create( event )

  local sceneGroup = self.view
  damOptionsLeft = centerX(d)
  damOptionsTop = centerY(d)

  local damOptions = widget.newButton
    {
      width       = d -20,
      height      = d -10,
      defaultFile = "Images/land_screen/lnd_buildOverlay.png",
      id          = "BO",
      left        = centerX(d),
      top         = centerY(d),
  }

  local btnDam = widget.newButton
    {
      width         = 50,
      height        = 20,
      shape         = "roundedRect",
      cornerRadius  = 10,
      label         = "Dam",
      id            = "btnMine",
      top           =  damOptions.height - 20,
      left          =  damOptionsLeft+80,
      onEvent       = damed
  }

  local btnCancel = widget.newButton
    {
      width         = 60,
      height        = 20,
      shape         = "roundedRect",
      cornerRadius  = 10,
      label         = "Cancel",
      id            = "btnCancel",
      top           = btnDam.y,
      left          = btnDam.x + 70,
      onEvent       = cancel
  }

  btnDam.anchorY = 0



  sceneGroup:insert(damOptions)
  sceneGroup:insert(btnDam)
  sceneGroup:insert(btnCancel)

  createText(sceneGroup)
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