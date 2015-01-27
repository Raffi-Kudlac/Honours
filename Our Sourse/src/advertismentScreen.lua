--[[
Purpose:
This screen is the menu screen currently only holding the play button.

]]

local composer  = require( "composer" )
local gv        = require( "global" )
local widget    = require( "widget" )
local scene     = composer.newScene()
local scrollView
local scrollWidth = 230
local scrollHeight = 200
local entry = {}
local entryData = {}
local boughtButton = {}
local expandShift = 0
local expanded = false
local pressedGroup

-------------------------------------------------
-- PRIVATE FUNCTIONS
-------------------------------------------------

local function buy(event, index)

  if event.phase == "began" then
    gv.advertisements[index]:flipBought()

    if gv.advertisements[index]:getBought() then
      changeBoughtImage(index,"Images/static_screen/st_land.png")
    else
      changeBoughtImage(index,"Images/static_screen/st_money.png")
    end

    -- save power advertisement. effects the demand function
    if (index == 0 and gv.advertisements[0]:getBought() ) then
      alterDemand(true)
    elseif (index == 0 and gv.advertisements[0]:getBought() == false ) then
      alterDemand(false)
    end

    -- safe nuclear power advertisement. effects the nuclear group.
    if (index == 1 and gv.advertisements[1]:getBought() ) then
      gv.groups[1]:setStatus(5)
    elseif (index == 1 and gv.advertisements[1]:getBought() == false ) then
      gv.groups[1]:setStatus(-5)
    end

    -- pro windmill advertisement. effects the anti windmill group.
    if (index == 2 and gv.advertisements[2]:getBought() ) then
      gv.groups[3]:setStatus(5)
    elseif (index == 1 and gv.advertisements[2]:getBought() == false ) then
      gv.groups[3]:setStatus(-5)
    end


    -- pro hydro advertisement. effects envirmentalists group.
    if (index == 3 and gv.advertisements[3]:getBought() ) then
      gv.groups[0]:setStatus(5)
    elseif (index == 3 and gv.advertisements[3]:getBought() == false and gv.hydroCounter > 0 ) then
      gv.groups[0]:setStatus(-5)
    end


    -- Fossil Power advertisement. effects the envirementalists group.
    if (index == 4 and gv.advertisements[4]:getBought() ) then
      gv.groups[0]:setStatus(5)
    elseif (index == 4 and gv.advertisements[4]:getBought() == false ) then
      gv.groups[0]:setStatus(-5)
    end

    if (index == 5 and gv.advertisements[5]:getBought() ) then
      gv.groups[2]:setStatus(3)
    elseif (index == 4 and gv.advertisements[4]:getBought() == false ) then
      gv.groups[0]:setStatus(-3)
    end

  end
end


function changeBoughtImage( index, image )

  local temp = boughtButton[index]
  scrollView:remove(boughtButton[index])

  boughtButton[index] = widget.newButton
    {
      width     = scrollWidth*0.2,
      height    = 40,
      left      = 0,
      top       = 0,
      defaultFile = image,
      onEvent   =   function(event) buy(event, index + 0) end
  }

  boughtButton[index].x       = temp.x
  boughtButton[index].y       = temp.y

  --scrollView:insert(location+2,boughtButton[index])
  scrollView:insert(boughtButton[index])
end

local function showSpecifics(event, index)

  if (event.phase == "ended") then

    local yMarker = entry[index].y + expandShift
    local shift = scrollView.height*0.22

    if expanded == false then
      for  x = index + 1, gv.addCounter -1,1 do

        entry[x].y = yMarker + (x - index - 1 )*shift
        boughtButton[x].y = yMarker + (x - index - 1 )*shift
      end
      pressedGroup = index
      entryData[index].isVisible = true
      expanded = true
    else
      for x = pressedGroup +1, gv.addCounter -1, 1 do

        entry[x].y = entry[x-1].y + shift
        boughtButton[x].y = boughtButton[x-1].y +shift
      end

      entryData[pressedGroup].isVisible = false
      expanded = false
    end
  end


end


local function makeEntries()

  local startingX = scrollView.width*0.08
  local startingY = scrollView.height*0.08
  local path = ""

  for x=0, gv.addCounter - 1, 1 do
    entry[x] = widget.newButton
      {
        width     = scrollView.width*0.6,
        height    = scrollView.height*0.2,
        shape     = "roundedRect",
        fillColor = { default={ 1, 0.2, 0.5, 0.7 }, over={ 1, 0.2, 0.5, 1 } },
        left      = startingX,
        top       = x*scrollView.height*0.22 + startingY,
        labelAlign = "center",
        onEvent   =   function(event) showSpecifics(event, x + 0) end
    }


    if gv.advertisements[x]:getBought() then
      path = "Images/static_screen/st_land.png"
    else
      path = "Images/static_screen/st_money.png"
    end

    boughtButton[x] = widget.newButton
      {
        width     = scrollView.width*0.15,
        height    = scrollView.height*0.15,
        left      = entry[x].width + scrollView.width*0.15,
        top       = entry[x].y - scrollView.height*0.15/2,
        defaultFile = path,
        onEvent   = function(event) buy(event, (x + 0)) end
    }

    entry[x]:setLabel(gv.advertisements[x]:getName())

    --        entryData[x] = widget.newButton
    --        {
    --            width = scrollWidth*0.9,
    --            height = 100,
    --            shape = "roundedRect",
    --            left = startingX,
    --            top = (x+1)*55,
    --            labelAlign = "left",
    --            label = gv.groups[x]:getAbout(),
    --            isEnabled = false,
    --        }
    --        entryData[x].isVisible = false

    entryData[x] = display.newText(gv.advertisements[x]:getEffect(), startingX,
      (x+1)*scrollView.height*0.21 + startingY + startingY, scrollView.width*0.75, expandShift, gv.font, gv.fontSize )
    entryData[x].anchorX,entryData[x].anchorY = 0,0
    entryData[x].isVisible = false
    entryData[x]:setFillColor( gv.fontColourR, gv.fontColourG, gv.fontColourB )

    scrollView:insert(entry[x])
    scrollView:insert(boughtButton[x])
    scrollView:insert(entryData[x])

  end



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
      hideBackground = true,
      horizontalScrollDisabled = true,
      height = BG.height*0.95,
      scrollHeight = BG.height*4,
      topPadding = padding,
      bottomPadding = padding,
      rightPadding = padding,
      leftPadding = padding,
  }

  expandShift = scrollView.height*0.6

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
  sceneGroup:insert(btnBack)
  makeEntries()
  sceneGroup:insert(scrollView)
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