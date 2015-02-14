--[[
Purpose:
This screen is the menu screen currently only holding the play button.

]]

local composer  = require( "composer" )
local gv        = require( "global" )
local widget    = require( "widget" )
local scene     = composer.newScene()


local yShift
local prosWidth
local ownedRiverBG
local nameText
local producingText
local maintenenceText
local infoText
local prosHeight = 0

-------------------------------------------------
-- PRIVATE FUNCTIONS
-------------------------------------------------

local function createText(ownedOptionsBG)

  local xPosition = (ownedOptionsBG.x - ownedOptionsBG.width/2) + ownedOptionsBG.x*0.07
  local yPosition = (ownedOptionsBG.y - ownedOptionsBG.height/2) + ownedOptionsBG.y*0.1  
  local data = ""

  nameText = display.newText(gv.rivers[gv.riverSelected]:getName() .. " river", xPosition, 
    yPosition, gv.font, gv.fontSize)
  nameText.anchorX, nameText.anchorY = 0,0 
  nameText:setFillColor(gv.fontColourR, gv.fontColourG, gv.fontColourB)
  
  data = "Porducing " .. gv.rivers[gv.riverSelected]:getPowerGenerated() .. "GW"
  
  producingText = display.newText(data, xPosition, nameText.y + yShift, gv.font, gv.fontSize)
  producingText.anchorX, producingText.anchorY = 0,0
  producingText:setFillColor(gv.fontColourR, gv.fontColourG, gv.fontColourB)
  
  data = "Costs $" .. gv.rivers[gv.riverSelected]:getMainteneceCost() .. " per month to maintain"
  
  maintenenceText = display.newText(data, xPosition, producingText.y + yShift, prosWidth/2, prosHeight, 
  gv.font, gv.fontSize)
  maintenenceText.anchorX, maintenenceText.anchorY = 0,0
  maintenenceText:setFillColor(gv.fontColourR, gv.fontColourG, gv.fontColourB)
  
  data = "You can not demolish hydro plants. A giant wall of concrete holding back a mountain of water." ..
   " It would cots a fortune and the envirmental impact would be huge. It's better to just leave it standing. " .. 
   "This way we save money and we don't piss off the envirmentalists."
  
  infoText = display.newText(data, maintenenceText.x,maintenenceText.y + yShift*1.2,prosWidth,prosHeight, gv.font,gv.fontSize)
  infoText.anchorX, infoText.anchorY = 0,0
  infoText.height = infoText.height + 15
  infoText:setFillColor( gv.fontColourR, gv.fontColourG, gv.fontColourB )
end


local function cancel()
  composer.hideOverlay()
end

-------------------------------------------------
-- COMPOSER FUNCTIONS
-------------------------------------------------

-- "scene:create()"
function scene:create( event )

  local sceneGroup = self.view    
  
  local bgWidth = widthCalculator(0.45)
  local bgHeight = heightCalculator(0.65)

  ownedRiverBG = widget.newButton
  {
      width       = bgWidth,
      height      = bgHeight,
      defaultFile = "Images/global_images/Horizontal_Box.png",
      id          = "BO",
      left        = centerX(bgWidth),
      top         = centerY(heightCalculator(0.8)),
  }

  prosWidth = ownedRiverBG.width*0.8
  yShift = ownedRiverBG.height*0.1
  sceneGroup:insert(ownedRiverBG)
  createText(ownedRiverBG)
  
    local btnOkay = widget.newButton
    {
      width         = bgWidth*0.2,
      height        = bgHeight*0.1,
      shape         = "roundedRect",
      cornerRadius  = 10,
      label         = "Okay",
      id            = "btnOkay",
      top           = infoText.y + infoText.height - bgWidth*.02,
      left          = centerX(bgWidth*0.2),
      onEvent       = cancel
  }
  
  
  sceneGroup:insert(nameText)
  sceneGroup:insert(nameText)
  sceneGroup:insert(producingText)
  sceneGroup:insert(maintenenceText)
  sceneGroup:insert(infoText)
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