local composer = require( "composer" )
local widget   = require( "widget" )
local gv       = require( "global" )

local scene = composer.newScene()
local d = 280
local mineOptionsLeft = 0 
local mineOptionsTop = 0 
local textWidth         = d*0.7
local textHeight        = 0

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

-- -------------------------------------------------------------------------------


local function createText(sceneGroup)

	local costText = display.newText("It costs 1 B to mine", mineOptionsLeft + 55,
    	mineOptionsTop + 20, gv.font, gv.fontSize )
    	costText.anchorX,costText.anchorY = 0,0
    	
    local miningInfo = "Coal, Gas, Oil and Uranium are all resourses that our power plants run off of today. They all come from " .. 
    "the earth and there is only a limited amount of them. Once we run out. There will be none left."
    
    local info = display.newText(miningInfo, mineOptionsLeft + 55, costText.y + 40,textWidth, textHeight, gv.font,gv.fontSize)
    info.anchorX, info.anchorY = 0,0
    sceneGroup:insert(costText)
    sceneGroup:insert(info)
     
end

local function mine(event)

	if event.phase == "began" then
		if (gv.money >= 1)then
			gv.money = gv.money -1
			setMoney()
			changeCell()
			gatherResourses()
			composer.hideOverlay()
		end
	end

end

local function cancel(event)

	if(event.phase == "began") then
		composer.hideOverlay()
	end
end

-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view
    mineOptionsLeft = centerX(d)
    mineOptionsTop = centerY(d)

   	local mineOptions = widget.newButton
    {        
        width       = d -20,
        height      = d -10,                
        defaultFile = "Images/land_screen/lnd_buildOverlay.png",              
        id          = "BO",              
        left        = centerX(d),
        top         = centerY(d),        
    }
    
    local btnMine = widget.newButton
    { 
        width         = 50,
        height        = 20,
        shape         = "roundedRect",
        cornerRadius  = 10,     
        label         = "Mine",      
        id            = "btnMine",            
        top           =  mineOptions.height - 20,
        left          =  mineOptionsLeft+80,
        onEvent       = mine     
    }
    
    local btnCancel = widget.newButton
    {
        width         = 60,
        height        = 20,
        shape         = "roundedRect",
        cornerRadius  = 10,
        label         = "Cancel",
        id            = "btnCancel",
        top           = btnMine.y,
        left          = btnMine.x + 70,
        onEvent       = cancel           
    }
    
    btnMine.anchorY = 0
    
   
   
    sceneGroup:insert(mineOptions)
    sceneGroup:insert(btnMine)
    sceneGroup:insert(btnCancel)
   
    createText(sceneGroup)
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