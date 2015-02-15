--[[
Purpose:
This screen is the menu screen currently only holding the play button.

]]

local composer  = require( "composer" )
local gv        = require( "global" )
local widget    = require( "widget" )
local parse     = require ( "mod_parse")
local scene     = composer.newScene()
local scrollView = 0
local globalPositionValue = 0
local sceneGroup
local nameField
local congrats
local submit



local function textListener( event )

  if (event.phase == "ended" or event.phase == "submitted") then
    gv.submitionName = event.target.text

    if (gv.submitionName == nil ) then
      gv.submitionName = "Player 1"
    end

  end
end

local currentTotalMonths = (gv.year-2000)*12 + gv.month
-------------------------------------------------
-- PRIVATE FUNCTIONS
-------------------------------------------------

local function topTwenty( event )

  local startingY = display.contentHeight*0.05
  local startingX = display.contentWidth/2
  local dataX = display.contentWidth*0.1
  local dataY = startingY
  local scrollDataX = scrollView.width*0.1
  local scrollDataY = scrollView.height*0.1
  local tempText = {}
  local labels = {}
  local labelText = 0
  local message = ""
  
  labels[0] = "Place"
  labels[1] = "Name"
  labels[2] = "Years"
  labels[3] = "Months"
  labels[4] = "BlackOut Months"  
    
    if not event.error then
    
    
        -- Printing Place
        labelText = display.newText(labels[0], dataX,
        dataY, gv.font, gv.fontSize*2 )        
        labelText.anchorX, labelText.anchorY = 0,0        
        labelText:setFillColor( gv.fontColourR, gv.fontColourG, gv.fontColourB )                            
        sceneGroup:insert(labelText)      
        
        for k = 1, #event.results, 1 do
                        
            scrollDataY = scrollDataY + scrollView.height*0.1
            tempText[k] = display.newText(k, scrollDataX,
              scrollDataY, gv.font, gv.fontSize*1.5 )
            tempText[k].anchorX, tempText.anchorY = 0,0
            tempText[k]:setFillColor( gv.fontColourR, gv.fontColourG, gv.fontColourB )
            scrollView:insert(tempText[k])
                
        end
        
        dataX = dataX + widthCalculator(0.15)
        scrollDataY = scrollView.height*0.1
        scrollDataX = dataX - (scrollView.x-scrollView.width/2)
                        
        -- Printing Names
        labelText = display.newText(labels[1], dataX,
        dataY, gv.font, gv.fontSize*2 )        
        labelText.anchorX, labelText.anchorY = 0,0        
        labelText:setFillColor( gv.fontColourR, gv.fontColourG, gv.fontColourB )            
        sceneGroup:insert(labelText)      
        
        for k = 1, #event.results, 1 do
            message = event.results[k].name            
            scrollDataY = scrollDataY + scrollView.height*0.1
            tempText[k] = display.newText(message, scrollDataX,
              scrollDataY, gv.font, gv.fontSize*1.5 )
            tempText[k].anchorX, tempText.anchorY = 0,0
            tempText[k]:setFillColor( gv.fontColourR, gv.fontColourG, gv.fontColourB )
            scrollView:insert(tempText[k])
                
        end
        
        
        dataX = dataX + widthCalculator(0.15)
        scrollDataY = scrollView.height*0.1
        scrollDataX = dataX
                        
        -- Printing Years
        labelText = display.newText(labels[2], dataX,
        dataY, gv.font, gv.fontSize*2 )        
        labelText.anchorX, labelText.anchorY = 0,0        
        labelText:setFillColor( gv.fontColourR, gv.fontColourG, gv.fontColourB )            
        sceneGroup:insert(labelText)      
        
        for k = 1, #event.results, 1 do
            message = event.results[k].year            
            scrollDataY = scrollDataY + scrollView.height*0.1
            tempText[k] = display.newText(message, scrollDataX,
              scrollDataY, gv.font, gv.fontSize*1.5 )
            tempText[k].anchorX, tempText.anchorY = 0.5,0
            tempText[k]:setFillColor( gv.fontColourR, gv.fontColourG, gv.fontColourB )
            scrollView:insert(tempText[k])
                
        end
        
        
        dataX = dataX + widthCalculator(0.15)
        scrollDataY = scrollView.height*0.1
        scrollDataX = dataX
                        
        -- Printing months
        labelText = display.newText(labels[3], dataX,
        dataY, gv.font, gv.fontSize*2 )        
        labelText.anchorX, labelText.anchorY = 0,0        
        labelText:setFillColor( gv.fontColourR, gv.fontColourG, gv.fontColourB )            
        sceneGroup:insert(labelText)      
        
        for k = 1, #event.results, 1 do
            message = event.results[k].month            
            scrollDataY = scrollDataY + scrollView.height*0.1
            tempText[k] = display.newText(message, scrollDataX,
              scrollDataY, gv.font, gv.fontSize*1.5 )
            tempText[k].anchorX, tempText.anchorY = 0.5,0
            tempText[k]:setFillColor( gv.fontColourR, gv.fontColourG, gv.fontColourB )
            scrollView:insert(tempText[k])
                
        end
        
        
        dataX = dataX + widthCalculator(0.15)
        scrollDataY = scrollView.height*0.1
        scrollDataX = dataX + (scrollView.x-scrollView.width/2)
        
        -- Printing BlackoutTime
        labelText = display.newText(labels[4], dataX,
        dataY, gv.font, gv.fontSize*2 )        
        labelText.anchorX, labelText.anchorY = 0,0        
        labelText:setFillColor( gv.fontColourR, gv.fontColourG, gv.fontColourB )            
        sceneGroup:insert(labelText)      
        
        for k = 1, #event.results, 1 do
            message = event.results[k].totalBlackoutTime            
            scrollDataY = scrollDataY + scrollView.height*0.1
            tempText[k] = display.newText(message, scrollDataX,
              scrollDataY, gv.font, gv.fontSize*1.5 )
            tempText[k].anchorX, tempText.anchorY = 0.5,0
            tempText[k]:setFillColor( gv.fontColourR, gv.fontColourG, gv.fontColourB )
            scrollView:insert(tempText[k])
                
        end
                      
    end
    
end


local function topQuery( event )

     local query = {     
    ["order"] = "-totalTime,totalBlackoutTime",    
    ["limit"] = 20,            
  }
  parse:getObjects( "sample", query, topTwenty )  

end

local function loadElements()
    
    
    local padding = 10
    local scrollWidth = widthCalculator(0.9)
    local scrollHeight = heightCalculator(0.6)
    scrollView = widget.newScrollView
    {
      top = centerY(scrollHeight),
      left = centerX(scrollWidth),
      width = scrollWidth,
      height = scrollHeight,      
      hideBackground = true,
      horizontalScrollDisabled = true,      
      scrollHeight = scrollHeight*8,
      topPadding = padding,
      bottomPadding = padding,
      rightPadding = padding,
      leftPadding = padding,
  }
  
  sceneGroup:insert(scrollView)

  local data = { ["name"] = gv.submitionName,["year"] = (gv.year - 2000), ["month"]=gv.month, ["totalBlackoutTime"]=gv.blackoutLengthSum,
    ["totalTime"] = currentTotalMonths} 
    parse:createObject( "sample", data, onCreateObject )
    
       
  timer.performWithDelay(500,topQuery)
  
 
  local btnWidth = widthCalculator(0.2)
  local btnHeight = heightCalculator(0.1)
  local increaseHorizontalShift = 1.1 
  
  local btnBack = widget.newButton
    {
      width     = btnWidth,
      height    = btnHeight,
      defaultFile = "Images/global_images/button1.png",
      left      = centerX(btnWidth) + btnWidth*increaseHorizontalShift,
      top       = display.contentHeight - btnHeight*1.1,
      labelAlign = "center",
      label     = "Back",
      onEvent   =   returnToMainMenu,
  }

  local btnNewGame = widget.newButton
    {
      width     = btnWidth,
      height    = btnHeight,
      defaultFile = "Images/global_images/button1.png",
      left      = centerX(btnWidth),
      top       = display.contentHeight - btnHeight*1.1,
      labelAlign = "center",
      label     = "New Game",
      onEvent   =   newGame,
  }
  
  sceneGroup:insert(btnNewGame)
  sceneGroup:insert(btnBack)
  
        local function globalPosition( event )
        
            if not event.error then
                globalPositionValue = (#event.results) + 1
                print("The global position valie is " .. globalPositionValue)
                
                
                local positionText = "You placed in position " .. globalPositionValue .. " in the world"
        
                local globalPlace = display.newText(positionText, centerX(btnWidth) - btnWidth*increaseHorizontalShift,
                display.contentHeight - btnHeight*1.1, gv.font, gv.fontSize )
                globalPlace:setFillColor( gv.fontColourR, gv.fontColourG, gv.fontColourB )
                sceneGroup:insert(globalPlace)
                end                
        end
        
        
        local query = { 
          ["where"] = {["totalTime"] = {["$gt"]= currentTotalMonths}},
          ["order"] = "-totalTime,totalBlackoutTime",              
        }
  
        parse:getObjects( "sample", query, globalPosition )                
    
end


local function close( event )

    sceneGroup:remove(nameField)
    sceneGroup:remove(submit)
    sceneGroup:remove(congrats)
    
    loadElements()    

end

local function getNameFromUser()

  local congratsText = "Please enter a name below"
  local textFieldWidth = widthCalculator(0.2)
  local textFieldHeight = heightCalculator(0.06)

  nameField = native.newTextField( centerX(textFieldWidth),centerY(textFieldHeight),textFieldWidth ,textFieldHeight)
  nameField.align = "center"
  nameField.size = 28
  nameField:setTextColor( 0, 0, 0 )
  nameField.anchorX, nameField.anchorY = 0,0
  nameField:addEventListener( "userInput", textListener )
  
  
  
   congrats = display.newText(congratsText, nameField.x + nameField.width/2,
            nameField.y - nameField.height, gv.font, gv.fontSize)
  congrats:setFillColor( gv.fontColourR, gv.fontColourG, gv.fontColourB )
  
  sceneGroup:insert(congrats)


  submit = widget.newButton
    {
      width     = textFieldWidth*0.9,
      height    = nameField.height*1.1,
      defaultFile = "Images/global_images/button1.png",
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

  sceneGroup = self.view
  
  if(gv.submitionName == "" or gv.submitionName == nil) then
      getNameFromUser()
  else
      loadElements()
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