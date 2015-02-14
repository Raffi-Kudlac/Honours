local composer    = require( "composer" )
local widget      = require( "widget" )
local gv          = require( "global" )
local naturalTile = require( "naturalTile" )

local grid        = display
local tiles       = {}
local scene       = composer.newScene()
local sceneGroup


-------------------------------------------------
-- PRIVATE FUNCTIONS
-------------------------------------------------

local function setDataLabels()

  local windPower = gv.windBuildCounter*gv.windSpecs:getProduces()
  local solarPower = gv.solarBuildCounter*gv.solarSpecs:getProduces()
  local percent = math.round(100*(windPower + solarPower)/gv.powerDemanded)--(gv.naturalLandUsedCounter/14)*100
  percent = math.round(percent)

  setDataBox("Solar Power",tostring(solarPower) .. " GW" , 1)
  setDataBox("Wind Power", tostring(windPower) .. " GW", 2)
  setDataBox("Natural Power",tostring(percent) .. "%", 3)
end


local function loadOptions(counter, event)

  local options = {
    isModal = true
  }

  gv.marker = counter
  gv.tileClicked = tiles[counter]

  print("The natural options method got called")
  if ( "began" == event.phase ) then

    if (tiles[counter].tile:getType() == "open") then
      composer.showOverlay("naturalOptions", options)
    else
      composer.showOverlay("demolish", options)
    end

  end
end

-------------------------------------------------
-- PUBLIC FUNCTIONS
-------------------------------------------------

function naturalConvertButton(path,location,type)
  print("convert called in natural")
  tiles[location]:setMask( nil )
  local temp = tiles[location]
  local mask = nil
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
  tiles[location].tile    = naturalTile.new(type)
  
  if(type == "open") then
        mask = graphics.newMask( "Images/land_screen/lnd_tile_plain_mask.png" )
  elseif (type == "solar" ) then
      mask = graphics.newMask( "Images/natural_resource_screen/nr_tile_solar_mask.png" )
  elseif (type == "wind" ) then
      mask = graphics.newMask( "Images/natural_resource_screen/nr_tile_wind_mask.png" )    
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
      tiles[counter].tile     = naturalTile.new("open")
      
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

-- "scene:create()"
function scene:create( event )

  sceneGroup = self.view

  grid = widget.newButton
    {
      width       = display.contentWidth,
      height      = display.contentHeight,
      defaultFile = "Images/land_screen/lnd_grid.png",
      id          = "grid",
      left        =50,
      top         = 40,
  }
  grid:scale(1.2,1.2)
  sceneGroup:insert(grid)
  buildTiles()
  -- Initialize the scene here.
  -- Example: add display objects to "sceneGroup", add touch listeners, etc.
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