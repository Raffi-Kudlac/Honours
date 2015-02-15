--[[
Purpose:
This screen is the menu screen currently only holding the play button.

]]

local composer  = require( "composer" )
local gv        = require( "global" )
local widget    = require( "widget" )
local scene     = composer.newScene()
local entry     = {}
local entryData = {}
local faces = {}
local scrollView
local expanded = false
local pressedGroup
local expandShift = 0

local scrollWidth = 230
local scrollHeight = 200


-------------------------------------------------
-- PRIVATE FUNCTIONS
-------------------------------------------------

local function showSpecifics(event, index)

  if (event.phase == "ended") then

    local yMarker = entry[index].y + expandShift
    local shift = scrollView.height*0.22

    if expanded == false then
      for  x = index + 1, gv.groupCounter -1,1 do

        entry[x].y = yMarker + (x - index - 1 )*shift
      end
      pressedGroup = index
      entryData[index].isVisible = true
      expanded = true
    else
      for x = pressedGroup +1, gv.groupCounter -1, 1 do

        entry[x].y = entry[x-1].y + shift
      end

      entryData[pressedGroup].isVisible = false
      expanded = false
    end
  end


end


local function makeEntries()

  local startingX = scrollView.width*0.08
  local startingY = scrollView.height*0.08
  local emotion = 0

  for x=0, gv.groupCounter - 1, 1 do
    entry[x] = widget.newButton
      {
        width     = scrollView.width*0.6,
        height    = scrollView.height*0.2,
        defaultFile = "Images/global_images/button1.png", 
        left      = startingX,
        top       = x*scrollView.height*0.22 + startingY,
        labelAlign = "center",
        onEvent   =   function(event) showSpecifics(event, x + 0) end
    }    
    entry[x]:setLabel(gv.groups[x]:getName())
    emotion = gv.groups[x]:getStatus()
    
    faces[x] = widget.newButton
    {
        width = scrollView.width*0.2,
        height = scrollView.height*0.2,
        defaultFile = emotion,
        top = entry[x].y - entry[x].height/2,
        left = entry[x].x + entry[x].width/2 + scrollView.width*0.05,        
    }

    entryData[x] = display.newText(gv.groups[x]:getAbout(), startingX, (x+1)*scrollView.height*0.21 + startingY,
      scrollView.width*0.85, expandShift, gv.font, gv.fontSize )
    entryData[x]:setFillColor( gv.fontColourR, gv.fontColourG, gv.fontColourB )
    entryData[x].isVisible = false
    entryData[x].anchorX,entryData[x].anchorY = 0,0

    scrollView:insert(entry[x])
    scrollView:insert(faces[x])
    scrollView:insert(entryData[x])

  end
end

local function updateEmotions()

    for x=0, gv.groupCounter - 1, 1 do
        scrollView:remove(entry[x])
        scrollView:remove(entryData[x])
        scrollView:remove(faces[x])        
    end
    
    makeEntries()

end

local function back (event)

  if (event.phase == "began") then
    composer.hideOverlay()
  end

end


-------------------------------------------------
-- COMPOSER FUNCTIONS
-------------------------------------------------

-- "scene:create()"
function scene:create( event )

  local sceneGroup = self.view
  local widthValue = widthCalculator(0.45)
  local heightValue = heightCalculator(0.8)
  local padding = 5


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
      height = heightValue,
      --scrollWidth = scrollWidth*2,
      scrollHeight = heightValue*2,
      hideBackground = true,
      horizontalScrollDisabled = true,
      topPadding = padding,
      bottomPadding = padding,
      rightPadding = padding,
      leftPadding = padding,

  }

  expandShift = scrollView.height*0.75
  makeEntries()

  local btnBack = widget.newButton
    {
      left = (scrollView.x - scrollView.width/2) - 120,
      top = scrollView.y - scrollView.height/2,
      id = "back",
      label = "back",
      width = 80,
      height = 40,
      shape = "rect",
      onEvent = back
  }
  sceneGroup:insert(scrollView)
  sceneGroup:insert(btnBack)
end


-- "scene:show()"
function scene:show( event )

  local sceneGroup = self.view
  local phase = event.phase

  if ( phase == "will" ) then
  -- Called when the scene is still off screen (but is about to come on screen).
      updateEmotions()
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