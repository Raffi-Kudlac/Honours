--[[
Purpose:
This screen is repsoncible for demolishing built solor and wind structures
]]

local composer = require( "composer" )
local widget   = require( "widget" )
local scene    = composer.newScene()
local gv       = require( "global" )

local ownedOptionsBG    = widget
local ownedOptionsLeft  = 0
local ownedOptionsTop   = 0
local shiftConstant     = 280
local prosWidth         = 0
local prosHeight        = 0

local message   = ""
local costText  = ""
local infoText  = ""


-------------------------------------------------
-- PRIVATE FUNCTIONS
-------------------------------------------------
local function createText()

  local xPosition = (ownedOptionsBG.x - ownedOptionsBG.width/2) + ownedOptionsBG.x*0.1
  local yPosition = (ownedOptionsBG.y - ownedOptionsBG.height/2) + ownedOptionsBG.y*0.1

  costText = display.newText("Costs: $4 B", xPosition,
    yPosition, gv.font, gv.fontSize )
  costText.anchorX,costText.anchorY = 0,0
  costText:setFillColor( gv.fontColourR, gv.fontColourG, gv.fontColourB )

  infoText = display.newText(message, costText.x,costText.y +20,prosWidth,prosHeight, gv.font,gv.fontSize)
  infoText.anchorX, infoText.anchorY = 0,0
  infoText.height = infoText.height + 15
  infoText:setFillColor( gv.fontColourR, gv.fontColourG, gv.fontColourB )
end


local function demolish(event)

  if(event.phase == "began") then

    if(gv.money >= 4) then
      gv.money = gv.money - 4
      convertButton("Images/land_screen/lnd_tile_plain.png",gv.marker, "open")
      composer.hideOverlay()
    end

  end
end


local function cancel()
  composer.hideOverlay()
end


-------------------------------------------------
-- COMPOSER FUNCTIONS
-------------------------------------------------

-- "scene:create()"
function scene:create( event )

  -- Initialize the scene here.
  -- Example: add display objects to "sceneGroup", add touch listeners, etc.
  local sceneGroup = self.view

  message = "From here you can demlosh you power plant, returning the land to the open state. " ..
    "It costs money to demolish a power plant but it could be worth it if the current one isn't generating any power. " ..
    " After the plant is gone you can chose to build another plant in its stead. "


  ownedOptionsTop = centerY(shiftConstant)
  ownedOptionsLeft = centerX(shiftConstant) + 20

  ownedOptionsBG = widget.newButton
    {
      width       = widthCalculator(0.6),
      height      = heightCalculator(0.5),
      defaultFile = "Images/global_images/Horizontal_Box.png",
      id          = "BO",
      left        = centerX(widthCalculator(0.6)),
      top         = centerY(heightCalculator(0.6)),
  }
  prosWidth = ownedOptionsBG.width*0.8
  createText()

  local btnDemolish = widget.newButton
    {
      width         = 80,
      height        = 20,
      shape         = "roundedRect",
      cornerRadius  = 10,
      label         = "Demolish",
      id            = "btnBuy",
      top           =  infoText.y + infoText.height,
      left          = costText.x,
      onEvent       = demolish
  }

  btnDemolish.anchorY = 0

  local btnCancel = widget.newButton
    {
      width         = 60,
      height        = 20,
      shape         = "roundedRect",
      cornerRadius  = 10,
      label         = "Cancel",
      id            = "btnCancel",
      top           = btnDemolish.y,
      left          = btnDemolish.x + ownedOptionsBG.width*0.4,
      onEvent       = cancel
  }

  sceneGroup:insert(ownedOptionsBG)
  sceneGroup:insert(costText)
  sceneGroup:insert(infoText)
  sceneGroup:insert(btnDemolish)
  sceneGroup:insert(btnCancel)
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


-- -------------------------------------------------------------------------------

return scene