--[[
    Purpose:    
        This screen is the busness screen. This is where the user can purchase advertisements and
        see the current status of the groups in the game. Here the user can also purchase public servises.

]]

local composer  = require( "composer" )
local gv        = require( "global" )
local widget    = require( "widget" )
local scene     = composer.newScene()

-------------------------------------------------
-- PRIVATE FUNCTIONS
-------------------------------------------------

local function miniScreen(event, destination)

    if ( "ended" == event.phase ) then        
       composer.showOverlay( destination )
    end

end

-------------------------------------------------
-- COMPOSER FUNCTIONS
-------------------------------------------------

-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view
    local tempWidth = 130
    local tempHeight = 100
    local tempShift = 30
    
    local scrollView = widget.newScrollView
    {
        top = centerY(tempHeight),
        left = centerX(tempWidth),
        width = tempWidth,
        height = tempHeight,
        scrollWidth = tempWidth*2,
        scrollHeight = tempHeight*2,
        --listener = scrollListener,        
    }
    
    
    local btnGroupStatus = widget.newButton
    {        
        width     = 100,
        height    = 50,
        shape     = "roundedRect",
        fillColor = { default={ 1, 0.2, 0.5, 0.7 }, over={ 1, 0.2, 0.5, 1 } },        
        id        = "btnPlay",
        label     = "Groups",
        --left      = centerX(100) + 150,
        --top       = centerY(50),
        onEvent   = function( event ) miniScreen(event, "groupScreen") end        
    }
    
    local btnAdvertisements = widget.newButton
    {        
        width     = 100,
        height    = 50,
        shape     = "roundedRect",
        fillColor = { default={ 1, 0.2, 0.5, 0.7 }, over={ 1, 0.2, 0.5, 1 } },        
        id        = "btnAdvertisements",
        label     = "Adds",
        --left      = centerX(100) - 150,
        top       = btnGroupStatus.y + tempShift,
        onEvent   = function( event ) miniScreen(event, "advertismentScreen") end        
    }
    
    local btnPublicServises = widget.newButton
    {        
        width     = 100,
        height    = 50,
        shape     = "roundedRect",
        fillColor = { default={ 1, 0.2, 0.5, 0.7 }, over={ 1, 0.2, 0.5, 1 } },        
        id        = "btnAdvertisements",
        label     = "PublicServis",
        --left      = centerX(100),
        top       = btnAdvertisements.y + tempShift,
        onEvent   = function( event ) miniScreen(event, "publicServisesScreen") end        
    }
    
    
    scrollView:insert( btnGroupStatus )
    scrollView:insert( btnAdvertisements )
    scrollView:insert( btnPublicServises )
    sceneGroup:insert( scrollView )
        
    --sceneGroup:insert(btnGroupStatus)
    --sceneGroup:insert(btnAdvertisments)
    --sceneGroup:insert(btnPublicServises)         
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