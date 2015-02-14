--[[
Purpose:
This screen is responcible for loading the land Screen and setting up components.
On this screen the user can build fossil fueled power plants and nuclear power.
He/She can also buy more land if more is needed.
]]

local composer    = require( "composer" )
local widget      = require( "widget" )
local gv          = require( "global" )
local landTile    = require( "landTile" )
local scene       = composer.newScene()
local bg          = display
local tiles       = {}
local coalPower = 0
local gasPower = 0
local oilPower = 0
local nuclearPower = 0
local sceneGroup  = 0
local powerTimer 
local switch = false

require "landOptions"

-------------------------------------------------
-- PRIVATE FUNCTIONS
-------------------------------------------------
local function loadOptions(counter, event)

  local options = {
    isModal = true
  }

  gv.marker = counter
  gv.tileClicked = tiles[counter]

  if ( "began" == event.phase ) then

    if (tiles[counter].tile:getType() == "open") then
      composer.showOverlay("landOptions", options)
    elseif (tiles[counter].tile:getType() == "city owned") then
      composer.showOverlay("cityOptions",options)
    elseif (tiles[counter].tile:getType()=="forest") then
      composer.showOverlay("forestOptions",options)
    elseif(tiles[counter].tile:getType()=="owned") then
      composer.showOverlay("ownedOptions",options)
    end

  end
end

local function setDataLabels()

  -- calculate coal,
  
  local pass = 0
  local totalConsumption = gv.coalSpecs:getConsumption()*gv.coalBuildCounter
  
  if (totalConsumption > gv.resourcesHeld[2]) then
      pass = math.round(gv.resourcesHeld[2]/gv.coalSpecs:getConsumption());
  else
      pass = gv.coalBuildCounter
  end

  coalPower = pass*gv.coalSpecs:getProduces() .. " GW"


  -- calculate gas

  pass = 0
  totalConsumption = gv.gasSpecs:getConsumption()*gv.gasBuildCounter
  
  if (totalConsumption > gv.resourcesHeld[1]) then
      pass = math.round(gv.resourcesHeld[1]/gv.gasSpecs:getConsumption());
  else
      pass = gv.gasBuildCounter
  end

  gasPower = pass*gv.gasSpecs:getProduces() .. " GW"
  
  
  -- calculate oil
  
  pass = 0
  totalConsumption = gv.oilSpecs:getConsumption()*gv.oilBuildCounter
  
  if (totalConsumption > gv.resourcesHeld[0]) then
      pass = math.round(gv.resourcesHeld[0]/gv.oilSpecs:getConsumption());
  else
      pass = gv.oilBuildCounter
  end

  oilPower = pass*gv.oilSpecs:getProduces() .. " GW"
  
  
  -- calculate nuclear 
  
  pass = 0
  totalConsumption = gv.nuclearSpecs:getConsumption()*gv.nuclearBuildCounter
  
  if (totalConsumption > gv.resourcesHeld[3]) then
      pass = math.round(gv.resourcesHeld[3]/gv.nuclearSpecs:getConsumption());
  else
      pass = gv.nuclearBuildCounter
  end

  nuclearPower = pass*gv.nuclearSpecs:getProduces() .. " GW"        
  
  
  if (switch) then
      setDataBox("Nuclear Power", nuclearPower, 1)
      setDataBox("Gas Power", gasPower, 2)
      setDataBox("Oil Power",oilPower, 3)
      switch = false  
      print("switch is false")
  else
      setDataBox("Coal Power", coalPower, 1)
      setDataBox("Gas Power", gasPower, 2)
      setDataBox("Oil Power",oilPower, 3)
      switch = true
  end
end

--Builds the tiles. All tiles start open but are changed later
local function buildTiles()

  local startX  = 0
  local startY  = -30
  local tileX   = startX
  local tileY   = startY
  local shiftX  = 0.3 * display.contentWidth
  local shiftY  = 0.17 * display.contentHeight
  local counter = 0
  local mask = graphics.newMask( "Images/land_screen/lnd_tile_plain_mask.png" )

  for y = 0, 4, 1 do

    if (y % 2 == 0) then
      tileX = startX
    else
      tileX = shiftX/2
    end


    for x = 0, 2, 1 do

      tiles[counter] = widget.newButton
        {
          width       = 120,
          height      = 120,
          defaultFile = "Images/land_screen/lnd_tile_plain.png",
          id          = "openLand",
          left        = 0,
          top         = 0,
          onEvent = function(event) return loadOptions(3*y + x,event) end,
      }

      tiles[counter].anchorX  = 0
      tiles[counter].anchorY  = 0
      tiles[counter].x        = tileX
      tiles[counter].y        = tileY
      tiles[counter].tile     = landTile.new("open", "none")
      
      local xScale = tiles[counter].width/512
      local yScale = tiles[counter].height/512
      
      tiles[counter]:setMask( mask )      
      tiles[counter].maskScaleX = xScale
      tiles[counter].maskScaleY = yScale
      tiles[counter].maskX = tiles[counter].width/2  
      tiles[counter].maskY = tiles[counter].height/2
      
      sceneGroup:insert(tiles[counter])
      counter                 = counter +1
      tileX = tileX + shiftX
    end
    tileY = tileY + shiftY
  end

  --This the extra tile that is cut off. Had to be disabled
  tiles[12]:setEnabled(false)
  tiles[12].isVisible = false
end

local function buildStartingTiles()

  local type = "city owned"

  convertButton("Images/land_screen/lnd_tile_city01.png",0, type, "none")
  convertButton("Images/land_screen/lnd_tile_city01.png",1, type, "none")
  convertButton("Images/land_screen/lnd_tile_city01.png",3, type, "none")
  convertButton("Images/land_screen/lnd_tile_city01.png",6, type, "none")
  convertButton("Images/land_screen/lnd_tile_city01.png",7, type, "none")
  convertButton("Images/land_screen/lnd_tile_city01.png",9, type, "none")

  type = "forest"

  convertButton("Images/land_screen/lnd_tile_forest.png",10, type, "none")
  convertButton("Images/land_screen/lnd_tile_forest.png",11, type, "none")
  convertButton("Images/land_screen/lnd_tile_forest.png",13, type, "none")
  convertButton("Images/land_screen/lnd_tile_forest.png",14, type, "none")
end

-------------------------------------------------
-- PUBLIC FUNCTIONS
-------------------------------------------------
function groupCheck()

  if ( tiles[gv.marker].tile:getTypeOfPowerPlant() == "oil" ) then
    gv.groups[0]:setStatus(gv.oilInfluence)
  elseif ( tiles[gv.marker].tile:getTypeOfPowerPlant() == "coal" ) then
    gv.groups[0]:setStatus(gv.coalInfluence)
  elseif ( tiles[gv.marker].tile:getTypeOfPowerPlant() == "nuclear" ) then
    gv.groups[1]:setStatus(gv.nuclearInfluence)
  elseif ( tiles[gv.marker].tile:getTypeOfPowerPlant() == "gas" ) then
    gv.groups[0]:setStatus(gv.gasInfluence)
  end


end

function convertButton2(path,location,sc,type)

  local temp = tiles[location]
  sc:remove(tiles[location])


  local mask = graphics.newMask( "Images/land_screen/lnd_tile_forest_mask.png" )
  tiles[location] = display.newImageRect(path,0,0)

  tiles[location].anchorX = 0
  tiles[location].anchorY = 0
  tiles[location].width = 120
  tiles[location].height = 120
  tiles[location].x = temp.x
  tiles[location].y = temp.y
  tiles[location].tile = landTile.new(type)
  --tiles[location]:addEventListener( "tap", function(event) return loadOptions(location,event) end)



  tiles[location]:setMask( mask )
  --    tiles[location].maskX = tiles[location].x
  --    tiles[location].maskY = tiles[location].y
  --    tiles[location].maskScaleY = 0.234
  --    tiles[location].maskScaleX = 0.234

  sc:insert(tiles[location])



end


function convertButton(path,location,type, ppType)

  tiles[location]:setMask( nil )
  local temp = tiles[location]  
  sceneGroup:remove(tiles[location])

  tiles[location] = widget.newButton
    {
      --sheet = buttonSheet,
      width       = 120,
      height      = 120,
      defaultFile = path,
      id          = "openLand",
      left        = 0,
      top         = 0,
      onEvent = function(event) return loadOptions(location,event) end,
  }

  tiles[location].anchorX = 0
  tiles[location].anchorY = 0
  tiles[location].x       = temp.x
  tiles[location].y       = temp.y
  tiles[location].tile    = landTile.new(type, ppType)
  
  local mask = 0
  if (type == "forest") then
      mask = graphics.newMask( "Images/land_screen/lnd_tile_forest_mask.png" )            
  elseif (type == "city owned") then  
      mask = graphics.newMask( "Images/land_screen/lnd_tile_city01_mask.png" )      
  elseif ( type == "open" ) then      
      mask = graphics.newMask( "Images/land_screen/lnd_tile_plain_mask.png" )      
  elseif ( ppType == "oil") then
      mask = graphics.newMask( "Images/land_screen/lnd_tile_oil_mask.png" )
  elseif ( ppType == "gas") then
      mask = graphics.newMask( "Images/land_screen/lnd_tile_gas_mask.png" )
  elseif ( ppType == "coal") then
      mask = graphics.newMask( "Images/land_screen/lnd_tile_coal_mask.png" )
  elseif ( ppType == "nuclear") then
      mask = graphics.newMask( "Images/land_screen/lnd_tile_nuke_mask.png" )
  end
  
  local xScale = tiles[location].width/512
  local yScale = tiles[location].height/512
  
  tiles[location]:setMask( mask )      
  tiles[location].maskScaleX = xScale
  tiles[location].maskScaleY = yScale
  tiles[location].maskX = tiles[location].width/2  
  tiles[location].maskY = tiles[location].height/2
  
  sceneGroup:insert(location+2,tiles[location])
  setDataLabels()
end

-------------------------------------------------
-- COMPOSER FUNCTIONS
-------------------------------------------------

-- "scene:create()"
function scene:create( event )

  sceneGroup = self.view
  switch = false
  local bg = display.newImage("Images/land_screen/lnd_bg.png")
  bg.anchorX, bg.anchorY = 0,0

  bg.height = display.contentHeight
  bg.width = display.contentWidth

  bg.x = 0
  bg.y = 0
  
  sceneGroup:insert(bg)
  buildTiles()
  buildStartingTiles()
end


-- "scene:show()"
function scene:show( event )

  local sceneGroup = self.view
  local phase = event.phase

  if ( phase == "will" ) then
    -- Called when the scene is still off screen (but is about to come on screen).
    setDataLabels()
    powerTimer = timer.performWithDelay( 4000, setDataLabels, -1 );
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
  timer.cancel(powerTimer)
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

-- -------------------------------------------
-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene