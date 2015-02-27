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

  local xShift = 0

  local widthValue = widthCalculator(0.45)
  local heightValue = heightCalculator(0.5)
  textWidth = widthValue*0.9

  local BG = widget.newButton
    {
      width       = widthValue,
      height      = heightValue,
      defaultFile = "Images/global_images/Vertical_Box.png",
      id          = "BO",
      left        = centerX(widthValue),
      top         = centerY(heightValue),
  }

  sceneGroup:insert(BG)


  scrollView = widget.newScrollView
    {
      top = centerY(heightValue),
      left = centerX(widthValue),
      width = widthValue,
      height = heightValue*0.95,
      hideBackground = true,
      horizontalScrollDisabled = true,
      scrollHeight = heightValue*2,
      topPadding = padding,
      bottomPadding = padding,
      rightPadding = padding,
      leftPadding = padding,
  }

  local yShift = scrollView.height*0.2

  --    scrollView.anchorX,scrollView.anchorY = 0,0
  --
  --    xShift = scrollView.x
  --    yShift = ScrollView.y


  local title = display.newText("You have made an Advancement!", scrollView.width*0.05,
    scrollView.height*0.05, gv.font, gv.fontSize )
  title.anchorX, title.anchorY = 0,0
  title:setFillColor( gv.fontColourR, gv.fontColourG, gv.fontColourB )

  scrollView:insert(title)

  for x = 0,servisCounter - 1,1 do
    if (gv.publicServisText[x] ~= "" ) then
      tempText[counter] = display.newText(gv.publicServisText[x],scrollView.width*0.05, yShift, textWidth, textHeight,
        gv.font, gv.fontSize )
      tempText[counter].anchorX, tempText[counter].anchorY = 0,0
      tempText[counter]:setFillColor( gv.fontColourR, gv.fontColourG, gv.fontColourB )
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
      top           = BG.y + BG.height/2 - BG.height*0.2,
      left          = BG.x - BG.width/2 + BG.width*0.05,
      onEvent       = okay
  }

  --scrollView:insert(btnOkay)
  sceneGroup:insert(scrollView)
  sceneGroup:insert(btnOkay)
end


-- "scene:show()"
function scene:show( event )

  local sceneGroup = self.view
  local phase = event.phase

  if ( phase == "will" ) then
  -- Called when the scene is still off screen (but is about to come on screen).
      shiftMovie()
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
    for x = 0,gv.servisCounter - 1,1 do
      gv.publicServisText[x] = ""
    end
    -- Called when the scene is on screen (but is about to go off screen).
    -- Insert code here to "pause" the scene.
    -- Example: stop timers, stop animation, stop audio, etc.
  elseif ( phase == "did" ) then
  -- Called immediately after scene goes off screen.
      returnMovie()
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