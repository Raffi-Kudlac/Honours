local composer = require( "composer" )
local widget   = require( "widget" )
local gv       = require( "global" )
local scene = composer.newScene()
local width = 150
local height = 150

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

-- -------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view

	print("made it to the map")
    
	local fossile_fuels = widget.newButton
	{
		top = centerY(height),
		left = centerX(width),
	    width = width,
	    height = height,
	    --defaultFile = "buttonDefault.png",
	    shape = "rect",	    
	    label = "Fossile Fuels",	 
	    onEvent = function() return goToScreen("mining") end,   
	}
	
	local hydro = widget.newButton
	{
		top = centerY(height),
		left = centerX(width) - 200,
	    width = width,
	    height = height,
	    --defaultFile = "buttonDefault.png",
	    shape = "rect",	    
	    label = "water",	 
	    onEvent = function() return goToScreen("hydro") end,   
	}
	
	local natural = widget.newButton
	{
		top = centerY(height),
		left = centerX(width)+200,
	    width = width,
	    height = height,
	    --defaultFile = "buttonDefault.png",
	    shape = "rect",	    
	    label = "natural",	 
	    onEvent = function() return goToScreen("natural") end,   
	}
	
	
	sceneGroup:insert(fossile_fuels)
	sceneGroup:insert(hydro)
	sceneGroup:insert(natural)
	
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