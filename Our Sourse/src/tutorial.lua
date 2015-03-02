--[[
Purpose:
This screen is the menu screen currently only holding the play button.

]]

local composer  = require( "composer" )
local gv        = require( "global" )
local widget    = require( "widget" )
local scene     = composer.newScene()
local btnNext
local btnPrev
local btnDone
local currentImage
local pointer = 1
local sceneGroup

local tutorialImages = {}

tutorialImages[1] = "Images/tutorial/tutorial_1.png"
tutorialImages[2] = "Images/tutorial/tutorial_2.png"
tutorialImages[3] = "Images/tutorial/tutorial_3.png"
tutorialImages[4] = "Images/tutorial/tutorial_4.png"
tutorialImages[5] = "Images/tutorial/tutorial_5.png"
tutorialImages[6] = "Images/tutorial/tutorial_6.png"
tutorialImages[7] = "Images/tutorial/tutorial_7.png"
tutorialImages[8] = "Images/tutorial/tutorial_8.png"
tutorialImages[9] = "Images/tutorial/tutorial_9.png"
tutorialImages[10] = "Images/tutorial/tutorial_10.png"
tutorialImages[11] = "Images/tutorial/tutorial_11.png"

-------------------------------------------------
-- PRIVATE FUNCTIONS
-------------------------------------------------

local function removeCurrentImage()

    sceneGroup:remove(currentImage)    
    currentImage = nil
end


local function showCurrentImage()

  currentImage = display.newImage(tutorialImages[pointer])
  currentImage.anchorX, currentImage.anchorY = 0,0
  currentImage.height = display.contentHeight
  currentImage.width = display.contentWidth
  currentImage.x = 0
  currentImage.y = 0
  
  sceneGroup:insert(currentImage)
end


local function next( event ) 

    if ( event.phase == "ended" ) then
        
        if ( pointer ~= #tutorialImages ) then
            removeCurrentImage()
            pointer = pointer + 1
            showCurrentImage()
            btnPrev.isVisible = true
            if ( pointer == #tutorialImages ) then
              btnNext.isVisible = false
            end        
        end
    end
end


local function prev( event ) 

    if ( event.phase == "ended" ) then
        
        if ( pointer ~= 1 ) then
          removeCurrentImage()
          pointer = pointer - 1
          showCurrentImage()
          btnNext.isVisible = true          
          if (pointer == 1) then
              btnPrev.isVisible = false
          end            
        end
    end
end


local function done( event ) 

    if ( event.phase == "ended" ) then
        gv.stage:remove(btnNext)
        gv.stage:remove(btnPrev)
        gv.stage:remove(btnDone)
        composer.gotoScene("menu")    
    end
end

-------------------------------------------------
-- COMPOSER FUNCTIONS
-------------------------------------------------

-- "scene:create()"
function scene:create( event )
  
  local btnWidth = display.contentWidth*0.15
  local btnHeight = display.contentHeight*0.15
  local midBtnXPosition = display.contentWidth - btnWidth*1.2
  local midBtnYPosition = centerY(btnHeight)
  sceneGroup = self.view
  
  gv.stage  = display.getCurrentStage()
  
  btnNext = widget.newButton
  {
      width         = btnWidth,
      height        = btnHeight,
      defaultFile   = "Images/global_images/button1.png",
      label         = "Next",
      id            = "btnBuy",
      top           = midBtnYPosition + btnHeight*1.1,
      left          = midBtnXPosition,
      onEvent       = next,
  }
  
  
  btnPrev = widget.newButton
  {
      width         = btnWidth,
      height        = btnHeight,
      defaultFile   = "Images/global_images/button1.png",
      label         = "Previous",
      id            = "btnBuy",
      top           = midBtnYPosition,
      left          = midBtnXPosition,
      onEvent       = prev,
  }
  btnPrev.isVisible = false
  
  btnDone = widget.newButton
  {
      width         = btnWidth,
      height        = btnHeight,
      defaultFile   = "Images/global_images/button1.png",
      label         = "Done",
      id            = "btnBuy",
      top           = midBtnYPosition - btnHeight*1.1,
      left          = midBtnXPosition,
      onEvent       = done,
  }
  pointer = 1
  showCurrentImage()
  
  gv.stage:insert(btnNext)
  gv.stage:insert(btnPrev)
  gv.stage:insert(btnDone)
  
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