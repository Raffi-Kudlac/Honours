--[[
Purpose:
This screen is the menu screen currently only holding the play button.

]]

local composer  = require( "composer" )
local gv        = require( "global" )
local widget    = require( "widget" )
local parse     = require ( "mod_parse")
local scene     = composer.newScene()

-------------------------------------------------
-- PRIVATE FUNCTIONS
-------------------------------------------------

local function play( event )

  if ( "ended" == event.phase ) then
    --composer.gotoScene("mining")
    --startingPower()
    --composer.gotoScene("city")
    gv.year = 2018
    gv.month = 8
    gv.blackoutLengthSum = 6
    composer.gotoScene("gameOver")
  end
end


-------------------------------------------------
-- COMPOSER FUNCTIONS
-------------------------------------------------

-- "scene:create()"
function scene:create( event )

  local sceneGroup = self.view

  local btnPlay = widget.newButton
    {
      width     = 100,
      height    = 50,
      shape     = "roundedRect",
      fillColor = { default={ 1, 0.2, 0.5, 0.7 }, over={ 1, 0.2, 0.5, 1 } },
      id        = "btnPlay",
      label     = "PLay",
      left      = centerX(100),
      top       = centerY(50),
      onEvent   = play
  }


  sceneGroup:insert(btnPlay)
  
  
  local function onSample( event )
      
      --print("The count is: " .. #event.results)
      
      print("Index\tTotalTime")      
      for i = 1,#event.results,1  do
          print(i .. "\t\t" .. event.results[i].totalTime)
      end
        
      --print( " Harry's year record is: " .. event.results[1].year )
  end

local queryTable3 = { 
    ["where"] = {["totalTime"] = {["$gt"]= 250}},
    ["order"] = "-totalTime",    
    ["limit"] = 20,            
  }
  
  --parse:getObjects( "sample", queryTable3, onSample )
  
--  local data = { ["name"] = "joe",["year"] = 5, ["month"]=12, ["totalBlackoutTime"]=3} 
--  parse:createObject( "sample", data, onCreateObject )  
--  print("Should have been pushed")
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