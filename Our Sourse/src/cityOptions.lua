local composer = require( "composer" )
local widget    = require( "widget" )
local gv       = require( "global" )

local scene = composer.newScene()
local cityOptionsBG = widget
local cityOptionsLeft = 0
local cityOptionsTop  = 0
local shiftConstant = 280
local prosWidth = shiftConstant*0.7
local prosHeight = 0
local cityMessage = ""
local costText = ""
local infoText = ""
-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

-- -------------------------------------------------------------------------------

local function createText()

    costText = display.newText("Costs: $4 B", cityOptionsLeft + 35,
    cityOptionsTop + 20, gv.font, gv.fontSize )
    costText.anchorX,costText.anchorY = 0,0

    infoText = display.newText(cityMessage, costText.x,costText.y +30,prosWidth,prosHeight, gv.font,gv.fontSize)
    infoText.anchorX, infoText.anchorY = 0,0    
    infoText.height = infoText.height + 15        

end

local function buy()
    composer.hideOverlay()
end

local function cancel()
    composer.hideOverlay()
end


-- "scene:create()"
function scene:create( event ) 
    
    local sceneGroup = self.view
    cityMessage = "The city owns this land and it must be bought from them. "..
    "land is in high demand, everyone wants a piece so the cost is high. Once "..
    "you buy this you can sell it again but you sell it at a lower price then what you bought it for. "..
    "If you buy this then you still need to pay to put an istablishment on the location as well"
    
     
    cityOptionsTop = centerY(shiftConstant)
    cityOptionsLeft = centerX(shiftConstant) + 20
    
    cityOptionsBG = widget.newButton
    {        
        width       = shiftConstant -20,
        height      = shiftConstant -10,                
        defaultFile = "Images/lnd_buildOverlay.png",              
        id          = "BO",              
        left        = centerX(shiftConstant),
        top         = centerY(shiftConstant),        
    }
    
    local btnBuy = widget.newButton
    { 
        width = 60,
        height = 20,
        shape = "roundedRect",
        cornerRadius = 10,     
        label       = "Buy",      
        id          = "btnBuy",            
        top         =  cityOptionsBG.height - 20,
        left        = cityOptionsLeft+40,
        onEvent = buy     
    }
  
    btnBuy.anchorY = 0
    
    local btnCancel = widget.newButton
    {
        width = 60,
        height = 20,
        shape = "roundedRect",
        cornerRadius = 10,
        label = "Cancel",
        id = "btnCancel",
        top = btnBuy.y,
        left = btnBuy.x + 70,
        onEvent = cancel           
    }
    
    createText()
    
    sceneGroup:insert(cityOptionsBG)
    sceneGroup:insert(costText)
    sceneGroup:insert(infoText)
    sceneGroup:insert(btnBuy)
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