--[[
    Purpose: 
        This screen creates the city screen where the user can see how the population is doing and of
        he/she is meeting the demand.
]]

local composer  = require( "composer" )
local scene     = composer.newScene()
local gv        = require( "global" )

local scaleOverlay = display.newImage("Images/city_screen/cty_scaleOverlay.png")
local maxSOHeight = 0
 


-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

-- -------------------------------------------------------------------------------

local function scaleOverlayHeightCalculator()
  
    -- conversion ratio for now is maxHeight = 5Gw 
    local net = gv.powerSupplied - gv.powerDemanded
    
    local percent = net/5
    
    scaleOverlay.height = maxSOHeight*percent

end

-- "scene:create()"
function scene:create( event )
    
    local sceneGroup = self.view
    print("Made it to the city Screen")
    buildStaticScreen()    
    timeStart()
    setDataBox("Population", gv.population, 1)
    setDataBox("Demanded", gv.powerDemanded.."GW", 2)
    setDataBox("Supplied", gv.powerSupplied.."GW", 3)
    
    local scale = display.newImage("Images/city_screen/cty_scale.png")
    
    scale.anchorX,scale.anchorY = 0,0.5
    scale.x = 15
    scale.y = 100 
    scale:scale(0.3,0.18)
    
   
    scaleOverlay.anchorX,scaleOverlay.anchorY = 0,1    
    scaleOverlay.x = scale.x 
    scaleOverlay.y = scale.y    
    scaleOverlay:scale(0.3,0.18)
    maxSOHeight = scaleOverlay.height       
    scaleOverlay:setFillColor(0,1,0)
    scaleOverlayHeightCalculator()
    
    local bg = display.newImage("Images/city_screen/cty_bg.png")    
    bg.Height = centerY(bg.height)
    bg.Width = centerX(bg.width)
    bg.x = 40
    bg.y = 0
        
        
    sceneGroup:insert(bg)       
    sceneGroup:insert(scale)
    sceneGroup:insert(scaleOverlay)
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

function netPower()

    return gv.powerSupplied - gv.powerDemanded 

end

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene