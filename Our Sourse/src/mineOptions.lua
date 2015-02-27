--[[
Purpose:
This screen is responcible for confirming that the user wants to mine a location on the grid.
It will disply the cost and general info to the user.
]]

local composer = require( "composer" )
local widget   = require( "widget" )
local gv       = require( "global" )

local scene           = composer.newScene()
local d               = 280
local mineOptionsLeft = 0
local mineOptionsTop  = 0
local textWidth       = d*0.7
local textHeight      = 0
local mineOptions = 0
local costText = 0
local info = 0
local costToMine = 20

-------------------------------------------------
-- PRIVATE FUNCTIONS
-------------------------------------------------

local function createText(sceneGroup)


  local xPosition = (mineOptions.x - mineOptions.width/2) + mineOptions.width*0.1
  local yPosition = (mineOptions.y - mineOptions.height/2) + mineOptions.height*0.1

  costText = display.newText("It costs $" ..costToMine .. " to mine", xPosition,
    yPosition, gv.font, gv.fontSize )
  costText.anchorX,costText.anchorY = 0,0
  costText:setFillColor( gv.fontColourR, gv.fontColourG, gv.fontColourB )

  local miningInfo = "Coal, Gas, Oil and Uranium are all resources that our power plants run off of today. They all come from " ..
    "the earth and there is only a limited amount of them. Once we run out there will be none left."

  info = display.newText(miningInfo, costText.x, costText.y + 20,mineOptions.width*0.85, textHeight, gv.font,gv.fontSize)
  info.anchorX, info.anchorY = 0,0
  info.height = info.height + 10
  info:setFillColor( gv.fontColourR, gv.fontColourG, gv.fontColourB )
end


local function mine(event)

  if event.phase == "began" then    
      gv.money = gv.money - costToMine
      setMoney()
      changeCell()
      gatherResourses()
      alterFoundResourses()
      composer.hideOverlay()    
  end
end


local function cancel(event)

  if(event.phase == "began") then
    composer.hideOverlay()
  end
end


-------------------------------------------------
-- COMPOSER FUNCTIONS
-------------------------------------------------

-- "scene:create()"
function scene:create( event )

  local sceneGroup = self.view

  mineOptions = widget.newButton
    {
      width       = widthCalculator(0.6),
      height      = heightCalculator(0.5),
      defaultFile = "Images/global_images/Horizontal_Box.png",
      id          = "BO",
      left        = centerX(widthCalculator(0.6)),
      top         = centerY(heightCalculator(0.5)),
  }

  createText(sceneGroup)

  local btnMine = widget.newButton
    {
      width         = mineOptions.width*0.3,
      height        = mineOptions.height*0.2,
      defaultFile = "Images/global_images/button1.png",      
      label         = "Mine",
      id            = "btnMine",
      top           =  info.y + info.height,
      left          =  costText.x,
      labelColor = { default={ gv.buttonR, gv.buttonG, gv.buttonB }, over={ gv.buttonOver1,  gv.buttonOver2,  gv.buttonOver3,  gv.buttonOver4 } },
      onEvent       = mine
  }

  local btnCancel = widget.newButton
    {
      width         = mineOptions.width*0.25,
      height        = mineOptions.height*0.2,
      defaultFile   = "Images/global_images/button1.png",    
      label         = "Cancel",
      id            = "btnCancel",
      top           = btnMine.y,
      left          = btnMine.x + mineOptions.width*0.3,
      labelColor = { default={ gv.buttonR, gv.buttonG, gv.buttonB }, over={ gv.buttonOver1,  gv.buttonOver2,  gv.buttonOver3,  gv.buttonOver4 } },
      onEvent       = cancel
  }

  btnMine.anchorY = 0

  sceneGroup:insert(mineOptions)
  sceneGroup:insert(costText)
  sceneGroup:insert(info)
  sceneGroup:insert(btnMine)
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
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene