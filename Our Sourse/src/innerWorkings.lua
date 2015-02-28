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
local videoX = display.contentCenterX + videoWidth*0.1
local videoY = display.contentCenterY - videoWidth*0.05
local infoBoxWidth = widthCalculator(0.3)
local infoBoxHeight = heightCalculator(0.5)
local windmillSpace = 120 -- meters squared
local solarSpace = 50 -- meters squared
local rightArrow
local leftArrow
local cyclePointer = 1

local powerButtons = {}
local buttonPaths = {}
local consumptionTimer 
local video 
local infoBox
local textStartingX = 0
local textStartingY = 0
local sceneGroup

buttonPaths[0] = "Images/inner_workings_screen/inw_generator.png"
buttonPaths[1] = "Images/land_screen/lnd_oil.png"
buttonPaths[2] = "Images/land_screen/lnd_gas.png"
buttonPaths[3] = "Images/land_screen/lnd_coal.png"
buttonPaths[4] = "Images/land_screen/lnd_nuclear.png"
buttonPaths[5] = "Images/natural_resource_screen/nr_solar.png"
buttonPaths[6] = "Images/natural_resource_screen/nr_wind.png"
buttonPaths[7] = "Images/inner_workings_screen/inw_hydrodam.png"


local videoPaths = {}
videoPaths[0] = "video/test.mp4"
videoPaths[1] = "video/test.mp4"
videoPaths[2] = "video/test.mp4"
videoPaths[3] = "video/coalvid.mp4"
videoPaths[4] = "video/test.mp4"
videoPaths[5] = "video/test.mp4"
videoPaths[6] = "video/test.mp4"
videoPaths[7] = "video/test.mp4"

-- a 2D array holding the name of the stat in index 1 and the answer in index 2. 
-- this uses built in function so the starting index is 1
local text = {}

-------------------------------------------------
-- PRIVATE FUNCTIONS
-------------------------------------------------

function hideVideo()
    video.x = -video.width
    video.y = -video.height
end

function revealVideo()
    
    video.x = videoX
    video.y = videoY
end

local function videoListener( event )

    if ( event.phase == "ended" ) then
    
        video:seek( 0 )
        video:play()    
    end
end

local function resetTextPosition()

    infoBox.height = infoBoxHeight       
    infoBox.y = heightCalculator(0.1)    
    textStartingX = infoBox.x + infoBox.width*0.05
    textStartingY = infoBox.y + infoBox.height*0.05

end

local function resetTextPositionForFossilFuels()
    
    
    
    infoBox.height = infoBoxHeight*1.25        
    infoBox.y = heightCalculator(0)
    textStartingY = infoBox.y + infoBox.height*0.04       

end

local function setVideo(index)
    
    if (video ~= nil) then
        video:removeEventListener("video",videoListener)
        video:removeSelf()
        video = nil
    end

    video = native.newVideo( videoX, videoY, videoWidth, videoHeight)
    video:addEventListener( "video", videoListener )
    video:load( videoPaths[index] )    
    video:play()
end

local function removeText()

    local length = #text
    for x=length, 1, -1 do       
        sceneGroup:remove(text[x])
        table.remove(text,x)
    end
end

local function setHydroLabels(name,produces, maintinence)
    
    if (name == "NA") then 
        setDataBoxNoColon("", name, 1)
        setDataBoxNoColon("", name, 2)
        setDataBoxNoColon("", name, 3)
    else
        setDataBox("Name", name, 1)
        setDataBox("Produces", produces .. " unit(s)", 2)
        setDataBox("Maintenance cost","$"..maintinence, 3)
    end

end

local function setDataLabels(produces,consumes, maintinence)
    
    setDataBox("Produces", produces .. " GW", 1)
    setDataBox("Consumes", consumes .. " unit(s)", 2)
    setDataBox("Maintenance cost","$"..maintinence, 3)

end

local function addFossilFuelsText(index)

    -- Total production
    -- amount of resource left over
    -- Total consumption rate
    -- time till end of resource at current rate 
    -- Total maintenence cost
   
    -- in data bar, individual maintenece, production and consumption
    removeText()
    resetTextPositionForFossilFuels()
    local dataTitle = {}    
    local answers = {}
        
    local power = 0
    local pass = 0
    local resourceRemaining = 0
    local consumptionRate = 0
    local timeTilDepletion = 0
    local maintinence = 0
    local totalConsumption = 0
    local specs = 0
    local buildingsCounter = 0
    local unit 
    
    if(index == 0) then        
        -- calculate oil 
        specs = gv.oilSpecs
        totalConsumption = specs:getConsumption()*gv.oilBuildCounter
        buildingsCounter = gv.oilBuildCounter
        unit = "OIL"               
    
    elseif( index == 1 ) then
        -- calculate gas
        specs = gv.gasSpecs
        totalConsumption = specs:getConsumption()*gv.gasBuildCounter
        buildingsCounter = gv.gasBuildCounter   
        unit = "GAS" 
                
    elseif( index == 2) then
        -- calculate coal
        specs = gv.coalSpecs
        totalConsumption = specs:getConsumption()*gv.coalBuildCounter
        buildingsCounter = gv.coalBuildCounter
        unit = "COAL"
    
    elseif(index == 3) then
        -- calculate nuclear
        specs = gv.nuclearSpecs
        totalConsumption = specs:getConsumption()*gv.nuclearBuildCounter
        buildingsCounter = gv.nuclearBuildCounter
        unit = "URANIUM"
    end
    
    setDataLabels(specs:getProduces(),specs:getConsumption(),specs:getMaintenenceCost())
          
    if (totalConsumption > gv.resourcesHeld[index]) then
        pass = math.round(gv.resourcesHeld[index]/gv.gasSpecs:getConsumption());
    else
        pass = buildingsCounter
    end
  
    power = pass*specs:getProduces() .. " GW"
    maintinence = pass*specs:getMaintenenceCost()
    consumptionRate = pass*specs:getConsumption()
    resourceRemaining = math.round(10*gv.resourcesHeld[index])/10
    
    if ( resourceRemaining < 0 ) then
        resourceRemaining = 0
    end
    
    if (consumptionRate == 0 ) then
      consumptionRate = consumptionRate .. " units per month"
      timeTilDepletion = "NA"
    else
      timeTilDepletion = math.floor(resourceRemaining/consumptionRate) .. " months"
      consumptionRate = consumptionRate .. " units per month"      
    end
    
    dataTitle[1] = "TOTAL PRODUCTION: \n\t" .. power
    dataTitle[2] = "REMAINING RESOURCES: \n\t" .. resourceRemaining .. " units"
    dataTitle[3] = "CONSUMPTION RATE: \n\t" .. consumptionRate
    dataTitle[4] = "TIME TILL DEPLETION:\n\t" .. timeTilDepletion
    dataTitle[5] = "TOTAL MAINTENENCE COST:\n\t" .. "$"..maintinence
    dataTitle[6] = "TOTAL " .. unit .. " MINED: \n \t" .. gv.resourseAmount[3] .. " units"        
    
    for x = 1, 6, 1 do    
        text[x] = display.newText(dataTitle[x],textStartingX,textStartingY, infoBox.width*0.9,0, gv.font, gv.fontSize )
        text[x].anchorX, text[x].anchorY = 0,0
        text[x]:setFillColor( gv.fontColourR, gv.fontColourG, gv.fontColourB )
        sceneGroup:insert(text[x])
        textStartingY = text[x].y + text[x].height/2 + infoBox.height*0.1
    end

end

local function addNaturalText(index)


    local totalProduced = 0
    local totalMaintenence = 0
    local buildingsCounter = 0
    local textData = {}
    local name = ""
    local area = 0

    if(index == 4) then        
        -- calculate solar 
        specs = gv.solarSpecs        
        buildingsCounter = gv.solarBuildCounter  
        name = "SOLAR PANALS"             
        area = buildingsCounter*windmillSpace*3
    elseif( index == 5 ) then
        -- calculate wind
        specs = gv.windSpecs        
        buildingsCounter = gv.windBuildCounter
        name = "WINDMILLS"   
        area = buildingsCounter*solarSpace*6
    end
    
    setDataLabels(specs:getProduces(),specs:getConsumption(),specs:getMaintenenceCost())
    
    totalProduced = buildingsCounter*specs:getProduces()
    textData[1] = "TOTAL PRODUCTION: \n\t" .. totalProduced .. " GW"
    textData[2] = name .. " BUILT: \n\t" .. buildingsCounter
    textData[3] = "TOTAL MAINTENENCE COST: \n\t$" .. totalMaintenence
    textData[4] = "AREA USED:\n\t" .. area .. " meters squared"
    
    for x = 1, 4, 1 do    
        text[x] = display.newText(textData[x],textStartingX,textStartingY, infoBox.width*0.9,0, gv.font, gv.fontSize )
        text[x].anchorX, text[x].anchorY = 0,0
        text[x]:setFillColor( gv.fontColourR, gv.fontColourG, gv.fontColourB )
        sceneGroup:insert(text[x])
        textStartingY = text[x].y + text[x].height/2 + infoBox.height*0.13
    end
    
    
end

local function addHydroText()
  
  
  -- total power
  -- total maintenence
  -- # of dams built
  -- total area destroyed
  
  local dataTitle = {}
  local power = 0
  local maintenence = 0
  local area = 0 
  local instalations = 0
  
  for x = 0, 5, 1 do    
      if (gv.rivers[x]:getBuilt()) then        
          power = power + gv.rivers[x]:getPowerGenerated()
          area = area + gv.rivers[x]:getAD()
          maintenence = maintenence + gv.rivers[x]:getMainteneceCost()
          instalations = instalations + 1 
      end    
  end
  
  
  dataTitle[1] = "TOTAL PRODUCTION:\n\t" .. power .. " GW"
  dataTitle[2] = "RIVERS DAMED:\n\t" .. instalations
  dataTitle[3] = "TOTAL AREA DESTROYED:\n\t" .. area .. " km squared"  
  dataTitle[4] = "TOTAL MAINTENENCE COST:\n\t" .. "$"..maintenence
  
  for x = 1, 4, 1 do    
      text[x] = display.newText(dataTitle[x],textStartingX,textStartingY, infoBox.width*0.9,0, gv.font, gv.fontSize )
      text[x].anchorX, text[x].anchorY = 0,0
      text[x]:setFillColor( gv.fontColourR, gv.fontColourG, gv.fontColourB )
      sceneGroup:insert(text[x])
      textStartingY = text[x].y + text[x].height/2 + infoBox.height*0.13
  end
    

end

local function cycle( up, event )

    if ( event.phase == "began") then
    
        local direction                
        local builtArray = {}
        for x = 0, 5, 1 do
            if(gv.rivers[x]:getBuilt()) then
                table.insert(builtArray,x)
            end
        end
        
        if ( #builtArray ~= 0) then
            rightArrow.isVisible = true
            leftArrow.isVisible = true 
            if ( up ) then
              direction = 1
            else
              direction = -1
            end

              setHydroLabels(gv.rivers[builtArray[cyclePointer]]:getName(),
              gv.rivers[builtArray[cyclePointer]]:getPowerGenerated(), gv.rivers[builtArray[cyclePointer]]:getMainteneceCost())
              
              cyclePointer = cyclePointer + direction
              
              if ( cyclePointer > #builtArray ) then
                      cyclePointer = 1
              elseif ( cyclePointer < 1 ) then
                  cyclePointer = #builtArray 
              end

          else
            setHydroLabels("NA","", "")
          end    
    end 

end


local function addGeneratorData()

    local information = "The generator is at the heart of all sources of power except solar power. \n " .. 
    "Michael Faraday discovered that if you push a magnet through a coiled wire, the kinetic energy of the magnet " .. 
    "will be converted into electrical energy in the wire. \n This elecrical energy is a current. " .. 
    "Once you have a current you can direct it where ever you want. :)"
    
      text[1] = display.newText(information,textStartingX,textStartingY, infoBox.width*0.9,0, gv.font, gv.fontSize )
      text[1].anchorX, text[1].anchorY = 0,0
      text[1]:setFillColor( gv.fontColourR, gv.fontColourG, gv.fontColourB )
      sceneGroup:insert(text[1])


end

local function removeTimer()

    if ( consumptionTimer ~= nil) then
        timer.cancel(consumptionTimer)
    end
    consumptionTimer = nil

end


local function addTimer( index )

    consumptionTimer = timer.performWithDelay(1000, function ( event ) addFossilFuelsText( index ) end, -1)
end


local function addText(index, event)
    
    resetTextPosition()     
    rightArrow.isVisible = false
    leftArrow.isVisible = false
    
    removeTimer()

    if(index>= 1 and index <= 4) then        
        textStartingY = infoBox.y - infoBox.height*0.05
        infoBox.height = infoBoxHeight*1.1        
        infoBox.y = heightCalculator(0.05)        
        addFossilFuelsText(index-1)
        addTimer( index -1 )
    elseif(index == 5 or index == 6) then
        addNaturalText(index-1) 
    elseif(index == 7) then
        addHydroText()
        cycle(true, event)        
    elseif (index == 0) then
        textStartingY = infoBox.y - infoBox.height*0.05
        addGeneratorData()
        infoBox.height = infoBoxHeight*1.1        
        infoBox.y = heightCalculator(0.05)
    end
end

local function changeData(index, event)

    if (event.phase == "began" ) then        
        removeText()
        addText(index, event)
        setVideo(index)
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
  local buttonX = display.contentWidth*0.3
  
  -- builds navigation buttons
  
  for x = 0, 7, 1 do 
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
  
  rightArrow = widget.newButton
  {
    width     = circleWidth,
    height    = circleHeight,
    defaultFile = "Images/inner_workings_screen/right-arrow.png",
    top         = powerButtons[7].y - circleHeight*1.5,
    left        = powerButtons[7].x + circleWidth/4,
    onEvent   =  function( event ) cycle(true, event ) end,
   }
       
   leftArrow = widget.newButton
  {
    width     = circleWidth,
    height    = circleHeight,
    defaultFile = "Images/inner_workings_screen/left-arrow.png",
    top         = powerButtons[7].y - circleHeight*1.5,
    left        = powerButtons[7].x - circleWidth*1.25,
    onEvent   =  function( event ) cycle(false, event ) end,
   }
  
  rightArrow.isVisible = false
  leftArrow.isVisible = false 
  
  sceneGroup:insert(rightArrow)
  sceneGroup:insert(leftArrow)


  infoBox = display.newImage("Images/global_images/Vertical_Box.png", 5,heightCalculator(0.1))
  infoBox.anchorX, infoBox.anchorY = 0,0
  infoBox.width = infoBoxWidth
  infoBox.height = infoBoxHeight
  

  sceneGroup:insert(infoBox)
  textStartingX = infoBox.x + infoBox.width*0.05
  textStartingY = infoBox.y + infoBox.height*0.05   
end


-- "scene:show()"
function scene:show( event )

  local sceneGroup = self.view
  local phase = event.phase
  
  if ( phase == "will" ) then
  -- Called when the scene is still off screen (but is about to come on screen).
  
  --testingArea()
  mainSetInnerWorkingsVariable(true)
  resetTextPositionForFossilFuels()
  addFossilFuelsText(0)
  setVideo(0)
  sceneGroup:insert(video)
  
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
      mainSetInnerWorkingsVariable(false)
  elseif ( phase == "did" ) then
  -- Called immediately after scene goes off screen.
  removeTimer()
  removeText()
  video:pause()
  video:seek(0)
  video:removeEventListener("video",videoListener)
  video:removeSelf()
  video = nil
  end
end


-- "scene:destroy()"
function scene:destroy( event )

  local sceneGroup = self.view
   mainSetInnerWorkingsVariable(false)
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