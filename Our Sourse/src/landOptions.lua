--[[
Purpose:
This screen appears on top of the land screen (layOver screen) and is responcible
for displaying possible build options to the user. This screen only appears if the user owns
the land that he/she selected.

]]

local composer = require( "composer" )
local widget   = require( "widget" )
local gv       = require( "global" )

local scene             = composer.newScene()
local circleWidth       = 30
local circleHeight      = 30
local buildOptionsTop   = 0
local buildOptionsLeft  = 0
local buildOverlayWidth = 260
local prosWidth         = buildOverlayWidth*0.7
local prosHeight        = 0

local buildOptions = 0

local scrollText        = 0
local costText          = ""
local productionText    = ""
local prosText          = ""
local consText          = ""
local consumptionText   = ""
local maintenenceText   = ""
local currentEnergySourse = powerPlant

-------------------------------------------------
-- PRIVATE FUNCTIONS
-------------------------------------------------

local function createText(ffSpecs)

  local data = ""
  currentEnergySourse = ffSpecs
  
  local type = ffSpecs:getType()
  
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

  local textX = (buildOptions.x - buildOptions.width/2) + buildOptions.width*0.25
  local textY = (buildOptions.y - buildOptions.height/2) + buildOptions.height*0.06

  costText = display.newText("Costs: $"..ffSpecs:getCost(), textX,
    textY, gv.font, gv.fontSize )
  costText.anchorX,costText.anchorY = 0,0
  costText:setFillColor( gv.fontColourR, gv.fontColourG, gv.fontColourB )

  productionText = display.newText("Produses: "..ffSpecs:getProduces().."GW",costText.x,costText.y+20,gv.font,gv.fontSize)
  productionText.anchorX,productionText.anchorY = 0,0
  productionText:setFillColor( gv.fontColourR, gv.fontColourG, gv.fontColourB )

  data = "Consumes: "..ffSpecs:getConsumption() .. " unit of " .. type .. " per month"

  consumptionText = display.newText( data,costText.x,productionText.y+20,
  buildOptions.width*0.4, 0, gv.font,gv.fontSize)
  consumptionText:setFillColor( gv.fontColourR, gv.fontColourG, gv.fontColourB )
  consumptionText.anchorX,consumptionText.anchorY = 0,0
  
  data = "Costs $" .. ffSpecs:getMaintenenceCost() .. " per month to maintain"
  
  maintenenceText = display.newText(data, costText.x, consumptionText.y + 30, 
  gv.font, gv.fontSize)
  maintenenceText.anchorX, maintenenceText.anchorY = 0,0
  maintenenceText:setFillColor(gv.fontColourR, gv.fontColourG, gv.fontColourB)


  scrollText = widget.newScrollView
    {
      width = buildOverlayWidth*0.75,
      height = buildOverlayWidth*0.5,
      horizontalScrollDisabled = true,
      --        scrollWidth = buildOverlayWidth*0.9,
      -- scrollHeight = buildOverlayWidth*0.5,
      hideBackground = true,
  }
  scrollText.anchorX, scrollText.anchorY = 0,0
  scrollText.x = costText.x
  scrollText.y = maintenenceText.y + 20

  prosText = display.newText(ffSpecs:getPros(), 5,10,scrollText.width*0.95,prosHeight, gv.font,gv.fontSize)
  prosText.anchorX, prosText.anchorY = 0,0
  prosText.height = prosText.height + 15
  prosText:setFillColor( gv.fontColourR, gv.fontColourG, gv.fontColourB )

  scrollText:insert(prosText)

  consText = display.newText(ffSpecs:getCons(), prosText.x,prosText.y + prosText.height, prosWidth,prosHeight, gv.font,gv.fontSize)
  consText.anchorX, consText.anchorY = 0,0
  consText.height = consText.height + 15
  consText:setFillColor( gv.fontColourR, gv.fontColourG, gv.fontColourB )

  scrollText:insert(consText)

end

function setLandCurrentEnergySourse(ffSpecs)
  currentEnergySourse = ffSpecs
end

local function setText(ffSpecs, kind)

  currentEnergySourse = ffSpecs
  costText.text = "Costs: $"..ffSpecs:getCost()
  productionText.text = "Produces: "..ffSpecs:getProduces().."GW"
  consumptionText.text = "Consumes: "..ffSpecs:getConsumption() .. " unit of " .. kind .. " per month"
  maintenenceText.text = "Costs $" .. ffSpecs:getMaintenenceCost() .. " per month to maintain"
  prosText.text = ffSpecs:getPros()
  consText.text = ffSpecs:getCons()

end


function landPurchasedConfirmed()

  gv.money    = gv.money - currentEnergySourse:getCost()
  local kind  = "owned"

  if(currentEnergySourse:getType() =="oil") then
    convertButton("Images/land_screen/lnd_tile_oil.png",gv.marker, kind, "oil")
    gv.groups[0]:setStatus(-gv.oilInfluence)
    gv.oilBuildCounter = gv.oilBuildCounter + 1
  elseif(currentEnergySourse:getType() =="coal") then
    convertButton("Images/land_screen/lnd_tile_coal.png",gv.marker, kind, "coal")
    gv.groups[0]:setStatus(-gv.coalInfluence)
    gv.coalBuildCounter = gv.coalBuildCounter + 1
  elseif(currentEnergySourse:getType() =="gas") then
    gv.groups[0]:setStatus(-gv.gasInfluence)
    convertButton("Images/land_screen/lnd_tile_gas.png",gv.marker, kind, "gas")
    gv.gasBuildCounter = gv.gasBuildCounter + 1
  elseif(currentEnergySourse:getType() =="nuclear") then
    gv.groups[1]:setStatus(-gv.nuclearInfluence)
    convertButton("Images/land_screen/lnd_tile_nuke.png",gv.marker, kind, "nuclear")
    gv.nuclearBuildCounter = gv.nuclearBuildCounter + 1
  end

  print("The envirementalists level is")
  print(gv.groups[0]:getNumberStatus())

end


local function buy( event )

  if (event.phase == "began") then    
      landPurchasedConfirmed()
      setMoney()
      composer.hideOverlay()    
  end
end


local function cancel( event )

  if (event.phase == "began") then
    composer.hideOverlay()
  end
end


-------------------------------------------------
-- COMPOSER FUNCTIONS
-------------------------------------------------

-- "scene:create()"
function scene:create( event )

  local sceneGroup  = self.view
  buildOptionsTop   = centerY(buildOverlayWidth)
  buildOptionsLeft  = centerX(buildOverlayWidth) + 20
  local widthShift  = 10
  local heightShift = 20

  buildOptions = widget.newButton
    {
      width       = widthCalculator(0.5),
      height      = heightCalculator(0.85),
      defaultFile = "Images/land_screen/lnd_buildOverlay.png",
      id          = "BO",
      left        = centerX(widthCalculator(0.5)),
      top         = centerY(heightCalculator(0.85)),
  }

  local buttonX = (buildOptions.x - buildOptions.width/2) + buildOptions.width*0.04
  local buttonY = (buildOptions.y - buildOptions.height/2) + buildOptions.height*0.1

  local btnOil = widget.newButton
    {
      width       = circleWidth,
      height      = circleHeight,
      id          = "btnoil",
      defaultFile = "Images/land_screen/lnd_oil.png",
      onEvent     = function() return setText(gv.oilSpecs, "oil") end,
      top         = buttonY,
      left        = buttonX
  }


  local btnGas = widget.newButton
    {
      width       = circleWidth,
      height      = circleHeight,
      defaultFile = "Images/land_screen/lnd_gas.png",
      id          = "btngas",
      onEvent     = function() return setText(gv.gasSpecs, "gas") end,
      top         = btnOil.y + heightShift,
      left        = buttonX
  }


  local btnCoal = widget.newButton
    {
      width       = circleWidth,
      height      = circleHeight,
      defaultFile = "Images/land_screen/lnd_coal.png",
      id          = "btncoal",
      onEvent     = function() return setText(gv.coalSpecs, "coal") end,
      top         = btnGas.y + heightShift,
      left        = buttonX
  }


  local btnNP = widget.newButton
    {
      width       = circleWidth,
      height      = circleHeight,
      id          = "btnNP",
      defaultFile = "Images/land_screen/lnd_nuclear.png",
      onEvent     = function() return setText(gv.nuclearSpecs, "Uranium") end,
      top         = btnCoal.y + heightShift,
      left        = buttonX
  }

  createText(gv.oilSpecs)
  
  local btnActionWidth = buildOptions.width*0.25
  local btnActionHeight = buildOptions.height*0.12

  local btnBuy = widget.newButton
    {
      width         = btnActionWidth,
      height        = btnActionHeight,
      defaultFile = "Images/global_images/button1.png",
      label         = "Buy",
      id            = "btnBuy",
      top           = (scrollText.y + scrollText.height*0.9),
      left          = centerX(btnActionWidth) -buildOptions.width*0.1,
      onEvent       = buy
  }

  btnBuy.anchorY = 0

  local btnCancel = widget.newButton
    {
      width         = btnActionWidth,
      height        = btnActionHeight,
      defaultFile = "Images/global_images/button1.png",
      label         = "Cancel",
      id            = "btnCancel",
      top           = btnBuy.y,
      left          = centerX(btnActionWidth) + buildOptions.width*0.2,
      onEvent       = cancel
  }


  sceneGroup:insert(buildOptions)
  sceneGroup:insert(btnOil)
  sceneGroup:insert(btnGas)
  sceneGroup:insert(btnCoal)
  sceneGroup:insert(btnNP)


  sceneGroup:insert(costText)
  sceneGroup:insert(productionText)
  sceneGroup:insert(consumptionText)
  sceneGroup:insert(maintenenceText)
  --    scrollText:insert(prosText)
  --    scrollText:insert(consText)
  --    sceneGroup:insert(prosText)
  --    sceneGroup:insert(consText)
  sceneGroup:insert(scrollText)
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
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene