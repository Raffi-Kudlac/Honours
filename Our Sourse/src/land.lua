--[[
    Purpose:    
        This screen is responcible for loading the land Screen and setting up components.
        On this screen the user can build fossil fueled power plants and nuclear power.
        He/She can also buy more land if more is needed. 
]]

local composer = require( "composer" )
local widget   = require( "widget" )
local gv       = require( "global" )
local landTile = require( "landTile" )

local scene = composer.newScene()
local openLand = widget

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

-- -------------------------------------------------------------------------------


local function loadOptions(event)

    local options = {
        isModal = true
    }

    if ( "ended" == event.phase ) then
      if (openLand.tile:getType() == "open") then
          composer.showOverlay("landOptions",options)
      elseif (openLand.tile:getType() == "city owned") then
          composer.showOverlay("cityOptions",options)
      elseif (openLand.tile:getType()=="forest") then
          composer.showOverlay("forestOptions",options)
      end
                                          
    end    

end

-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view
--    print("made it to the land screen")
    local d = 100
    
    openLand = widget.newButton
    {        
        width       = d,
        height      = d,        
        shape = "rect",
--        defaultFile = "Images/st_UICorner.png",              
        id          = "openLand",              
        left        = centerX(d),
        top         = centerY(d),
        onEvent = loadOptions,       
        label = "Open Land"                
    }
    
    openLand.tile = landTile.new("forest")    
    openLand.happy = "test"
    if openLand.happy == "test" then
        openLand:setLabel("It worked")
    end    
    sceneGroup:insert(openLand)
    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
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