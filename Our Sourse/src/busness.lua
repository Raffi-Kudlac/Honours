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

function setText()

    local happyGroups = 0
    local adsRunning = 0
    local publicServisesRunning = 0
    
    
    for i=0, gv.groupCounter -1, 1 do        
        if( gv.groups[i]:getNumberStatus() > 0) then
            happyGroups = happyGroups + 1
        end
    end
    
    
    for i = 0, gv.addCounter -1, 1 do 
    
        if(gv.advertisements[i]:getBought()) then        
            adsRunning = adsRunning + 1
        end    
    end
    
    for i = 0, gv.servisCounter -1, 1 do
    
        if( gv.publicServises[i]:getBought() ) then
            publicServisesRunning = publicServisesRunning + 1
        end    
    end
    
    setDataBox("Happy Groups", happyGroups, 1)
    setDataBox("Ads Running", adsRunning, 2)
    setDataBox("Services Running", publicServisesRunning, 3)
    
end

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
  local width = display.contentWidth
  local height = display.contentHeight  
  setText()
  
  local bg = display.newImage("Images/business_screen/bns_bg.png")
  bg.anchorX, bg.anchorY = 0,0
  bg.height = display.contentHeight
  bg.width = display.contentWidth
  bg.x = 0
  bg.y = 0  
  sceneGroup:insert(bg)


  local btnGroupStatus = widget.newButton
    {
      width     = width,
      height    = height,      
      id        = "btnPlay",
      defaultFile = "Images/business_screen/bns_groups.png",       
      left      = 0,
      top       = 0,
      onEvent   = function( event ) miniScreen(event, "groupScreen") end
  }
  
  
  local mask = graphics.newMask( "Images/business_screen/bns_groups_mask.png" )
  local xScale = btnGroupStatus.width/1200
  local yScale = btnGroupStatus.height/800
  
  btnGroupStatus:setMask( mask )
  btnGroupStatus.maskScaleX = xScale
  btnGroupStatus.maskScaleY = yScale
  btnGroupStatus.maskX = btnGroupStatus.width/2
  btnGroupStatus.maskY = btnGroupStatus.height/2
  

  local btnAdvertisements = widget.newButton    
  {
      width     = width,
      height    = height,      
      id        = "btnPlay",
      defaultFile = "Images/business_screen/bns_ads.png",       
      left      = 0,
      top       = 0, 
      onEvent   = function( event ) miniScreen(event, "advertismentScreen") end
  }
  
  mask = graphics.newMask( "Images/business_screen/bns_ads_mask.png" )
  local xScale = btnAdvertisements.width/1200
  local yScale = btnAdvertisements.height/800
  
  btnAdvertisements:setMask( mask )
  btnAdvertisements.maskScaleX = xScale
  btnAdvertisements.maskScaleY = yScale
  btnAdvertisements.maskX = btnAdvertisements.width/2
  btnAdvertisements.maskY = btnAdvertisements.height/2
  
  

  local btnPublicServises = widget.newButton
    {
      width     = width,
      height    = height,      
      id        = "btnPlay",
      defaultFile = "Images/business_screen/bns_public-services.png",       
      left      = 0,
      top       = 0, 
      onEvent   = function( event ) miniScreen(event, "publicServisesScreen") end
  }
  
  
  mask = graphics.newMask( "Images/business_screen/bns_public-services_mask.png" )
  local xScale = btnPublicServises.width/1200
  local yScale = btnPublicServises.height/800
  
  btnPublicServises:setMask( mask )
  btnPublicServises.maskScaleX = xScale
  btnPublicServises.maskScaleY = yScale
  btnPublicServises.maskX = btnPublicServises.width/2
  btnPublicServises.maskY = btnPublicServises.height/2

  sceneGroup:insert( btnGroupStatus )
  sceneGroup:insert( btnAdvertisements )
  sceneGroup:insert( btnPublicServises )
    
end


-- "scene:show()"
function scene:show( event )

  local sceneGroup = self.view
  local phase = event.phase

  if ( phase == "will" ) then
  -- Called when the scene is still off screen (but is about to come on screen).
  setText()
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