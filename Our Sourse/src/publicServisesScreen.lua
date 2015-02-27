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
    gv.publicServises[index]:flipBought()

    if gv.publicServises[index]:getBought() then
      changeBoughtImage(index,"Images/static_screen/st_purchased.png")
    else
      changeBoughtImage(index,"Images/static_screen/st_money.png")
    end
    
    setText()
  elseif (event.phase == "moved") then
       local dy = math.abs( ( event.y - event.yStart ) )
               
        if ( dy > 10 ) then
            scrollView:takeFocus( event )
        end      
  end
  
end


function changeBoughtImage( index, image )

  local temp = boughtButton[index]  
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
      for  x = index + 1, gv.servisCounter -1,1 do

        entry[x].y = yMarker + (x - index - 1)*shift
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
      for x = pressedGroup +1, gv.servisCounter -1, 1 do

        entry[x].y = entry[x-1].y + shift
        boughtButton[x].y = boughtButton[x-1].y + shift
      end

      entryData[pressedGroup].isVisible = false
      expanded = false
      
--      scrollView:scrollToPosition
--      {          
--          y = 0,
--          time = 0,          
--      }
      
    end
  elseif (event.phase == "moved") then
       local dy = math.abs( ( event.y - event.yStart ) )
               
        if ( dy > 10 ) then
            scrollView:takeFocus( event )
        end      
  end

end


local function makeEntries()

  local startingX = scrollView.width*0.1
  local startingY = scrollView.height*0.08
  local textX = scrollView.width*0.15

  for x=0, gv.servisCounter - 1, 1 do
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

    if gv.publicServises[x]:getBought() then
      path = "Images/static_screen/st_purchased.png"
    else
      path = "Images/static_screen/st_money.png"
    end

    boughtButton[x] = widget.newButton
      {
        width     = scrollView.width*0.15,
        height    = scrollView.height*0.15,
        left      = entry[x].width + scrollView.width*0.1,
        top       = entry[x].y - scrollView.height*0.15/2,
        defaultFile = path,
        onEvent   =   function(event) buy(event, x + 0) end
    }
    entry[x]:setLabel(gv.publicServises[x]:getName())
    
    
    
    entryData[x] = display.newText(gv.publicServises[x]:getAbout(), textX, entry[x].y + entry[x].height/2,
      scrollView.width*0.75, 0, gv.font, gv.fontSize )
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
  local widthValue = widthCalculator(0.5)
  local heightValue = heightCalculator(0.8)
  local padding = 5


  local BG = widget.newButton
    {
      width       = widthValue,
      height      = heightValue,
      defaultFile = "Images/global_images/Vertical_Box.png",
      id          = "BO",
      left        = centerX(widthValue*0.9),
      top         = centerY(heightValue),
  }

  sceneGroup:insert(BG)

  scrollView = widget.newScrollView
    {
      top = centerY(heightValue),
      left = centerX(widthValue),
      width = widthValue,
      height = heightValue*0.95,
      scrollHeight = heightValue*12,
      hideBackground = true,
      horizontalScrollDisabled = true,
      topPadding = padding,
      bottomPadding = padding,
      rightPadding = padding,
      leftPadding = padding,
  }

  expandShift = scrollView.height*0.8
  makeEntries()


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
      onEvent = back
  }
  sceneGroup:insert(btnBack)
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