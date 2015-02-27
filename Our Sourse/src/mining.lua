local composer    = require( "composer" )
local widget      = require( "widget" )
local gv          = require( "global" )
local miningCell  = require( "miningCell" )

local totalResourses  = {}
local cellClicked     = 0
local oilText         = widget
local gasText         = widget
local coalText        = widget
local uraniumText     = widget
local tilesExisting   = 24
local foundEmpties    = 0
local grid            = {}
local switch = false
local scene           = composer.newScene()
local sceneGroup      = 0
local miningTimer


-------------------------------------------------
-- PRIVATE FUNCTIONS
-------------------------------------------------

local function mined(n,event)

  local options = {
    isModal = true
  }
  cellClicked = n
  if event.phase == "began" and grid[cellClicked].cell:isMined() == false then
    composer.showOverlay("mineOptions",options)
  end

end

function getCellData( index )

  local data = {}

  data[0] = grid[index].cell:getAmount(0)
  data[1] = grid[index].cell:getAmount(1)
  data[2] = grid[index].cell:getAmount(2)
  data[3] = grid[index].cell:getAmount(3)

  return data
end

function numberOfTilesMined()

  local counter = 0
  tilesExisting = 24

  for x = 0,tilesExisting-1,1 do
    if grid[x].cell:isMined() == true then
      counter = counter +1
    end
  end

  return counter

end

function startingOffTiles()

    -- want to find 3 tiles. 1 tile must contain coal.
    
    local n = 0
    local foundCoal = false
    
    -- finds a cell with coal in it
    repeat        
        n = math.random(0,23)
        if( grid[n].cell:getAmount(2) ~= 0 ) then
            foundCoal = true
            cellClicked = n
            changeCell()
            gatherResourses()
            alterFoundResourses()
        end                    
    until foundCoal
    
    local found = 0
    
    repeat
        
        n = math.random(0,23)
        
        if(grid[n].cell:isEmpty() == false ) then
            cellClicked = n
            changeCell()
            gatherResourses()
            alterFoundResourses()
            found = found +1
        end
    
    until found == 2 

end

function isMined(index)

  print("The index is " .. tostring(index))
  return grid[index].cell:isMined()

end

local function miningData( event )

  if(event.phase == "began") then
    composer.showOverlay("miningData")
  end
end

local function setText()
    
      if (switch) then
          -- Shows total resources mined
--          setDataBox("Coal Mined", gv.resourseAmount[2], 1)
--          setDataBox("Gas Extracted", gv.resourseAmount[1], 2)
--          setDataBox("Oil Drilled", gv.resourseAmount[0], 3)

          setDataBox("Coal Mined", gv.resourcesHeld[2], 1)
          setDataBox("Gas Extracted", gv.resourcesHeld[1], 2)
          setDataBox("Oil Drilled",gv.resourcesHeld[0], 3)

          switch = false
      else
          -- Shows total resources mined
--          setDataBox("Uranium Mined", gv.resourseAmount[3], 1)
--          setDataBox("Gas Extracted", gv.resourseAmount[1], 2)
--          setDataBox("Oil Drilled", gv.resourseAmount[0], 3)

          setDataBox("Uranium Mined", gv.resourcesHeld[3], 1)
          setDataBox("Gas Extracted", gv.resourcesHeld[1], 2)
          setDataBox("Oil Drilled",gv.resourcesHeld[0], 3)
          switch = true
      end  


  for x = 1, 3, 1 do
      print("The resource amount for " .. x .. "is " .. tostring(gv.resourseAmount[x]))
  end
  
end


-- want a five by five grid. 24 cells total
local function buildGrid(sceneGroup)

  local square = 50
  local gap = 0.03 * display.contentWidth
  local startx = display.contentWidth*0.85
  local currentX = startx
  local currentY = display.contentHeight*0.75


  local bg = display.newImage("Images/mining_screen/mining_bg.png")
  bg.anchorX, bg.anchorY = 0,0

  bg.height = display.contentHeight
  bg.width = display.contentWidth

  bg.x = 0
  bg.y = 0
  sceneGroup:insert(bg)


  --first row, at bottom of screen
  for i = 0,4,1 do

    grid[i] = widget.newButton
      {
        top = currentY,
        left = currentX,
        width = square,
        height = square,
        labelColor = { default = {gv.fontColourR, gv.fontColourG, gv.fontColourB} },
        defaultFile = "Images/mining_screen/mining_digTile.png",
        label = i+1,
        onEvent = function(event) return mined(i + 0,event) end,
    }

    currentX = currentX - square - gap
    grid[i].cell = miningCell.new()
    sceneGroup:insert(grid[i])
  end

  currentY = currentY - square -gap
  currentX = startx

  for i = 5,10,1 do

    grid[i] = widget.newButton
      {
        top = currentY,
        left = currentX,
        width = square,
        height = square,
        labelColor = { default = {gv.fontColourR, gv.fontColourG, gv.fontColourB} },
        defaultFile = "Images/mining_screen/mining_digTile.png",
        label = i+1,
        onEvent = function(event) return mined(i+0,event) end,
    }

    currentX = currentX - square - gap
    grid[i].cell = miningCell.new()
    sceneGroup:insert(grid[i])

  end

  currentY = currentY - square -gap
  currentX = startx

  for i = 11,17,1 do

    grid[i] = widget.newButton
      {
        top = currentY,
        left = currentX,
        width = square,
        height = square,
        labelColor = { default = {gv.fontColourR, gv.fontColourG, gv.fontColourB} },
        defaultFile = "Images/mining_screen/mining_digTile.png",
        label = i+1,
        onEvent = function(event) return mined(i+0,event) end,
    }

    currentX = currentX - square - gap
    grid[i].cell = miningCell.new()
    sceneGroup:insert(grid[i])

  end

  currentY = currentY - square -gap
  currentX = startx - square - gap

  for i = 18,23,1 do

    grid[i] = widget.newButton
      {
        top = currentY,
        left = currentX,
        width = square,
        height = square,
        labelColor = { default = {gv.fontColourR, gv.fontColourG, gv.fontColourB} },
        defaultFile = "Images/mining_screen/mining_digTile.png",
        label = i+1,
        onEvent = function(event) return mined(i+0,event) end,
    }

    currentX = currentX - square - gap
    grid[i].cell = miningCell.new()
    sceneGroup:insert(grid[i])

  end


  local info = widget.newButton
    {
      top = grid[23].y - square/3,
      left = grid[23].x - square - gap,
      width = square*0.8,
      height = square*0.6,
      defaultFile = "Images/mining_screen/mining_infoButton.png",      
      label = "info",
      onEvent = miningData,
  }

  sceneGroup:insert(info)

end


-- sets 5 cells to be empty
local function createEmptyCells()

  local n = 0

  for i = 0,4,1 do

    n = math.random(0,23)
    print(n)
    grid[n].cell:setEmpty()

    if grid[n].cell:isEmpty() == true then
      i = i - 1
    end

  end
end


local function populateCells(numb, resourse, lowerbound, upperbound)

  local temp = 0
  local amount = 0

  while (totalResourses[resourse]>0 or numb > 0) do

    temp = math.random(0,23)


    -- cell is good
    if(grid[temp].cell:isEmpty() == false and grid[temp].cell:getAmount(resourse) == 0 and numb > 1) then
      amount = math.random(lowerbound,upperbound)
      if (totalResourses[resourse] - amount <= 0) then
        amount = totalResourses[resourse]
      end
      grid[temp].cell:setAmount(resourse,amount)
      totalResourses[resourse] = totalResourses[resourse] - amount
      numb = numb -1
      --print("cell " .. tostring(temp) .. " was filled with " .. tostring(amount) .. " units")
    elseif (grid[temp].cell:isEmpty() == false and grid[temp].cell:getAmount(resourse) == 0 and numb == 1) then
      grid[temp].cell:setAmount(resourse,totalResourses[resourse])
      totalResourses[resourse] = 0
      numb = 0
    end
  end

end


-------------------------------------------------
-- PUBLIC FUNCTIONS
-------------------------------------------------


function alterFoundResourses()

  for x = 0, 24, 1 do
    if (gv.foundResourses[x] == cellClicked ) then
      gv.foundResourses[x] = -1
    end
  end

end

function gatherResourses()

  local amountFound = 0

  if grid[cellClicked].cell:isEmpty() == true then
    foundEmpties = foundEmpties + 1
  end

  for i = 0,3,1 do
    amountFound = grid[cellClicked].cell:getAmount(i)
    gv.resourseAmount[i] = gv.resourseAmount[i] + amountFound
    gv.resourcesHeld[i] = gv.resourcesHeld[i] + amountFound
  end

  setText()

end


function changeCell()

  local temp = grid[cellClicked]
  sceneGroup:remove(grid[cellClicked])

  grid[cellClicked] = widget.newButton
    {
      top = temp.y - temp.height/2,
      left = temp.x - temp.width/2,
      width = temp.width,
      height = temp.height,
      defaultFile = "Images/mining_screen/mining_Done_digTile.png",
  }

  grid[cellClicked].cell = temp.cell
  grid[cellClicked].cell:setMined()
  
  sceneGroup:insert(grid[cellClicked])

end


-------------------------------------------------
-- COMPOSER FUNCTIONS
-------------------------------------------------

-- "scene:create()"
function scene:create( event )

  buildStaticScreen()
  timeStart()

  print("create got ran in mining")
  sceneGroup = self.view
  local empty = 5
  local full = 24 - empty
  local numberToBePopulated = 0
  totalResourses[0] = math.random(250,400)--300   -- oil
  totalResourses[1] = math.random(300,500)--400   -- gas
  totalResourses[2] = math.random(500,700)--600   -- coal
  totalResourses[3] = math.random(450,650)--550   -- uranium

  -- the values in the array below are just for holding the initial values
  totalResourses[4] = totalResourses[0]
  totalResourses[5] = totalResourses[1]
  totalResourses[6] = totalResourses[2]
  totalResourses[7] = totalResourses[3]

  local average = math.round(totalResourses[0]/full)
  buildGrid(sceneGroup)
  createEmptyCells(empty)


  numberToBePopulated = math.random(12, full)
  populateCells(numberToBePopulated, 0, math.round(average*0.7), math.round(average*1.3))

  average = math.round(totalResourses[1]/full)
  populateCells(numberToBePopulated, 1, math.round(average*0.7), math.round(average*1.3))

  average = math.round(totalResourses[2]/full)
  populateCells(numberToBePopulated, 2, math.round(average*0.7), math.round(average*1.3))

  average = math.round(totalResourses[3]/full)
  populateCells(numberToBePopulated, 3, math.round(average*0.7), math.round(average*1.3))
  
  setText()

end


-- "scene:show()"
function scene:show( event )

  local sceneGroup = self.view
  local phase = event.phase

  if ( phase == "will" ) then
    setText()
    miningTimer = timer.performWithDelay( 4000, setText, -1 );
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
  timer.cancel(miningTimer)
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