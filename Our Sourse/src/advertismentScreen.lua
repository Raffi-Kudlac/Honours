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

  if event.phase == "ended" then
    gv.advertisements[index]:flipBought()
    if gv.advertisements[index]:getBought() then
      changeBoughtImage(index,"Images/static_screen/st_purchased.png")
      gv.addButtonCounter = gv.addButtonCounter + 1
    else
      changeBoughtImage(index,"Images/static_screen/st_money.png")
    end
    
    setText()
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


--    -- pro hydro advertisement. effects envirmentalists group.
--    if (index == 3 and gv.advertisements[3]:getBought() ) then
--      gv.groups[0]:setStatus(5)
--    elseif (index == 3 and gv.advertisements[3]:getBought() == false and gv.hydroCounter > 0 ) then
--      gv.groups[0]:setStatus(-5)
--    end


    -- Fossil Power advertisement. effects the envirementalists group.
    if (index == 3 and gv.advertisements[3]:getBought() ) then
      gv.groups[0]:setStatus(5)
    elseif (index == 3 and gv.advertisements[3]:getBought() == false ) then
      gv.groups[0]:setStatus(-5)
    end

    if (index == 4 and gv.advertisements[4]:getBought() ) then
      gv.groups[2]:setStatus(3)
    elseif (index == 4 and gv.advertisements[4]:getBought() == false ) then
      gv.groups[0]:setStatus(-3)
    end
  
  elseif (event.phase == "moved") then
       local dy = math.abs( ( event.y - event.yStart ) )
               
        if ( dy > 10 ) then
            scrollView:takeFocus( event )
        end    
  end
end


function changeBoughtImage( index, image )

  local tempx = boughtButton[index].x
  local tempy = boughtButton[index].y
  
  --scrollView:remove(boughtButton[index])
  
  boughtButton[index]:removeSelf()

  boughtButton[index] = widget.newButton
    {
      width     = scrollView.width*0.15,
      height    = scrollView.height*0.15,
      left      = 0,
      top       = 0,
      defaultFile = image,
      onEvent   =   function(event) buy(event, index + 0) end
  }

  boughtButton[index].x       = tempx
  boughtButton[index].y       = tempy

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
      scrollView:scrollToPosition
      {          
          y = -entry[index].y*0.8,
          time = 0,          
      }
      
    else
      for x = pressedGroup +1, gv.addCounter -1, 1 do

        entry[x].y = entry[x-1].y + shift
        boughtButton[x].y = boughtButton[x-1].y +shift
      end

      entryData[pressedGroup].isVisible = false
      expanded = false
      
      scrollView:scrollToPosition
      {          
          y = 0,
          time = 0,          
      }

    end
    
  elseif (event.phase == "moved") then
       local dy = math.abs( ( event.y - event.yStart ) )
               
        if ( dy > 10 ) then
            scrollView:takeFocus( event )
        end       
  end


end


local function makeEntries()

  local startingX = scrollView.width*0.04
  local startingY = scrollView.height*0.08
  local path = ""

  for x=0, gv.addCounter - 1, 1 do
    entry[x] = widget.newButton
      {
        width     = scrollView.width*0.7,
        height    = scrollView.height*0.2,
        defaultFile = "Images/global_images/button1.png",
        left      = startingX,
        top       = x*scrollView.height*0.22 + startingY,
        labelAlign = "center",
        fontSize  = gv.businessFont,
        labelColor = { default={ gv.buttonR, gv.buttonG, gv.buttonB }, over={ gv.buttonOver1,  gv.buttonOver2,  gv.buttonOver3,  gv.buttonOver4 } },
        onEvent   =   function(event) showSpecifics(event, x + 0) end
    }


    if gv.advertisements[x]:getBought() then
      path = "Images/static_screen/st_purchased.png"
    else
      path = "Images/static_screen/st_money.png"
    end

    boughtButton[x] = widget.newButton
      {
        width     = scrollView.width*0.15,
        height    = scrollView.height*0.15,
        left      = entry[x].width + scrollView.width*0.06,
        top       = entry[x].y - scrollView.height*0.15/2,
        defaultFile = path,
        onEvent   = function(event) buy(event, (x + 0)) end
    }

    entry[x]:setLabel(gv.advertisements[x]:getName())
    entryData[x] = display.newText(gv.advertisements[x]:getEffect(), startingX*3,
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
      scrollHeight = BG.height*3,
      topPadding = padding,
      bottomPadding = padding,
      rightPadding = padding,
      leftPadding = padding,
  }

  expandShift = scrollView.height*0.7

  local btnBack = widget.newButton
    {
      left = (scrollView.x - scrollView.width/2) - BG.width*0.25,
      top = scrollView.y - scrollView.height/2,
      id = "back",
      label = "Back",
      defaultFile   = "Images/global_images/button1.png",
      width = BG.width*0.23,
      height = BG.height*0.2,
      labelColor = { default={ gv.buttonR, gv.buttonG, gv.buttonB }, over={ gv.buttonOver1,  gv.buttonOver2,  gv.buttonOver3,  gv.buttonOver4 } },      
      onEvent = back,
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