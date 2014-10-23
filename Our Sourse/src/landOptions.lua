local composer = require( "composer" )
local widget    = require( "widget" )

local scene = composer.newScene()
local circleWidth = 30
local circleHeight = 30
-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

-- -------------------------------------------------------------------------------

local costText = ""
local productionText = ""



-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view

    local d = 280
    local buildOptionsTop = centerY(d)
    local buildOptionsLeft = centerX(d) + 20
    local widthShift = 10
    local heightShift = 20
    
    local buildOptions = widget.newButton
    {        
        width       = d -20,
        height      = d -10,        
        --shape = "rect",
        defaultFile = "Images/lnd_buildOverlay.png",              
        id          = "BO",              
        left        = centerX(d),
        top         = centerY(d),
        --fillColor = { default={ 0.6, 0, 0, 1 }, over={ 1, 0.2, 0.5, 1 } },
        --label = "Build this"                
    }
    
    
  
    local btnoil = widget.newButton
    {           
        width       = circleWidth,
        height      = circleHeight, 
        id          = "btnoil",
        defaultFile = "Images/st_ff.png",
        top         = buildOptionsTop + heightShift,
        left        = buildOptionsLeft - widthShift
    }
    
    heightShift = heightShift + 40
    
    local btngas = widget.newButton
   {
      width       = circleWidth,
      height      = circleHeight,
      defaultFile = "Images/st_land.png",
      id          = "btngas",       
      top         = buildOptionsTop + heightShift,
      left        = buildOptionsLeft - widthShift
   }
   
   heightShift = heightShift + 40
   
   local btncoal = widget.newButton
   {
      width       = circleWidth,
      height      = circleHeight,
      defaultFile = "Images/st_plant.png",
      id          = "btncoal",
      top         = buildOptionsTop + heightShift,
      left        = buildOptionsLeft - widthShift
   }
   heightShift = heightShift + 40
   
   local btnNP = widget.newButton
   {      
      width       = circleWidth,
      height      = circleHeight,      
      id          = "btnNP",
      defaultFile = "Images/st_city.png",
      top         = buildOptionsTop + heightShift,
      left        = buildOptionsLeft - widthShift
   }
   
  sceneGroup:insert(buildOptions)
  sceneGroup:insert(btnoil)
  sceneGroup:insert(btngas)
  sceneGroup:insert(btncoal)
  sceneGroup:insert(btnNP)
    
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