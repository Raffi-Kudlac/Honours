--[[
Purpose:
This screen appears on top of the land screen (layOver screen) and is responcible
for displaying the option of demolishing the power plant to the user
]]

local composer = require( "composer" )
local widget   = require( "widget" )
local scene    = composer.newScene()
local gv       = require( "global" )

local ownedOptionsBG    = widget
local ownedOptionsLeft  = 0
local ownedOptionsTop   = 0
local shiftConstant     = 280
local prosWidth         = shiftConstant*0.7
local prosHeight        = 0
local yShift = 0

local message   = ""
local infoText  = ""

local demolishCost = 0 -- cost to demolish will be 90% the cost to build
local resourceConsumptionText = ""
local maintenenceText = ""
local producingText = ""
local demolishText = ""

-------------------------------------------------
-- PRIVATE FUNCTIONS
-------------------------------------------------

local function createText()

  local xPosition = (ownedOptionsBG.x - ownedOptionsBG.width/2) + ownedOptionsBG.x*0.07
  local yPosition = (ownedOptionsBG.y - ownedOptionsBG.height/2) + ownedOptionsBG.y*0.1  
  local specs = 0
  local data = ""
  
  local type = gv.tileClicked.tile:getTypeOfPowerPlant()
  
  if ( type == "oil" ) then
      type = "Oil"
      specs = gv.oilSpecs
  elseif ( type == "coal" ) then
      type = "Coal"
      specs = gv.coalSpecs
  elseif ( type == "gas" ) then
      type = "Gas"
      specs = gv.gasSpecs
  elseif ( type == "nuclear" ) then
      type = "Uranium"
      specs = gv.nuclearSpecs
  end

  demolishCost = math.round(specs:getCost()*0.90)

  producingText = display.newText("Can produce " .. specs:getProduces() .. " GW per month", xPosition, 
    yPosition, gv.font, gv.fontSize)
  producingText.anchorX, producingText.anchorY = 0,0 
  producingText:setFillColor(gv.fontColourR, gv.fontColourG, gv.fontColourB)
  
  data = "Consumes " .. specs:getConsumption() .." units of " .. type .. " per month"
  
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
--
  infoText = display.newText(message, demolishText.x,demolishText.y + yShift,prosWidth,prosHeight, gv.font,gv.fontSize)
  infoText.anchorX, infoText.anchorY = 0,0
  infoText.height = infoText.height + 15
  infoText:setFillColor( gv.fontColourR, gv.fontColourG, gv.fontColourB )
end


local function demolish(event)

  if(event.phase == "began") then    
      gv.money = gv.money - demolishCost
      groupCheck()
      convertButton("Images/land_screen/lnd_tile_plain.png",gv.marker, "open")
      
      
      local type = gv.tileClicked.tile:getTypeOfPowerPlant()
  
      if ( type == "oil" ) then
         gv.oilBuildCounter = gv.oilBuildCounter - 1
      elseif ( type == "coal" ) then
         gv.coalBuildCounter = gv.coalBuildCounter - 1
      elseif ( type == "gas" ) then
         gv.gasBuildCounter = gv.gasBuildCounter - 1
      elseif ( type == "nuclear" ) then
         gv.nuclearBuildCounter = gv.nuclearBuildCounter - 1
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

  -- Initialize the scene here.
  -- Example: add display objects to "sceneGroup", add touch listeners, etc.
  local sceneGroup = self.view

  message = "From here you can demolish your power plant, returning the land to the open state. " ..
    "It costs money to demolish a power plant but it could be worth it if the current one isn't generating any power. " ..
    " After the plant is gone you can chose to build another plant in its stead. "
    
  local bgWidth = widthCalculator(0.6)
  local bgHeight = heightCalculator(0.7)

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
  

  local btnDemolish = widget.newButton
    {
      width         = bgWidth*0.3,
      height        = bgHeight*0.15,
      defaultFile = "Images/global_images/button1.png",
      label         = "Demolish",
      id            = "btnBuy",
      top           = infoText.y + infoText.height*0.75,
      left          = demolishText.x,
      onEvent       = demolish
  }

  btnDemolish.anchorY = 0

  local btnCancel = widget.newButton
    {
      width         = bgWidth*0.27,
      height        = bgHeight*0.15,
      defaultFile = "Images/global_images/button1.png",
      label         = "Cancel",
      id            = "btnCancel",
      top           = btnDemolish.y,
      left          = btnDemolish.x + ownedOptionsBG.width*0.4,
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