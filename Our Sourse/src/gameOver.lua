--[[
    Purpose:    
        This screen is the menu screen currently only holding the play button.

]]

local composer  = require( "composer" )
local gv        = require( "global" )
local widget    = require( "widget" )
local scene     = composer.newScene()

-------------------------------------------------
-- PRIVATE FUNCTIONS
-------------------------------------------------

local function getNameFromUser()

    nameField = native.newTextField( centerX(180),centerY(50), 180, 50 )

    nameField:addEventListener( "userInput", textListener )     

end

-------------------------------------------------
-- COMPOSER FUNCTIONS
-------------------------------------------------

-- "scene:create()"
function scene:create( event )
    
    
    -- format of the file is Name, year, month, # of blackout months
    local sceneGroup = self.view
    
    local highScoreData = {}      --used to store data read from the file
    local path = system.pathForFile( "localHighScores.txt", system.DocumentsDirectory)
    local file = nil
    local x = 1
    local y = 1
    local currentTotalMonths = (gv.year-2000)*12 + gv.month
    local tempMonths = 0
    local winningData = {}

    for x =1,5,1 do
        highScoreData[x] = {-1,-1,-1,-1}
    end
    
    if ( path ~= nil) then
        file = io.open(path , "r")
        
        for line in file:lines() do
          highScoreData[x][y] = line
          y = y +1
          
          if(y==5) then
            y = 1
            x = x+1
          end
        end
        
        io.close(file)
        
        for x = 1, 5, 1 do
        
            tempMonths = highScoreData[x][2]*12 + highScoreData[x][3]
            
            if (tempMonths < currentTotalMonths ) then
                
                -- winner place above
                local name = getNameFromUser()
                winningData = {name,gv.year, gv.month, gv.blackoutCounter}
                table:insert(heighScoreData, x, winningData)                                
            elseif ( tempMonths > currentTotalMonths ) then
                
                -- not a high score. do nothing                
            elseif (tempMonths == currentTotalMonths and gv.blackoutCounter <= hightScoreData[x][4]) then
                
                -- place above
                local name = getNameFromUser()
                winningData = {name,gv.year, gv.month, gv.blackoutCounter}
                table:insert(heighScoreData, x, winningData)              
            elseif (tempMonths == currentTotalMonths and gv.blackoutCounter > hightScoreData[x][4] and x ~= 5) then
                
                -- place below
                local name  = getNameFromUser()
                winningData = {name,gv.year, gv.month, gv.blackoutCounter}
                table:insert(heighScoreData, x+1, winningData)              
            end                
        end
        
        -- trims the high scores so only 5 exist
        if (#heighScoreData == 6) then
            table:remove(heighScoreData, 6)
        end
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