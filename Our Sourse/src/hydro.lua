--[[
Purpose:
This screen shows the user what rivers he/she can dam. Here the hydro plants are displayed.
Hydro plants can't be dismantled and are perminant.
]]


local composer  = require( "composer")
local widget    = require( "widget" )
local gv        = require( "global" )
local scene     = composer.newScene()
local streams   = {}
local sceneGroup

local damnedRivers = {}

damnedRivers[0] = "Images/hydro_screen/hy_screen_river1_dam.png"
damnedRivers[1] = "Images/hydro_screen/hy_screen_river2_dam.png"
damnedRivers[2] = "Images/hydro_screen/hy_screen_river3_dam.png"
damnedRivers[3] = "Images/hydro_screen/hy_screen_river4_dam.png"
damnedRivers[4] = "Images/hydro_screen/hy_screen_river5_dam.png"
damnedRivers[5] = "Images/hydro_screen/hy_screen_river6_dam.png"

local maskFileArray = {}

maskFileArray[0] = "Images/hydro_screen/hy_screen_river1_mask.png"
maskFileArray[1] = "Images/hydro_screen/hy_screen_river2_mask.png"
maskFileArray[2] = "Images/hydro_screen/hy_screen_river3_mask.png"
maskFileArray[3] = "Images/hydro_screen/hy_screen_river4_mask.png"
maskFileArray[4] = "Images/hydro_screen/hy_screen_river5_mask.png"
maskFileArray[5] = "Images/hydro_screen/hy_screen_river6_mask.png"


-------------------------------------------------
-- PRIVATE FUNCTIONS
-------------------------------------------------

local function setDataLabels()

    local totalPower = 0
    local areaDestroyed = 0
    local totalMaintenence = 0
    local status  = 0
    
    for x = 0, 5, 1 do    
        if (gv.rivers[x]:getBuilt()) then        
            totalPower = totalPower + gv.rivers[x]:getPowerGenerated()
            areaDestroyed = areaDestroyed + gv.rivers[x]:getAD()
            --totalMaintenence = totalMaintenence + gv.rivers[x]:getMainteneceCost() 
        end    
    end
    
    totalMaintenence = math.round((totalPower/gv.powerSupplied)*1000)/10
    
    setDataBox("Hydro Power", totalPower.. " GW", 1)
    setDataBox("Area Destroyed", areaDestroyed, 2)
    setDataBox("Hydro %",totalMaintenence, 3)

end


local function riverData( event, index )

    if ( event.phase == "ended" ) then
        gv.riverSelected = index    
        composer.showOverlay("riverDamedData")
    end

end

local function dam(riverSelected,event)

  local options = {
    isModal = true
  }

  if ( "began" == event.phase ) then
    if (streams[riverSelected].river:getBuilt() == false) then
      gv.riverSelected = riverSelected
      composer.showOverlay("hydroOptions", options)
    end

  end
end

function changeImage()
    
  local temp = streams[gv.riverSelected]  
  local t = gv.riverSelected
  sceneGroup:remove(streams[gv.riverSelected])

  streams[gv.riverSelected] = widget.newButton
    {      
      width = display.contentWidth,
      height = display.contentHeight,
      left = 0,
      top = 0,
      defaultFile = damnedRivers[gv.riverSelected],
      onEvent = function(event) return riverData(event, t + 0) end,
  }

  streams[gv.riverSelected].anchorY, streams[gv.riverSelected].anchorX = 0,0
  streams[gv.riverSelected].x = 0
  streams[gv.riverSelected].y = 0
  streams[gv.riverSelected].river  = gv.rivers[gv.riverSelected]
  
  
  local mask = graphics.newMask( maskFileArray[gv.riverSelected] )
  local xScale = streams[gv.riverSelected].width/1200
  local yScale = streams[gv.riverSelected].height/800
  
  streams[gv.riverSelected]:setMask( mask )
  streams[gv.riverSelected].maskScaleX = xScale
  streams[gv.riverSelected].maskScaleY = yScale
  streams[gv.riverSelected].maskX = streams[gv.riverSelected].width/2
  streams[gv.riverSelected].maskY = streams[gv.riverSelected].height/2
      
 
  sceneGroup:insert(streams[gv.riverSelected])
end


-------------------------------------------------
-- COMPOSER FUNCTIONS
-------------------------------------------------

-- "scene:create()"
function scene:create( event )

  sceneGroup = self.view

  local bg = display.newImage("Images/hydro_screen/hy_screen_bg.png")
  bg.anchorX, bg.anchorY = 0,0

  bg.height = display.contentHeight
  bg.width = display.contentWidth

  bg.x = 0
  bg.y = 0
  sceneGroup:insert(bg)
    
  local defaultFileArray = {}
  defaultFileArray[0] = "Images/hydro_screen/hy_screen_river1.png"
  defaultFileArray[1] = "Images/hydro_screen/hy_screen_river2.png"  
  defaultFileArray[2] = "Images/hydro_screen/hy_screen_river3.png"
  defaultFileArray[3] = "Images/hydro_screen/hy_screen_river4.png"
  defaultFileArray[4] = "Images/hydro_screen/hy_screen_river5.png"
  defaultFileArray[5] = "Images/hydro_screen/hy_screen_river6.png"
  
  for x = 0, 5, 1 do 
   
      streams[x] = widget.newButton
      {
          width = display.contentWidth,
          height = display.contentHeight,
          left = 0,
          top = 0,
          defaultFile = defaultFileArray[x],
          onEvent   = function(event) return dam(x + 0,event) end
          
      }
      streams[x].anchorX = 0
      streams[x].anchorY = 0
      streams[x].x = 0
      streams[x].y = 0
      streams[x].river =  gv.rivers[x]
      
      local mask = graphics.newMask( maskFileArray[x] )
      local xScale = streams[x].width/1200
      local yScale = streams[x].height/800
            
      streams[x]:setMask( mask )
      streams[x].maskScaleX = xScale
      streams[x].maskScaleY = yScale
      streams[x].maskX = streams[x].width/2
      streams[x].maskY = streams[x].height/2
           
      sceneGroup:insert(streams[x])
  end

end


-- "scene:show()"
function scene:show( event )

  local sceneGroup = self.view
  local phase = event.phase

  if ( phase == "will" ) then
  -- Called when the scene is still off screen (but is about to come on screen).
      setDataLabels()
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