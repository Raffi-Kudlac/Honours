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
local yShift = 0

local message   = ""
local infoText  = ""
local producingText
local resourceConsumptionText
local maintenenceText
local demolishText
local demolishCost = 0 -- will be 90% the cost of building


-------------------------------------------------
-- PRIVATE FUNCTIONS
-------------------------------------------------
local function createText()

  local xPosition = (ownedOptionsBG.x - ownedOptionsBG.width/2) + ownedOptionsBG.x*0.1
  local yPosition = (ownedOptionsBG.y - ownedOptionsBG.height/2) + ownedOptionsBG.y*0.1
  local data = ""
  local type = gv.tileClicked.tile:getType()
  local specs
  
  if ( type == "solar" ) then
      type = "Solar"
      specs = gv.solarSpecs
  elseif ( type == "wind" ) then
      type = "Wind"
      specs = gv.windSpecs  
  end
  
  demolishCost = specs:getCost()*0.9

  producingText = display.newText("Producing " .. specs:getProduces() .. " GW", xPosition, 
    yPosition, gv.font, gv.fontSize)
  producingText.anchorX, producingText.anchorY = 0,0 
  producingText:setFillColor(gv.fontColourR, gv.fontColourG, gv.fontColourB)
  
  data = "Consumes Nothing"
  
  resourceConsumptionText = display.newText(data, xPosition, producingText.y + yShift, gv.font, gv.fontSize)
  resourceConsumptionText.anchorX, resourceConsumptionText.anchorY = 0,0
  resourceConsumptionText:setFillColor(gv.fontColourR, gv.fontColourG, gv.fontColourB)
  
  data = "Costs $" .. specs:getMaintenenceCost() .. " per month to maintain"
  
  maintenenceText = display.newText(data, xPosition, resourceConsumptionText.y + yShift, 
  gv.font, gv.fontSize)
  maintenenceText.anchorX, maintenenceText.anchorY = 0,0
  maintenenceText:setFillColor(gv.fontColourR, gv.fontColourG, gv.fontColourB)

  demolishText = display.newText("Costs: $" .. demolishCost .. " to demolish", xPosition,
    maintenenceText.y + yShift, gv.font, gv.fontSize )
  demolishText.anchorX,demolishText.anchorY = 0,0
  demolishText:setFillColor( gv.fontColourR, gv.fontColourG, gv.fontColourB )

  infoText = display.newText(message, demolishText.x,demolishText.y + yShift,prosWidth,prosHeight, gv.font,gv.fontSize)
  infoText.anchorX, infoText.anchorY = 0,0
  infoText.height = infoText.height + 15
  infoText:setFillColor( gv.fontColourR, gv.fontColourG, gv.fontColourB )
end


local function naturaldemolish(event)

  if(event.phase == "began") then
      local type = gv.tileClicked.tile:getType()
      
      if (type == "wind") then
          gv.groups[3]:setStatus(1)
          gv.windBuildCounter = gv.windBuildCounter -1
      else
          gv.solarBuildCounter = gv.solarBuildCounter - 1 
      end
      gv.groups[0]:setStatus(-0.5)
      gv.money = gv.money - demolishCost
      naturalConvertButton("Images/natural_resource_screen/nr_tile_plain.png",gv.marker, "open")
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

  -- Initialize the scene here.
  -- Example: add display objects to "sceneGroup", add touch listeners, etc.
  local sceneGroup = self.view
  local bgWidth = widthCalculator(0.6)
  local bgHeight = heightCalculator(0.7)

  message = "From here you can demolish your power plant, returning the land to the open state. " ..
    "It costs money to demolish a power plant but it could be worth it if the current one isn't generating any power. " ..
    " After the plant is gone you can chose to build another plant in its stead. "


  ownedOptionsBG = widget.newButton
    {
      width       = bgWidth,
      height      = bgHeight,
      defaultFile = "Images/global_images/Horizontal_Box.png",
      id          = "BO",
      left        = centerX(bgWidth),
      top         = centerY(heightCalculator(0.8)),
  }
 
  prosWidth = ownedOptionsBG.width*0.8
  yShift = ownedOptionsBG.height*0.1
  createText()

  local btnWidth = ownedOptionsBG.width*0.3
  local btnHeight = ownedOptionsBG.height*0.15

  local btnDemolish = widget.newButton
    {
      width         = btnWidth,
      height        = btnHeight,
      defaultFile = "Images/global_images/button1.png",
      label         = "Demolish",
      id            = "btnBuy",
      top           =  infoText.y + infoText.height - bgWidth*.07,
      left          = infoText.x + ownedOptionsBG.width*0.1,
      labelColor = { default={ gv.buttonR, gv.buttonG, gv.buttonB }, over={ gv.buttonOver1,  gv.buttonOver2,  gv.buttonOver3,  gv.buttonOver4 } },
      onEvent       = naturaldemolish
  }

  btnDemolish.anchorY = 0

  local btnCancel = widget.newButton
    {
      width         = btnWidth,
      height        = btnHeight,
      defaultFile = "Images/global_images/button1.png",
      label         = "Cancel",
      id            = "btnCancel",
      top           = btnDemolish.y,
      left          = btnDemolish.x + ownedOptionsBG.width*0.2,
      labelColor = { default={ gv.buttonR, gv.buttonG, gv.buttonB }, over={ gv.buttonOver1,  gv.buttonOver2,  gv.buttonOver3,  gv.buttonOver4 } },
      onEvent       = cancel
  }

  sceneGroup:insert(ownedOptionsBG)
  sceneGroup:insert(resourceConsumptionText)
  sceneGroup:insert(maintenenceText)
  sceneGroup:insert(producingText)
  sceneGroup:insert(demolishText)
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