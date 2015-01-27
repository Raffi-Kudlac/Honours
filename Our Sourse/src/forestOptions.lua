--[[
Purpose:
This screen appears on top of the land screen (layOver screen) and is responcible
for displaying the choice to the user of buying the land so it could be built on

]]

local composer  = require( "composer" )
local widget    = require( "widget" )
local gv        = require( "global" )

local scene             = composer.newScene()
local forestOptionsBG   = widget
local forestOptionsLeft = 0
local forestOptionsTop  = 0
local shiftConstant     = 280
local prosWidth         = 0
local prosHeight        = 0

local forestMessage = ""
local costText      = ""
local infoText      = ""


-------------------------------------------------
-- PRIVATE FUNCTIONS
-------------------------------------------------
local function createText()

  local xPosition = (forestOptionsBG.x - forestOptionsBG.width/2) + forestOptionsBG.x*0.1
  local yPosition = (forestOptionsBG.y - forestOptionsBG.height/2) + forestOptionsBG.y*0.1

  costText = display.newText("Costs: "..gv.tileClicked.tile:getCost().." B", xPosition,
    yPosition, gv.font, gv.fontSize )
  costText:setFillColor( gv.fontColourR, gv.fontColourG, gv.fontColourB )
  costText.anchorX,costText.anchorY = 0,0

  infoText = display.newText(forestMessage, costText.x, costText.y + 20,prosWidth,prosHeight, gv.font,gv.fontSize)
  infoText.anchorX, infoText.anchorY = 0,0
  infoText:setFillColor( gv.fontColourR, gv.fontColourG, gv.fontColourB )
  infoText.height = infoText.height + 15
end


local function buy(event)

  if(event.phase == "began") then

    if(gv.money >= gv.tileClicked.tile:getCost()) then
      gv.money = gv.money - gv.tileClicked.tile:getCost()
      setMoney()
      convertButton("Images/land_screen/lnd_tile_plain.png",gv.marker, "open")
    end

    composer.hideOverlay()
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

  local sceneGroup = self.view
  forestMessage = "You must buy this unihabited land from the city and once you do you are free to build"..
    " on it. This costs a little bit more then buting land from the city as you have to landscape it to make it "..
    "usable."


  forestOptionsTop  = centerY(shiftConstant)
  forestOptionsLeft = centerX(shiftConstant) + 20

  forestOptionsBG = widget.newButton
    {
      width       = widthCalculator(0.5),
      height      = heightCalculator(0.5),
      defaultFile = "Images/global_images/Horizontal_Box.png",
      id          = "BO",
      left        = centerX(widthCalculator(0.5)),
      top         = centerY(heightCalculator(0.5)),
  }

  prosWidth = forestOptionsBG.width*0.8
  createText()

  local btnBuy = widget.newButton
    {
      width         = 60,
      height        = 20,
      shape         = "roundedRect",
      cornerRadius  = 10,
      label         = "Buy",
      id            = "btnBuy",
      top           = infoText.y + infoText.height,
      left          = costText.x,
      onEvent       = buy
  }

  btnBuy.anchorY = 0

  local btnCancel = widget.newButton
    {
      width         = 60,
      height        = 20,
      shape         = "roundedRect",
      cornerRadius  = 10,
      label         = "Cancel",
      id            = "btnCancel",
      top           = btnBuy.y,
      left          = btnBuy.x + forestOptionsBG.width*0.4,
      onEvent       = cancel
  }

  sceneGroup:insert(forestOptionsBG)
  sceneGroup:insert(costText)
  sceneGroup:insert(infoText)
  sceneGroup:insert(btnBuy)
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