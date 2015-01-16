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
local scene           = composer.newScene()
local sceneGroup      = 0


-------------------------------------------------
-- PRIVATE FUNCTIONS
-------------------------------------------------

local function mined(n,event)
	
	local options = {
        isModal = true
    }
    cellClicked = n
	if event.phase == "began" and grid[cellClicked].cell:isMined() == false then
		print("making it inside")
		
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

    for x = 0,tilesExisting-1,1 do
        if grid[x].cell:isMined() == true then
            counter = counter +1
        end
    end

    return counter

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
	
	oilText:setLabel("Oil: "..tostring(gv.resourseAmount[0]).."/"..tostring(totalResourses[4]))
	gasText:setLabel("Gas: "..tostring(gv.resourseAmount[1]).."/"..tostring(totalResourses[5]))
	coalText:setLabel("Coal: "..tostring(gv.resourseAmount[2]).."/"..tostring(totalResourses[6]))
	uraniumText:setLabel("Uranium: "..tostring(gv.resourseAmount[3]).."/"..tostring(totalResourses[7]))
	
	
	local tilesMined = numberOfTilesMined()  
  
  setDataBox("Areas Mined", tilesMined, 1)
  setDataBox("Cells Remaining", tilesExisting - tilesMined, 2)
  setDataBox("Empty Cells found", foundEmpties, 3)

end


-- want a five by five grid. 24 cells total
local function buildGrid(sceneGroup)

  local square = 50
  local gap = 0.03 * display.contentWidth
  local startx = display.contentWidth*0.85
  local currentX = startx
  local currentY = display.contentHeight*0.75
  
  --first row, at bottom of screen
  for i = 0,4,1 do
  
    grid[i] = widget.newButton
    {
      top = currentY,
      left = currentX,
        width = square,
        height = square,
        --defaultFile = "buttonDefault.png",
        shape = "rect",     
        label = i+1,
        onEvent = function(event) return mined(i+0,event) end,    
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
        --defaultFile = "buttonDefault.png",
        shape = "rect",     
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
        --defaultFile = "buttonDefault.png",
        shape = "rect",     
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
        --defaultFile = "buttonDefault.png",
        shape = "rect",     
        label = i+1,   
        onEvent = function(event) return mined(i+0,event) end, 
    }
    
    currentX = currentX - square - gap
    grid[i].cell = miningCell.new()
    sceneGroup:insert(grid[i])
  
  end
  
  
  local info = widget.newButton
  {
    top = grid[23].y - square/2,
    left = grid[23].x - square*1.5 - gap,
    width = square,
    height = square,
    --defaultFile = "buttonDefault.png",
    shape = "rect",     
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

	local replacement = widget.newButton
	{
		top = temp.y - temp.height/2,
		left = temp.x - temp.width/2,
	    width = temp.width,
	    height = temp.height,
	    --defaultFile = "buttonDefault.png",
	    shape = "rect",	    
	    label = "X",
	    onEvent = function(event) return mined(cellClicked + 0,event) end,	  
	}
	
	replacement.cell = grid[cellClicked].cell
	replacement.cell:setMined()
	
	grid[cellClicked] = replacement
	sceneGroup:insert(grid[cellClicked])

end


local function setData()

	local posHeight = 10
	local width = display.contentWidth*0.13
	local height = 20
	local gap = 5
	oilText = widget.newButton
	{
		width = width,
		height = height,
		top = posHeight,
		left = 0,
		shape = "rect",
		label = " Oil: 0/50",	
		isEnabled = false,		
	}
	
	gasText = widget.newButton
	{
		width = width + 10,
		height = height,
		top = posHeight,
		left = oilText.x + oilText.width/2 + gap,
		shape = "rect",
		label = " Gas: 0/50",	
		isEnabled = false,		
	}
	
	coalText = widget.newButton
	{
		width = width + 20,
		height = height,
		top = posHeight,
		left =  gasText.x + gasText.width/2 + gap,
		shape = "rect",
		label = " Coal: 0/50",	
		isEnabled = false,		
	}
	
	uraniumText = widget.newButton
	{
		width = width + 40,
		height = height,
		top = posHeight,
		left = coalText.x + coalText.width/2 + gap,
		shape = "rect",
		label = "Uranium: 0/50",	
		isEnabled = false,		
	}

	sceneGroup:insert(oilText)
	sceneGroup:insert(gasText)
	sceneGroup:insert(coalText)
	sceneGroup:insert(uraniumText)


end


-------------------------------------------------
-- COMPOSER FUNCTIONS
-------------------------------------------------

-- "scene:create()"
function scene:create( event )

  buildStaticScreen()    
  timeStart()    
    
  sceneGroup = self.view
	local empty = 5
	local full = 24 - empty
	local numberToBePopulated = 0
	totalResourses[0] = 50
	totalResourses[1] = 50
	totalResourses[2] = 50
	totalResourses[3] = 50
	
	-- the values in the array below are just for holding the initial values
	totalResourses[4] = 50
	totalResourses[5] = 50
	totalResourses[6] = 50
	totalResourses[7] = 50
	
	
  buildGrid(sceneGroup)
  createEmptyCells(empty)
  
  numberToBePopulated = math.random(12, full)    
  populateCells(numberToBePopulated, 0, 2, 5)
  populateCells(numberToBePopulated, 1, 2, 5)
  populateCells(numberToBePopulated, 2, 2, 5)
	populateCells(numberToBePopulated, 3, 2, 5)
	
	setData()
	setText()
    
end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        setText()
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