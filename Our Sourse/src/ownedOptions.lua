--[[
    Purpose:    
        This screen appears on top of the land screen (layOver screen) and is responcible
        for displaying the option of demolishing the power plant to the user

]]

local composer = require( "composer" )
local widget   = require( "widget" )
local scene    = composer.newScene()
local gv       = require( "global" )

local ownedOptionsBG    = widget
local ownedOptionsLeft  = 0
local ownedOptionsTop   = 0
local shiftConstant     = 280
local prosWidth         = shiftConstant*0.7
local prosHeight        = 0

local message   = ""
local costText  = ""
local infoText  = ""
-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

-- -------------------------------------------------------------------------------

local function createText()

    costText = display.newText("Costs: $4 B", ownedOptionsLeft + 35,
    ownedOptionsTop + 20, gv.font, gv.fontSize )
    costText.anchorX,costText.anchorY = 0,0

    infoText = display.newText(message, costText.x,costText.y +30,prosWidth,prosHeight, gv.font,gv.fontSize)
    infoText.anchorX, infoText.anchorY = 0,0    
    infoText.height = infoText.height + 15        
end


local function demolish(event)

    if(event.phase == "began") then
        
        if(gv.money >= 4) then
            gv.money = gv.money - 4
            convertButton("Images/land_screen/lnd_tile_plain.png",gv.marker, "open")
            composer.hideOverlay()
        end
                
    end
end


local function cancel()
    composer.hideOverlay()
end


-- "scene:create()"
function scene:create( event ) 

    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
    local sceneGroup = self.view
    
    message = "From here you can demlosh you power plant to make room for a bigger one if you so chose"
    
     
    ownedOptionsTop = centerY(shiftConstant)
    ownedOptionsLeft = centerX(shiftConstant) + 20
    
    ownedOptionsBG = widget.newButton
    {        
        width       = shiftConstant -20,
        height      = shiftConstant -10,                
        defaultFile = "Images/land_screen/lnd_buildOverlay.png",              
        id          = "BO",              
        left        = centerX(shiftConstant),
        top         = centerY(shiftConstant),        
    }
    
    local btnDemolish = widget.newButton
    { 
        width         = 60,
        height        = 20,
        shape         = "roundedRect",
        cornerRadius  = 10,     
        label         = "Buy",      
        id            = "btnBuy",            
        top           =  ownedOptionsBG.height - 20,
        left          = ownedOptionsLeft+40,
        onEvent       = demolish     
    }
  
    btnDemolish.anchorY = 0
    
    local btnCancel = widget.newButton
    {
        width         = 60,
        height        = 20,
        shape         = "roundedRect",
        cornerRadius  = 10,
        label         = "Cancel",
        id            = "btnCancel",
        top           = btnDemolish.y,
        left          = btnDemolish.x + 70,
        onEvent       = cancel           
    }
    
    createText()
    
    sceneGroup:insert(ownedOptionsBG)
    sceneGroup:insert(costText)
    sceneGroup:insert(infoText)
    sceneGroup:insert(btnDemolish)
    sceneGroup:insert(btnCancel)  
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


-- -------------------------------------------------------------------------------

return scene