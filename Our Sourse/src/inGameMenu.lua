--[[
    Purpose:    
        This screen is the menu screen currently only holding the play button.

]]

local composer  = require( "composer" )
local gv        = require( "global" )
local widget    = require( "widget" )
local scene     = composer.newScene()
local BG
local sizeConstant = 280
-------------------------------------------------
-- PRIVATE FUNCTIONS
-------------------------------------------------


local function resumePlay( event )


    if (event.phase == "began") then                
        composer.hideOverlay()    
    end

end

-------------------------------------------------
-- COMPOSER FUNCTIONS
-------------------------------------------------

-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view
    local verticalShift = 40
    
    BG = widget.newButton
    {        
        width       = sizeConstant -20,
        height      = sizeConstant -10,                
        defaultFile = "Images/land_screen/lnd_buildOverlay.png",              
        id          = "BO",              
        left        = centerX(sizeConstant),
        top         = centerY(sizeConstant),        
    }        
    
    
    local btnNewGame = widget.newButton
    {        
        width     = 100,
        height    = 50,
        shape     = "roundedRect",
        fillColor = { default={ 1, 0.2, 0.5, 0.7 }, over={ 1, 0.2, 0.5, 1 } },        
        id        = "btnPlay",
        label     = "New Game",
        left      = BG.x - 50,
        top       = BG.y - BG.height/3,
        --onEvent   = newGame -- to be made later responcible for restarting the game         
    }
    btnNewGame.anchorx, btnNewGame.anchory = 0,0    
    
    
    local btnQuit = widget.newButton
    {        
        width     = 100,
        height    = 50,
        shape     = "roundedRect",
        fillColor = { default={ 1, 0.2, 0.5, 0.7 }, over={ 1, 0.2, 0.5, 1 } },        
        id        = "btnPlay",
        label     = "Quit",
        left      = BG.x - 50,
        top       = btnNewGame.y + verticalShift, 
        --onEvent = quit -- to be made later responcible for ending the game       
    } 
    
    local btnResume = widget.newButton
    {        
        width     = 100,
        height    = 50,
        shape     = "roundedRect",
        fillColor = { default={ 1, 0.2, 0.5, 0.7 }, over={ 1, 0.2, 0.5, 1 } },        
        id        = "btnPlay",
        label     = "Resume",
        left      = BG.x - 50,
        top       = btnQuit.y + verticalShift, 
        onEvent   = resumePlay,       
    }     
    
    sceneGroup:insert(BG)
    sceneGroup:insert(btnNewGame)
    sceneGroup:insert(btnQuit)
    sceneGroup:insert(btnResume)
    
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
        resume()
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