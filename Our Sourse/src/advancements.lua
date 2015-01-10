--[[
    Purpose:    
        This screen is the menu screen currently only holding the play button.

]]

local composer  = require( "composer" )
local gv        = require( "global" )
local widget    = require( "widget" )
local scene     = composer.newScene()
local d         = 280
local scrollView = 0
local scrollWidth = 230
local scrollHeight = 200
local textWidth       = d*0.7
local textHeight      = 0

-------------------------------------------------
-- PRIVATE FUNCTIONS
-------------------------------------------------
local function okay()

    composer.hideOverlay()
end


-------------------------------------------------
-- COMPOSER FUNCTIONS
-------------------------------------------------

-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view   
    
    local tempText = {}
    local counter = 0
    local yShift = 30
    local xShift = 0

    scrollView = widget.newScrollView
    {
        top = centerY(scrollHeight),
        left = centerX(scrollWidth),
        backgroundColor = { 0.8, 0.8, 0.8 },
        width = scrollWidth,        
        height = scrollHeight,
        scrollWidth = scrollWidth*2,
        scrollHeight = scrollHeight*2,    
    }
    
--    scrollView.anchorX,scrollView.anchorY = 0,0
--    
--    xShift = scrollView.x
--    yShift = ScrollView.y
    
    
    local title = display.newText("You have made an Advancement!", 0,
        0, gv.font, gv.fontSize )
        
    title.anchorX, title.anchorY = 0,0
        
    scrollView:insert(title)
    
    for x = 0,servisCounter - 1,1 do    
        if (gv.publicServisText[x] ~= "" ) then
            tempText[counter] = display.newText(gv.publicServisText[x],0, yShift, textWidth, textHeight, gv.font, gv.fontSize )
            tempText[counter].anchorX, tempText[counter].anchorY = 0,0 
            yShift = yShift + 30
            scrollView:insert(tempText[counter])
            counter = counter + 1
        end
    end 
    
    local btnOkay = widget.newButton
    { 
        width         = 50,
        height        = 20,
        shape         = "roundedRect",
        cornerRadius  = 10,     
        label         = "Okay",      
        id            = "btnOkay",
        top           = yShift,
        left          = 0,                    
        onEvent       = okay     
    }       
    
    scrollView:insert(btnOkay)
    sceneGroup:insert(scrollView) 
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
        for x = 0,servisCounter - 1,1 do
            gv.publicServisText[x] = ""           
        end
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