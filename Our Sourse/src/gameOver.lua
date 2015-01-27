--[[
Purpose:
This screen is the menu screen currently only holding the play button.

]]

local composer  = require( "composer" )
local gv        = require( "global" )
local widget    = require( "widget" )
local scene     = composer.newScene()


local heighScoreData = {}      --used to store data read from the file
local path = system.pathForFile( "localHighScores.txt", system.DocumentsDirectory)
local file = nil
local name = ""
local position = 0
local currentTotalMonths = (gv.year-2000)*12 + gv.month
local tempMonths = 0
local nameField = ""
local submit = ""
local sceneGroup = ""
local winningData = {}

-------------------------------------------------
-- PRIVATE FUNCTIONS
-------------------------------------------------

local function textListener()

  if (event.phase == "ended" or event.phase == "submitted") then
    name = event.target.text

    if (name == nil ) then
      name = "Player 1"
    end

  end
end

local function back( event )

  composer.gotoScene("menu")
end

local function newGame( event )

--    destoryAllScenes()
--    initalize()
--    composer.gotoScene("mining")
--    startingPower()
--    composer.gotoScene("city")

end

local function createText()

  local startingY = display.contentHeight*0.05
  local startingX = display.contentWidth/2
  local dataX = display.contentWidth*0.1
  local dataY = display.contentHeight*0.2
  local tempText = {}
  local label = "Name \t\t Years \t\t Month \t\t Total BlackOut Months"

  local title = display.newText("Game Over", startingX,
    startingY, gv.font, gv.fontSize*2 )
  --title.anchorX, title.anchorY = 0,0
  title:setFillColor( gv.fontColourR, gv.fontColourG, gv.fontColourB )

  sceneGroup:insert(title)

  local labelText = display.newText(label, dataX, display.contentHeight*0.12, gv.font, gv.fontSize*2)


  for x = 1, 5, 1 do

    if(heighScoreData[x][0] ~= -1 ) then
      message = heighScoreData[x][0] .."\t\t" .. heighScoreData[x][1] .. "\t\t" ..
        heighScoreData[x][2] .. "\t\t" .. heighScoreData[x][3]
      tempText[x] = display.newText(message, dataX,
        dataY, gv.font, gv.fontSize*2 )
      tempText[x]:setFillColor( gv.fontColourR, gv.fontColourG, gv.fontColourB )
      sceneGroup:insert(tempText[x])
      dataY = dataY + heightCalculator(0.1)
    end
  end

  local back = widget.newButton
    {
      width     = 100,
      height    = 100,
      shape     = "roundedRect",
      fillColor = { default={ 1, 0.2, 0.5, 0.7 }, over={ 1, 0.2, 0.5, 1 } },
      left      = centerX(100) - widthCalculator(0.1),
      top       = display.contentHeight - heightCalculator(0.1),
      labelAlign = "center",
      label     = "Back",
      onEvent   =   back,
  }

  local newGame = widget.newButton
    {
      width     = 100,
      height    = 100,
      shape     = "roundedRect",
      fillColor = { default={ 1, 0.2, 0.5, 0.7 }, over={ 1, 0.2, 0.5, 1 } },
      left      = centerX(100) + widthCalculator(0.1),
      top       = display.contentHeight - heightCalculator(0.1),
      labelAlign = "center",
      label     = "New Game",
      onEvent   =   newGame,
  }

  sceneGroup:insert(back)
  sceneGroup:insert(newGame)
  sceneGroup:insert(labelText)
end


function write()

  local file = io.open(path , "w+")
  for x=1,5, 1 do
    for y=1,4,1 do
      file:write(heighScoreData[x][y] .. "\n")
    end
  end

  io.close(file)
  file = nil

end

local function createFile()

  local file = io.open(path , "w+")
  io.close(file)
  file = nil
end


local function close( event )

  if(event.phase == "ended") then

    local winningData = {name,winningYear, winningMonth, winningBlackoutCounter}
    table.insert(heighScoreData, position, winningData)


    -- trims the high scores so only 5 exist
    if (#heighScoreData == 6) then
      table.remove(heighScoreData, 6)
    end

    write()
    sceneGroup:remove(nameField)
    sceneGroup:remove(submit)
    createText()
  end

end


local function getNameFromUser()

  nameField = native.newTextField( 100,50, centerX(100), centerY(50) )
  nameField:addEventListener( "userInput", textListener )


  submit = widget.newButton
    {
      width     = 100,
      height    = 100,
      shape     = "roundedRect",
      fillColor = { default={ 1, 0.2, 0.5, 0.7 }, over={ 1, 0.2, 0.5, 1 } },
      left      = nameField.x,
      top       = nameField.y + nameField.height*2,
      labelAlign = "center",
      label     = "Submit",
      onEvent   =   close,
  }

  sceneGroup:insert(nameField)
  sceneGroup:insert(submit)
end


-------------------------------------------------
-- COMPOSER FUNCTIONS
-------------------------------------------------

-- "scene:create()"
function scene:create( event )


  -- format of the file is Name, year, month, # of blackout months
  sceneGroup = self.view

  path = system.pathForFile( "localHighScores.txt", system.DocumentsDirectory)

  for x =1,5,1 do
    heighScoreData[x] = {-1,-1,-1,-1}
  end

  if ( path ~= nil) then
    file = io.open(path , "r")

    if (file == nil ) then
      createFile()
      file = io.open(path , "r")
    end

    local x = 1
    local y = 1

    for line in file:lines() do
      heighScoreData[x][y] = line

      if (y ~= 1) then
        heighScoreData[x][y] = tonumber(heighScoreData[x][y])
      end

      y = y +1

      if(y==5) then
        y = 1
        x = x+1
      end
    end

    io.close(file)

    currentTotalMonths = (gv.year-2000)*12 + gv.month
    for x = 1, 5, 1 do

      tempMonths = heighScoreData[x][2]*12 + heighScoreData[x][3]

      if (tempMonths < currentTotalMonths ) then

        -- winner place above
        position = x
        getNameFromUser()
        break
      elseif (tempMonths == currentTotalMonths and gv.blackoutCounter <= heighScoreData[x][4]) then

        position = x
        getNameFromUser()
        break

      elseif (tempMonths == currentTotalMonths and gv.blackoutCounter > heighScoreData[x][4]
        and x ~= 5 and gv.blackoutCounter <= heighScoreData[x+1][4]) then

        position = x
        getNameFromUser()
        break
      elseif ( tempMonths > currentTotalMonths ) then

        createText()
      end
    end

    -- for printing info to the terminal only. To be Removed
    --        for j = 1,5,1 do
    --              print(heighScoreData[j][1] .."\t\t" .. heighScoreData[j][2] .. "\t\t" ..
    --              heighScoreData[j][3] .. "\t\t" .. heighScoreData[j][4] )
    --        end

  end


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