--[[
Purpose:
This screen is the menu screen currently only holding the play button.

]]

local composer  = require( "composer" )
local gv        = require( "global" )
local widget    = require( "widget" )
local scene     = composer.newScene()
local circleWidth = 30
local circleHeight = circleWidth
local videoHeight = display.contentHeight*0.65
local videoWidth = display.contentWidth*0.45
local infoBoxWidth = widthCalculator(0.3)
local infoBoxHeight = heightCalculator(0.5)

local powerButtons = {}
local buttonPaths = {}
local video 
local infoBox
local textStartingX = 0
local textStartingY = 0
local sceneGroup

buttonPaths[0] = "Images/land_screen/lnd_oil.png"
buttonPaths[1] = "Images/land_screen/lnd_gas.png"
buttonPaths[2] = "Images/land_screen/lnd_coal.png"
buttonPaths[3] = "Images/land_screen/lnd_nuclear.png"
buttonPaths[4] = "Images/natural_resource_screen/nr_solar.png"
buttonPaths[5] = "Images/natural_resource_screen/nr_wind.png"
buttonPaths[6] = "Images/land_screen/lnd_coal.png"


local videoPaths = {}

videoPaths[0] = "video/text.mp4"
videoPaths[1] = "video/text.mp4"
videoPaths[2] = "video/text.mp4"
videoPaths[3] = "video/text.mp4"
videoPaths[4] = "video/text.mp4"
videoPaths[5] = "video/text.mp4"
videoPaths[6] = "video/text.mp4"

-- a 2D array holding the name of the stat in index 1 and the answer in index 2. 
-- this uses built in function so the starting index is 1
local text = {}

-------------------------------------------------
-- PRIVATE FUNCTIONS
-------------------------------------------------

local function setVideo(index)
    
    if (video ~= nil) then
        video:removeSelf()
        video = nil
    end

    video = native.newVideo( display.contentCenterX, display.contentCenterY, videoWidth, videoHeight)
    video:load( videoPaths[index] )

end

local function removeText()
    for x=1, #text, 1 do
        sceneGroup:remove(text[x])                   
    end
end

local function setDataLabels(produces,consumes, maintinence)
    
    setDataBox("Produces", produces .. " GW", 1)
    setDataBox("Consumes", consumes .. " unit(s)", 2)
    setDataBox("Maintinence cost",maintinence .. "$", 3)

end

local function addFossilFuelsText(index)

    -- Total production
    -- amount of resource left over
    -- Total consumption rate
    -- time till end of resource at current rate 
    -- Total maintenence cost
    
    -- in data bar, individual maintenece, production and consumption
    
    local dataTitle = {}    
        
    local power = 0
    local pass = 0
    local resourceRemaining = 0
    local consumptionRate = 0
    local timeTilDepletion = 0
    local maintinence = 0
    local totalConsumption = 0
    local specs = 0
    local buildingsCounter = 0
    
    if(index == 0) then        
        -- calculate oil 
        specs = gv.oilSpecs
        totalConsumption = specs:getConsumption()*gv.oilBuildCounter
        buildingsCounter = gv.oilBuildCounter               
    
    elseif( index == 1 ) then
        -- calculate gas
        specs = gv.gasSpecs
        totalConsumption = specs:getConsumption()*gv.gasBuildCounter
        buildingsCounter = gv.gasBuildCounter    
                
    elseif( index == 2) then
        -- calculate coal
        specs = gv.coalSpecs
        totalConsumption = specs:getConsumption()*gv.coalBuildCounter
        buildingsCounter = gv.coalBuildCounter
    
    elseif(index == 3) then
        -- calculate nuclear
        specs = gv.nuclearSpecs
        totalConsumption = specs:getConsumption()*gv.nuclearBuildCounter
        buildingsCounter = gv.nuclearBuildCounter                  
    end
    
    setDataLabels(specs:getProduces(),specs:getConsumption(),specs:getMaintenenceCost())
          
    if (totalConsumption > gv.resourcesHeld[index]) then
        pass = math.round(gv.resourcesHeld[index]/gv.gasSpecs:getConsumption());
    else
        pass = buildingsCounter
    end
  
    power = pass*specs:getProduces() .. " GW"
    maintinence = pass*specs:getMaintenenceCost() .. "$"
    consumptionRate = pass*specs:getConsumption()
    resourceRemaining = gv.resourcesHeld[index]
    if (consumptionRate == 0 ) then
      consumptionRate = consumptionRate .. " units per month"
      timeTilDepletion = "NA"
    else
      timeTilDepletion = math.floor(resourceRemaining/consumptionRate)
      consumptionRate = consumptionRate .. " units per month"      
    end
    
    dataTitle[1] = "Total Production: " .. power
    dataTitle[2] = "Remaining Resource: " .. resourceRemaining .. " units"
    dataTitle[3] = "Consumption Rate: " .. consumptionRate
    dataTitle[4] = "Time until Depletion: " .. timeTilDepletion
    dataTitle[5] = "Total Maintenence Cost: " .. maintinence
    
    
    for x = 1, 5, 1 do    
        text[x] = display.newText(dataTitle[x],textStartingX,textStartingY, infoBox.width*0.8,0, gv.font, gv.fontSize )
        text[x].anchorX, text[x].anchorY = 0,0
        text[x]:setFillColor( gv.fontColourR, gv.fontColourG, gv.fontColourB )
        sceneGroup:insert(text[x])
        textStartingY = text[x].y + text[x].height/2 + infoBox.height*0.13
    end

end

local function addText(index)
    
    textStartingX = infoBox.x - infoBox.width/2 + infoBox.width*0.05
    textStartingY = infoBox.y - infoBox.height/2 + infoBox.height*0.05

    if(index>= 0 and index <= 3) then
        addFossilFuelsText(index)
    elseif(index == 4 or index == 5) then
        addNatural(index) 
    elseif(index == 6) then
        addHydro()   
    end
end

local function changeData(index, event)

    if (event.phase == "began" ) then
        -- setVideo( index )
        removeText()
        addText(index)
    end
end

local function testingArea()

    local rect = display.newRect(display.contentCenterX + videoWidth*0.1, display.contentCenterY - videoWidth*0.05, videoWidth, videoHeight)
    sceneGroup:insert(rect)
end

-------------------------------------------------
-- COMPOSER FUNCTIONS
-------------------------------------------------

-- "scene:create()"
function scene:create( event )

  sceneGroup = self.view
  local buttonY = display.contentHeight*0.8
  local buttonX = display.contentWidth*0.35
  
  -- builds navigation buttons
  
  for x = 0, 6, 1 do 
      powerButtons[x] = widget.newButton
      {
        width     = circleWidth,
        height    = circleHeight,
        defaultFile = buttonPaths[x],
        top         = buttonY,
        left        = buttonX,
        onEvent   =  function( event ) changeData(x + 0, event) end,
       }
      buttonX = buttonX + circleWidth*1.5
      sceneGroup:insert(powerButtons[x])
  end      
  
  infoBox = widget.newButton
  {
      width       = infoBoxWidth,
      height      = infoBoxHeight,
      defaultFile = "Images/global_images/Vertical_Box.png",
      id          = "BO",
      left        = 5,
      top         = heightCalculator(0.1),
  }

  sceneGroup:insert(infoBox)
  textStartingX = infoBox.x - infoBox.width/2 + infoBox.width*0.05
  textStartingY = infoBox.y - infoBox.height/2 + infoBox.height*0.05  

  testingArea()
  addFossilFuelsText(0)
--  setVideo(0)
--  sceneGroup:insert(video)
 
end


-- "scene:show()"
function scene:show( event )

  local sceneGroup = self.view
  local phase = event.phase
  composer.removeHidden()

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