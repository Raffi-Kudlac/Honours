local composer  = require( "composer" )
local widget    = require( "widget" )
local gv        = require( "global" )

local scene           = composer.newScene()
local cityOptionsBG   = widget
local cityOptionsLeft = 0
local cityOptionsTop  = 0
local shiftConstant   = 280
local prosWidth       = 0
local prosHeight      = 0
local cityMessage     = ""
local costText        = ""
local infoText        = ""

-------------------------------------------------
-- PRIVATE FUNCTIONS
-------------------------------------------------
local function createText()

  local xPosition = (cityOptionsBG.x - cityOptionsBG.width/2) + cityOptionsBG.x*0.1
  local yPosition = (cityOptionsBG.y - cityOptionsBG.height/2) + cityOptionsBG.y*0.1

  costText = display.newText("Costs: $"..gv.tileClicked.tile:getCost(), xPosition,
    yPosition, gv.font, gv.fontSize )
  costText.anchorX,costText.anchorY = 0,0
  costText:setFillColor( gv.fontColourR, gv.fontColourG, gv.fontColourB )

  infoText = display.newText(cityMessage, costText.x,costText.y +20,prosWidth,prosHeight, gv.font,gv.fontSize)
  infoText.anchorX, infoText.anchorY = 0,0
  infoText:setFillColor( gv.fontColourR, gv.fontColourG, gv.fontColourB )
  infoText.height = infoText.height + 15
end

local function buy(event)

  if(event.phase == "began") then    
      gv.money = gv.money - gv.tileClicked.tile:getCost()
      setMoney()
      convertButton("Images/land_screen/lnd_tile_plain.png",gv.marker, "open")
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
  cityMessage = "The city owns this land and it must be bought from them. "..
    "land is in high demand, everyone wants a piece so the cost is high. Once "..
    "you buy this you can sell it again but you sell it at a lower price then what you bought it for. "..
    "If you buy this then you still need to pay to put an istablishment on the location as well"


  cityOptionsTop  = centerY(shiftConstant)
  cityOptionsLeft = centerX(shiftConstant) + 20

  cityOptionsBG = widget.newButton
    {
      width       = widthCalculator(0.6),
      height      = heightCalculator(0.6),
      defaultFile = "Images/global_images/Horizontal_Box.png",
      id          = "BO",
      left        = centerX(widthCalculator(0.5)),
      top         = centerY(heightCalculator(0.5) + heightCalculator(0.1) ),
  }

  prosWidth = cityOptionsBG.width*0.8
  createText()

  local btnBuy = widget.newButton
    {
      width = cityOptionsBG.width*0.2,
      height = cityOptionsBG.height*0.15,
      defaultFile = "Images/global_images/button1.png",      
      label       = "Buy",
      id          = "btnBuy",
      top         = infoText.y + infoText.height,
      left        = centerX(cityOptionsBG.width*0.2) - cityOptionsBG.width*0.15,
      onEvent = buy
  }

  btnBuy.anchorY = 0

  local btnCancel = widget.newButton
    {
      width = cityOptionsBG.width*0.2,
      height = cityOptionsBG.height*0.15,
      defaultFile = "Images/global_images/button1.png",       
      label = "Cancel",
      id = "btnCancel",
      top = btnBuy.y,
      left = centerX(cityOptionsBG.width*0.2) + cityOptionsBG.width*0.15,
      onEvent = cancel
  }

  sceneGroup:insert(cityOptionsBG)
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