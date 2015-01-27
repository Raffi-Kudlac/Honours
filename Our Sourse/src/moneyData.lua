--[[
Purpose:
This screen is the menu screen currently only holding the play button.

]]

local composer  = require( "composer" )
local gv        = require( "global" )
local widget    = require( "widget" )
local scene     = composer.newScene()
local dimension = 280
local BG = 0

-------------------------------------------------
-- PRIVATE FUNCTIONS
-------------------------------------------------

local function okay ( event )

  if ( event.phase == "began") then
    composer.hideOverlay()
  end

end


local function makeText(sceneGroup)

  local pass = 0
  local moneyData = {}
  -- 0 addFee
  -- 1 Public Servises
  -- 2 Nuclear
  -- 3 Hydro
  -- 4 gas
  -- 5 oil
  -- 6 coal
  -- 7 population

  for x = 0, 7, 1 do
    moneyData[x] = {}
    for i = 0, 1, 1 do
      moneyData[x][i] = 0
    end
  end

  moneyData[0][0] = advertisementFee()
  moneyData[0][1] = "Advertisemnt Fees: "

  moneyData[1][0] = publicServisFee()
  moneyData[1][1] = "Public Servis Fees: "

  -- Nuclear Maintenence

  consumption = gv.nuclearSpecs:getConsumption()

  pass = 0
  for i = 1,gv.nuclearBuildCounter,1 do

    if (gv.resourcesHeld[3]-consumption*i >= 0) then
      pass = pass +1
    else
      break
    end
  end

  moneyData[2][0] = pass*gv.nuclearSpecs:getMaintenenceCost()
  moneyData[2][1] = "Nuclear Maintenence Cost: "

  local docMoney = 0
  --Hydro
  for i = 1, gv.hydroCounter - 1, 1 do
    if( gv.rivers[i]:getBuilt() ) then
      docMoney = docMoney + gv.rivers[i]:getMainteneceCost()
    end
  end

  moneyData[3][0] = docMoney
  moneyData[3][1] = "Hydro Maintenence Cost: "

  -- gas maintenence Cost

  pass = 0
  consumption = gv.gasSpecs:getConsumption()

  for i = 1, gv.gasBuildCounter, 1 do

    if (gv.resourcesHeld[1]-consumption*i >= 0) then
      pass = pass +1
    else
      break
    end
  end

  moneyData[4][0] = pass*gv.gasSpecs:getMaintenenceCost()
  moneyData[4][1] = "Gas Maintenence Cost: "


  -- oil maintenence Cost
  consumption = gv.oilSpecs:getConsumption()
  pass = 0

  for i = 1, gv.oilBuildCounter, 1 do

    if (gv.resourcesHeld[0]-consumption*i >= 0) then
      pass = pass +1
    else
      break
    end
  end

  moneyData[5][0] = pass*gv.oilSpecs:getMaintenenceCost()
  moneyData[5][1] = "Oil Maintenence Cost: "

  -- coal maintenence Cost
  consumption = gv.coalSpecs:getConsumption()
  pass = 0

  for i = 1, gv.coalBuildCounter, 1 do

    if (gv.resourcesHeld[2]-consumption*i >= 0) then
      pass = pass +1
    else
      break
    end
  end

  moneyData[6][0] = pass*gv.coalSpecs:getMaintenenceCost()
  moneyData[6][1] = "Coal Maintenence Cost: "

  if (gv.powerDemanded > gv.powerSupplied ) then
    moneyData[7][0] = 0
  else
    moneyData[7][0] = math.round(gv.powerDemanded * gv.moneyMadeFactor)
  end
  moneyData[7][1] = "Money Made from Population: "

  for i = 0, 6, 1 do
    moneyData[i][0] = moneyData[i][0]*-1
  end

  return moneyData

end

local function displayText(data, sceneGroup)

  local text = 0
  local xPosition = (BG.x - BG.width/2) + BG.width*0.1
  local yPosition = (BG.y - BG.height/2) + 10
  local total = 0

  for x =0,7, 1 do

    if (data[x][0] ~= 0 ) then
      text = display.newText(data[x][1] .. "$".. math.round(data[x][0]).."B", xPosition, yPosition, dimension - 20, 0, gv.font, gv.fontSize )
      text.anchorX,text.anchorY = 0,0
      text:setFillColor( gv.fontColourR, gv.fontColourG, gv.fontColourB )
      sceneGroup:insert(text)
      yPosition = yPosition + 20
      total = total + data[x][0]
    end

  end

  total = math.round(total)

  text = display.newText("Your total income is: $" .. total, xPosition, yPosition, dimension - 20, 0, gv.font, gv.fontSize)
  text.anchorX,text.anchorY = 0,0
  text:setFillColor( gv.fontColourR, gv.fontColourG, gv.fontColourB )
  sceneGroup:insert(text)

end


-------------------------------------------------
-- COMPOSER FUNCTIONS
-------------------------------------------------

-- "scene:create()"
function scene:create( event )

  local sceneGroup = self.view
  local passedMoneyData

  BG = widget.newButton
    {
      width       = widthCalculator(0.5),
      height      = heightCalculator(0.5),
      defaultFile = "Images/global_images/Horizontal_Box.png",
      id          = "BO",
      left        = centerX(widthCalculator(0.5)),
      top         = centerY(heightCalculator(0.5)),
  }


  local btnOkay = widget.newButton
    {
      width         = 50,
      height        = 20,
      shape         = "roundedRect",
      cornerRadius  = 10,
      label         = "Okay",
      id            = "btnOkay",
      top           = BG.y + (BG.height/2)*0.5,
      left          = (BG.x - BG.width/2) + BG.width*0.1,
      onEvent       = okay
  }


  passedMoneyData = makeText()
  sceneGroup:insert(BG)
  sceneGroup:insert(btnOkay)

  displayText(passedMoneyData, sceneGroup)
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