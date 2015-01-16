--[[
    Purpose:    
        This screen is the menu screen currently only holding the play button.

]]

local composer  = require( "composer" )
local gv        = require( "global" )
local widget    = require( "widget" )
local scene     = composer.newScene()

local d               = 280
local textWidth       = d*0.7
local textHeight      = 0

-------------------------------------------------
-- PRIVATE FUNCTIONS
-------------------------------------------------

local function text( event )

    if ( event.phase == "began") then
    
        gv.groupActionWinner = -1        
        composer.hideOverlay()    
    end

end


-------------------------------------------------
-- COMPOSER FUNCTIONS
-------------------------------------------------

-- "scene:create()"
function scene:create( event )
    local sceneGroup = self.view
    local message = 0
    
    pause()
    
    if ( gv.groups[gv.groupActionWinner]:getNumberStatus() > 0) then 
        message = gv.groups[gv.groupActionWinner]:getHappyText()
    else
        message = gv.groups[gv.groupActionWinner]:getMadText()
    end
    
    local groupDisplay = widget.newButton
    {        
        width       = d -20,
        height      = d -10,                
        defaultFile = "Images/land_screen/lnd_buildOverlay.png",              
        id          = "BO",              
        left        = centerX(d),
        top         = centerY(d),        
    }
        
    local text = display.newText(message, groupDisplay.x + 10, groupDisplay.y + 40,textWidth, textHeight, gv.font,gv.fontSize)
    text.anchorX, text.anchorY = 0,0
    
    local btnOkay = widget.newButton
    { 
        width         = 50,
        height        = 20,
        shape         = "roundedRect",
        cornerRadius  = 10,     
        label         = "Mine",      
        id            = "btnMine",            
        top           =  groupDisplay.height - 20,
        left          =  (groupDisplay.x + groupDisplay.width)/2,
        onEvent       = okay     
    }
        
    sceneGroup:insert( groupDisplay )
    sceneGroup:insert( text )
    sceneGroup:insert (btnOkay )
                
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
        resume()
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