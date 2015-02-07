--[[
Purpose:
This screen is for displaying specific info to the user about the river he/she has selected.
The user will also be presented with the option to dam the current river.
]]

local composer = require( "composer" )
local widget   = require( "widget" )
local gv       = require( "global" )

local scene           = composer.newScene()
local damOptionsLeft  = 0
local damOptionsTop   = 0
local textWidth       
local textHeight      = 0
local damWidth 
local damHeight
local scrollText 

-------------------------------------------------
-- PRIVATE FUNCTIONS
-------------------------------------------------

local function createText(sceneGroup)

  local textVerticalShift = damHeight*0.1
  
  textWidth = damWidth*0.8

  local nme = gv.rivers[gv.riverSelected]:getName()

  local riverName = display.newText(nme, damOptionsLeft,
    damOptionsTop + 20, gv.font, gv.fontSize )
  riverName.anchorX,riverName.anchorY = 0,0
  
  riverName:setFillColor( gv.fontColourR, gv.fontColourG, gv.fontColourB )

  local costMessage = "Cost to build: $" .. tostring(gv.rivers[gv.riverSelected]:getCost())

  local costText = display.newText(costMessage, damOptionsLeft,
    riverName.y + textVerticalShift, gv.font, gv.fontSize )
  costText.anchorX,costText.anchorY = 0,0
  
  costText:setFillColor( gv.fontColourR, gv.fontColourG, gv.fontColourB )

  local destruction = "Area flooded: " .. tostring(gv.rivers[gv.riverSelected]:getAD()) .. " km squared"

  local adText = display.newText(destruction, damOptionsLeft,
    costText.y + textVerticalShift, damWidth*0.3, 0, gv.font, gv.fontSize )
  adText.anchorX,adText.anchorY = 0,0
  
  adText:setFillColor( gv.fontColourR, gv.fontColourG, gv.fontColourB )

  local powerProduced = "Power Produced: " .. tostring(gv.rivers[gv.riverSelected]:getPowerGenerated()) .. " GW"

  local powerText = display.newText(powerProduced, damOptionsLeft,
    adText.y + textVerticalShift*1.5, gv.font, gv.fontSize )
  powerText.anchorX,powerText.anchorY = 0,0
  
  powerText:setFillColor( gv.fontColourR, gv.fontColourG, gv.fontColourB )

  
  scrollText = widget.newScrollView
    {
      width = damWidth*0.75,
      height = damHeight*0.25,
      horizontalScrollDisabled = true,
      --        scrollWidth = buildOverlayWidth*0.9,
      -- scrollHeight = buildOverlayWidth*0.5,
      hideBackground = true,
  }
  scrollText.anchorX, scrollText.anchorY = 0,0
  scrollText.x = powerText.x
  scrollText.y = powerText.y + textVerticalShift
  

  local info = display.newText(gv.rivers[gv.riverSelected]:getData(), 0, 0 ,
  textWidth, textHeight, gv.font,gv.fontSize)
  info.anchorX, info.anchorY = 0,0
  
  info:setFillColor( gv.fontColourR, gv.fontColourG, gv.fontColourB )

  sceneGroup:insert(riverName)
  sceneGroup:insert(costText)
  sceneGroup:insert(adText)
  sceneGroup:insert(powerText)
  scrollText:insert(info)
  sceneGroup:insert(scrollText)
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
  damWidth = widthCalculator(0.45)
  damHeight = heightCalculator(0.75)
  
  damOptionsTop = centerY(damHeight)

  local damOptions = widget.newButton
    {
      width       = damWidth,
      height      = damHeight,
      defaultFile = "Images/global_images/Vertical_Box.png",
      id          = "BO",
      left        = centerX(damWidth),
      top         = centerY(damHeight),
  }
  
  damOptionsLeft = damOptions.x - damWidth/2.5
  local btnDam = widget.newButton
    {
      width         = 50,
      height        = 20,
      shape         = "roundedRect",
      cornerRadius  = 10,
      label         = "Dam",
      id            = "btnMine",
      top           =  damOptions.height - 10,
      left          =  damOptionsLeft,
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