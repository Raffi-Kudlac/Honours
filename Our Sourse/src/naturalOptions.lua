--[[
Purpose:
This screen appears on top of the land screen (layOver screen) and is responcible
for displaying possible build options to the user. This screen only appears if the user owns
the land that he/she selected.

]]

local composer = require( "composer" )
local widget   = require( "widget" )
local gv       = require( "global" )

local scene               = composer.newScene()
local circleWidth         = 30
local circleHeight        = 30
local buildOptionsTop     = 0
local buildOptionsLeft    = 0
local d                   = 280
local prosWidth           = 0
local prosHeight          = 0
local buildOptions = 0
local scrollText = 0

local costText            = ""
local productionText      = ""
local prosText            = ""
local consText            = ""
local consumptionText     = ""
local currentEnergySourse = powerPlant


-------------------------------------------------
-- PRIVATE FUNCTIONS
-------------------------------------------------

local function createText(ffSpecs)

  currentEnergySourse = ffSpecs

  local textX = (buildOptions.x - buildOptions.width/2) + buildOptions.width*0.25
  local textY = (buildOptions.y - buildOptions.height/2) + buildOptions.height*0.06

  costText = display.newText("Costs: $"..ffSpecs:getCost(), textX,
    textY, gv.font, gv.fontSize )
  costText.anchorX,costText.anchorY = 0,0
  costText:setFillColor( gv.fontColourR, gv.fontColourG, gv.fontColourB )

  productionText = display.newText("Produses: "..ffSpecs:getProduces().."GW",costText.x,costText.y+20,gv.font,gv.fontSize)
  productionText.anchorX,productionText.anchorY = 0,0
  productionText:setFillColor( gv.fontColourR, gv.fontColourG, gv.fontColourB )

  consumptionText = display.newText("Consumes: Nothing",costText.x,productionText.y+20,gv.font,gv.fontSize)
  consumptionText.anchorX,consumptionText.anchorY = 0,0
  consumptionText:setFillColor( gv.fontColourR, gv.fontColourG, gv.fontColourB )

  scrollText = widget.newScrollView
    {
      width = buildOptions.width*0.65,
      height = buildOptions.height*0.5,
      horizontalScrollDisabled = true,
      --        scrollWidth = buildOverlayWidth*0.9,
      --scrollHeight = buildOverlayWidth*0.5,
      hideBackground = true,
      top = consumptionText.y + 20,
      left = costText.x
  }

  prosText = display.newText(ffSpecs:getPros(), 5,10,scrollText.width*0.95,prosHeight, gv.font,gv.fontSize)
  prosText.anchorX, prosText.anchorY = 0,0
  prosText.height = prosText.height + 15
  prosText:setFillColor( gv.fontColourR, gv.fontColourG, gv.fontColourB )

  consText = display.newText(ffSpecs:getCons(), 5,prosText.y + prosText.height, scrollText.width*0.95,prosHeight, gv.font,gv.fontSize)
  consText.anchorX, consText.anchorY = 0,0
  consText.height = consText.height + 15
  consText:setFillColor( gv.fontColourR, gv.fontColourG, gv.fontColourB )
end

function setNaturalCurrentEnergySourse(ffSpecs)
  currentEnergySourse = ffSpecs
end

local function setText(ffSpecs, kind)

  currentEnergySourse = ffSpecs
  costText.text = "Costs: $"..ffSpecs:getCost()
  productionText.text = "Produces: "..ffSpecs:getProduces().."GW"
  consumptionText.text = "Consumes: Nothing"
  prosText.text = ffSpecs:getPros()
  consText.text = ffSpecs:getCons()

end


function naturalPurchasedConfirmed()

  gv.money    = gv.money - currentEnergySourse:getCost()
  gv.groups[0]:setStatus(0.5)

  if(currentEnergySourse:getType() =="solar") then
    gv.solarBuildCounter = gv.solarBuildCounter + 1
    gv.naturalLandUsedCounter = gv.naturalLandUsedCounter +1
    naturalConvertButton("Images/natural_resource_screen/nr_tile_solar.png",gv.marker, "solar")
  elseif(currentEnergySourse:getType() =="wind") then
    gv.groups[3]:setStatus(-1)    
    gv.windBuildCounter = gv.windBuildCounter + 1
    gv.naturalLandUsedCounter = gv.naturalLandUsedCounter +1
    naturalConvertButton("Images/natural_resource_screen/nr_tile_wind.png",gv.marker, "wind")
  end

end


local function buy( event )

  if (event.phase == "began") then       
      naturalPurchasedConfirmed()
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
-- PUBLIC FUNCTIONS
-------------------------------------------------

-- "scene:create()"
function scene:create( event )

  local sceneGroup  = self.view
  buildOptionsTop   = centerY(d)
  buildOptionsLeft  = centerX(widthCalculator(0.5))
  local widthShift  = 10
  local heightShift = 20

  buildOptions = widget.newButton
    {
      width       = widthCalculator(0.5),
      height      = heightCalculator(0.85),
      defaultFile = "Images/natural_resource_screen/nr_buildOverlay.png",
      id          = "BO",
      left        = centerX(widthCalculator(0.5)),
      top         = centerY(heightCalculator(0.85)),
  }
  prosWidth = buildOptions.width * 0.7
  local buttonX = (buildOptions.x - buildOptions.width/2) + buildOptions.width*0.04
  local buttonY = (buildOptions.y - buildOptions.height/2) + buildOptions.height*0.05
  createText(gv.solarSpecs)

  local btnSolar = widget.newButton
    {
      width       = circleWidth,
      height      = circleHeight,
      id          = "btnsolar",
      defaultFile = "Images/natural_resource_screen/nr_solar.png",
      onEvent     = function() return setText(gv.solarSpecs, "solar") end,
      top         = buildOptionsTop + heightShift,
      left        = buttonX
  }

  heightShift  = heightShift + 40

  local btnWind = widget.newButton
    {
      width       = circleWidth,
      height      = circleHeight,
      defaultFile = "Images/natural_resource_screen/nr_wind.png",
      id          = "btnwind",
      onEvent     = function() return setText(gv.windSpecs, "wind") end,
      top         = btnSolar.y + 30,
      left        = buttonX
  }


  local btnBuy = widget.newButton
    {
      width         = 50,
      height        = 20,
      shape         = "roundedRect",
      cornerRadius  = 10,
      label         = "Buy",
      id            = "btnBuy",
      top           = (scrollText.y + scrollText.height/2) + buildOptions.height*0.05,
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
      left          = btnBuy.x + buildOptions.width*0.3,
      onEvent       = cancel
  }

  sceneGroup:insert(buildOptions)
  sceneGroup:insert(btnSolar)
  sceneGroup:insert(btnWind)
  sceneGroup:insert(costText)
  sceneGroup:insert(productionText)
  sceneGroup:insert(consumptionText)
  scrollText:insert(prosText)
  scrollText:insert(consText)
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