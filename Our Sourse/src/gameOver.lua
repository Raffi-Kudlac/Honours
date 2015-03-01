--[[
Purpose:
This screen is the menu screen currently only holding the play button.

]]

local composer  = require( "composer" )
local gv        = require( "global" )
local widget    = require( "widget" )
local parse     = require ( "mod_parse")
local connection = require("testconnection")
local scene     = composer.newScene()


local heighScoreData = {}      --used to store data read from the file
local path = system.pathForFile( "localHighScores.txt", system.DocumentsDirectory)
local file = nil
local name = ""
local position = -1
local currentTotalMonths = (gv.year-2000)*12 + gv.monthCounter
local tempMonths = 0
local nameField = ""
local submit = ""
local congrats = 0
local gameOverText = 0
local sceneGroup = ""
local globalPositionValue = 0
local winningData = {}

-------------------------------------------------
-- PRIVATE FUNCTIONS
-------------------------------------------------

local function textListener( event )

  if (event.phase == "ended" or event.phase == "submitted") then
    gv.submitionName = event.target.text

    if (gv.submitionName == nil or gv.submitionName == "") then
      gv.submitionName = "Player 1"
    end

  end
end


local function goGlobal( event )
          
    if (event.phase == "began"  and connection.test()) then
        composer.gotoScene("gameOverGlobalScores")
    end 

end

local function createText()

  local startingY = display.contentHeight*0.1
  local startingX = display.contentWidth/2
  local dataX = display.contentWidth*0.1
  local dataY = display.contentHeight*0.25
  local tempText = {}
  local labels = {}
  local labelText = 0
  local message = ""  
  local reasonForEnd = ""
  local localTotalScore = ""
  
  if(gv.money < -100 ) then
      reasonForEnd = "You ran into debt"
  elseif(gv.blackoutLengthCounter >= 10) then
      reasonForEnd = "A Blackout lasted to long"      
  elseif(#gv.blackoutTimes == 4) then
      reasonForEnd = "Too many blackouts have happened"
  elseif( gv.blackoutLengthSum + gv.blackoutLengthCounter >= 12) then
      reasonForEnd = "Too many months have been blackouts"
  end
  
  localTotalScore = ". Lasting " .. (gv.year-2000) .. " years and " .. gv.monthCounter .. " month(s). With " .. 
          "a total Blackout time of " .. gv.blackoutCounter .. " month(s)." 
  
  labels[1] = "Name"
  labels[2] = "Years"
  labels[3] = "Months"
  labels[4] = "Blackout Months"
  
  local function globalPosition( event )
        
      if not event.error then
          local place = (#event.results) + 1
          local prefix = ""
          local spot = place % 10
          
          if spot == 1 then
              
              prefix = "st"          
          elseif spot == 2 then
          
              prefix = "nd"
          elseif spot == 3 then
              
              prefix = "rd"
          else
          
              prefix = "th"
          end
          message = "Game Over: " .. reasonForEnd.. localTotalScore.. "\n Placing " .. tostring(place) .. prefix .. " in the world." 
          
          local title = display.newText(message, startingX,
            startingY, widthCalculator(0.8), 0, gv.font, gv.fontSize*1.5 )
          --title.anchorX, title.anchorY = 0,0
          title:setFillColor( gv.fontColourR, gv.fontColourG, gv.fontColourB )
          sceneGroup:insert(title)                              
      end                              
  end
  
  
  local query = { 
          ["where"] = {["totalTime"] = {["$gt"]= currentTotalMonths}},
          ["order"] = "-totalTime,totalBlackoutTime",              
        }
  
  if (connection.test()) then
      parse:getObjects( "sample", query, globalPosition )
      print("This got called incorrectly")
  else   
      print("This was supposed to happen")
      message = "Game Over: " .. reasonForEnd .. localTotalScore       
      local title = display.newText(message, startingX,
            startingY, widthCalculator(0.8), 0, gv.font, gv.fontSize*1.5 )
          --title.anchorX, title.anchorY = 0,0
          title:setFillColor( gv.fontColourR, gv.fontColourG, gv.fontColourB )
          sceneGroup:insert(title)            
  end

    
  -- Printing names
  labelText = display.newText(labels[1], dataX,
        dataY, gv.font, gv.fontSize*2 )        
  labelText.anchorX, labelText.anchorY = 0,0        
  labelText:setFillColor( gv.fontColourR, gv.fontColourG, gv.fontColourB )      
  dataY = dataY +heightCalculator(0.05)
        
  sceneGroup:insert(labelText)    
  
  for k = 1, 5, 1 do
      if ( tostring(heighScoreData[k][1]) ~= "-1") then          
          message = heighScoreData[k][1]
          dataY = dataY + heightCalculator(0.1)
          tempText[k] = display.newText(message, dataX,
            dataY, gv.font, gv.fontSize*1.5 )
          tempText[k].anchorX, tempText.anchorY = 0,0
          tempText[k]:setFillColor( gv.fontColourR, gv.fontColourG, gv.fontColourB )
          sceneGroup:insert(tempText[k])
       end    
  end
  
  
  -- Printing Years
  dataX = dataX + widthCalculator(0.2)
  dataY = display.contentHeight*0.25
  
  labelText = display.newText(labels[2], dataX,
        dataY, gv.font, gv.fontSize*2 )        
  labelText.anchorX, labelText.anchorY = 0,0        
  labelText:setFillColor( gv.fontColourR, gv.fontColourG, gv.fontColourB )      
  dataY = dataY +heightCalculator(0.05)
        
  sceneGroup:insert(labelText) 
  dataX = dataX + labelText.width/2     
  
  for k = 1, 5, 1 do
      if ( heighScoreData[k][2] ~= -1) then
          message = heighScoreData[k][2]
          dataY = dataY + heightCalculator(0.1)
          tempText[k] = display.newText(message, dataX,
            dataY, gv.font, gv.fontSize*1.5 )
          tempText[k].anchorX, tempText.anchorY = 0.5,0
          tempText[k]:setFillColor( gv.fontColourR, gv.fontColourG, gv.fontColourB )
          sceneGroup:insert(tempText[k])
       end    
  end
  
  
  -- Printing Months
  dataX = dataX + widthCalculator(0.2) - labelText.width/2
  dataY = display.contentHeight*0.25
  
  labelText = display.newText(labels[3], dataX,
        dataY, gv.font, gv.fontSize*2 )        
  labelText.anchorX, labelText.anchorY = 0,0        
  labelText:setFillColor( gv.fontColourR, gv.fontColourG, gv.fontColourB )      
  dataY = dataY + heightCalculator(0.05)
        
  sceneGroup:insert(labelText)
  dataX = dataX + labelText.width/2      
  
  for k = 1, 5, 1 do
      if ( heighScoreData[k][3] ~= -1) then
          message = heighScoreData[k][3]
          dataY = dataY + heightCalculator(0.1)
          tempText[k] = display.newText(message, dataX,
            dataY, gv.font, gv.fontSize*1.5 )
          tempText[k].anchorX, tempText.anchorY = 0.5,0
          tempText[k]:setFillColor( gv.fontColourR, gv.fontColourG, gv.fontColourB )
          sceneGroup:insert(tempText[k])
       end    
  end
  
  
  -- Printing BlackOut Months
  dataX = dataX + widthCalculator(0.2) - labelText.width/2
  dataY = display.contentHeight*0.25
  
  labelText = display.newText(labels[4], dataX,
        dataY, gv.font, gv.fontSize*2 )        
  labelText.anchorX, labelText.anchorY = 0,0        
  labelText:setFillColor( gv.fontColourR, gv.fontColourG, gv.fontColourB )      
  dataY = dataY +heightCalculator(0.05)
        
  sceneGroup:insert(labelText)
  
  dataX = dataX + labelText.width/2      
  
  for k = 1, 5, 1 do
      if ( heighScoreData[k][4] ~= -1) then
          message = heighScoreData[k][4]
          dataY = dataY + heightCalculator(0.1)
          tempText[k] = display.newText(message, dataX,
            dataY, gv.font, gv.fontSize*1.5 )
          tempText[k].anchorX, tempText.anchorY = 0.5,0
          tempText[k]:setFillColor( gv.fontColourR, gv.fontColourG, gv.fontColourB )
          sceneGroup:insert(tempText[k])
       end    
  end
  
  local btnWidth = widthCalculator(0.2)
  local btnHeight = heightCalculator(0.1)
  local increaseHorizontalShift = 1.1 
  
  local back = widget.newButton
    {
      width     = btnWidth,
      height    = btnHeight,
      defaultFile = "Images/global_images/button1.png",
      left      = centerX(btnWidth) - btnWidth*increaseHorizontalShift,
      top       = display.contentHeight - heightCalculator(0.1),
      labelAlign = "center",
      label     = "Back",
      labelColor = { default={ gv.buttonR, gv.buttonG, gv.buttonB }, over={ gv.buttonOver1,  gv.buttonOver2,  gv.buttonOver3,  gv.buttonOver4 } },
      onEvent   =   returnToMainMenuFromGameOver,
  }

  local newGame = widget.newButton
    {
      width     = btnWidth,
      height    = btnHeight,
      defaultFile = "Images/global_images/button1.png",
      left      = centerX(btnWidth),
      top       = display.contentHeight - heightCalculator(0.1),
      labelAlign = "center",
      label     = "New Game",
      labelColor = { default={ gv.buttonR, gv.buttonG, gv.buttonB }, over={ gv.buttonOver1,  gv.buttonOver2,  gv.buttonOver3,  gv.buttonOver4 } },
      onEvent   =   newGameFromGameOver,
  }
  
  
  local goGlobal = widget.newButton
    {
      width     = btnWidth,
      height    = btnHeight,
      defaultFile = "Images/global_images/button1.png",
      left      = centerX(btnWidth) + btnWidth*increaseHorizontalShift,
      top       = display.contentHeight - heightCalculator(0.1),
      labelAlign = "center",
      label     = "Go Global",
      labelColor = { default={ gv.buttonR, gv.buttonG, gv.buttonB }, over={ gv.buttonOver1,  gv.buttonOver2,  gv.buttonOver3,  gv.buttonOver4 } },
      onEvent   =   goGlobal,
  }

  sceneGroup:insert(back)
  sceneGroup:insert(goGlobal)
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
    
    if (gv.submitionName == nil or gv.submitionName == "") then
      gv.submitionName = "Player 1"
    end
    
    local winningData = {gv.submitionName,(gv.year-2000), gv.monthCounter, gv.blackoutCounter}
    table.insert(heighScoreData, position, winningData)


    -- trims the high scores so only 5 exist
    if (#heighScoreData == 6) then
      table.remove(heighScoreData, 6)
    end

    write()
    sceneGroup:remove(nameField)
    sceneGroup:remove(submit)
    sceneGroup:remove(congrats)
    sceneGroup:remove(gameOverText)
    createText()
  end

end


local function getNameFromUser()
  
  
  local congratsText = "Congratulations, You have made a high Score. Please enter a name below"
  local textFieldWidth = widthCalculator(0.2)
  local textFieldHeight = heightCalculator(0.1)

  nameField = native.newTextField( centerX(textFieldWidth),centerY(textFieldHeight),textFieldWidth ,textFieldHeight)
  nameField.align = "center"
  nameField.size = 28
  nameField:setTextColor( 0, 0, 0 )
  nameField.anchorX, nameField.anchorY = 0,0
  nameField:addEventListener( "userInput", textListener )
  
  congrats = display.newText(congratsText, nameField.x + nameField.width/2,
            nameField.y - nameField.height,widthCalculator(0.7),0, gv.font, gv.fontSize)
  congrats:setFillColor( gv.fontColourR, gv.fontColourG, gv.fontColourB )  
  sceneGroup:insert(congrats)
  
  gameOverText = display.newText("Game Over", nameField.x + nameField.width*0.7,
            congrats.y - heightCalculator(0.1), widthCalculator(0.3), 0, gv.font, gv.fontSize*2)
  gameOverText:setFillColor( gv.fontColourR, gv.fontColourG, gv.fontColourB )  
  sceneGroup:insert(gameOverText)


  submit = widget.newButton
    {
      width     = textFieldWidth*0.9,
      height    = nameField.height*1.1,
      shape     = "roundedRect",
      fillColor = { default={ 1, 0.2, 0.5, 0.7 }, over={ 1, 0.2, 0.5, 1 } },
      left      = centerX(textFieldWidth*0.9),
      top       = nameField.y + nameField.height*1.2,
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

  -- array will hold data in the file
  for x =1,5,1 do
    heighScoreData[x] = {-1,-1,-1,-1}
  end

  if ( path ~= nil) then -- make path to file
    file = io.open(path , "r")

    if (file == nil ) then -- file does not exist
      createFile()        --  creates file and makes connection to it
      file = io.open(path , "r")
    end

    local x = 1
    local y = 1
    
    -- loads file into array
    for line in file:lines() do
      heighScoreData[x][y] = line

      if (y ~= 1) then
        heighScoreData[x][y] = tonumber(heighScoreData[x][y])
      else
        heighScoreData[x][y] = tostring(heighScoreData[x][y])
      end

      y = y +1

      if(y==5) then
        y = 1
        x = x+1
      end
    end

    io.close(file)

    currentTotalMonths = (gv.year-2000)*12 + gv.monthCounter
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
      elseif ( tempMonths >= currentTotalMonths and x == 5 ) then        
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