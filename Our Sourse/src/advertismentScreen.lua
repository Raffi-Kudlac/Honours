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
local expandShift = 80
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
        if (index == 0 and gv.advertisement[0]:getBought() ) then
            alterDemand(true)
        elseif (index == 0 and gv.advertisement[0]:getBought() == false ) then
            alterDemand(false)
        end
        
        -- safe nuclear power advertisement. effects the nuclear group.
        if (index == 1 and gv.advertisement[1]:getBought() ) then
            gv.groups[1]:setStatus(5)
        elseif (index == 1 and gv.advertisement[1]:getBought() == false ) then
            gv.groups[1]:setStatus(-5)
        end
        
        -- pro windmill advertisement. effects the anti windmill group. 
        if (index == 2 and gv.advertisement[2]:getBought() ) then
            gv.groups[3]:setStatus(5)
        elseif (index == 1 and gv.advertisement[2]:getBought() == false ) then
            gv.groups[3]:setStatus(-5)
        end
        
        
        -- pro hydro advertisement. effects envirmentalists group. 
        if (index == 3 and gv.advertisement[3]:getBought() ) then
            gv.groups[0]:setStatus(5)
        elseif (index == 3 and gv.advertisement[3]:getBought() == false and gv.hydroCounter > 0 ) then
            gv.groups[0]:setStatus(-5)
        end
        
        
        -- Fossil Power advertisement. effects the envirementalists group.
        if (index == 4 and gv.advertisement[4]:getBought() ) then
            gv.groups[0]:setStatus(5)
        elseif (index == 4 and gv.advertisement[4]:getBought() == false ) then
            gv.groups[0]:setStatus(-5)
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
      
        if expanded == false then
            for  x = index + 1, gv.addCounter -1,1 do 
               
               entry[x].y = yMarker + (x - index - 1 )*55
               boughtButton[x].y = yMarker + (x - index - 1 )*55
            end
            pressedGroup = index
            entryData[index].isVisible = true
            expanded = true
        else
             for x = pressedGroup +1, gv.addCounter -1, 1 do
             
                entry[x].y = entry[x-1].y + 55 
                boughtButton[x].y = boughtButton[x-1].y +55
             end
             
             entryData[pressedGroup].isVisible = false
             expanded = false
        end
    end
    

end


local function makeEntries()
    
    local startingX = 5
    local startingY = 0

    for x=0, gv.addCounter - 1, 1 do
        entry[x] = widget.newButton
        {        
            width     = scrollWidth*0.7,
            height    = 50,
            shape     = "roundedRect",
            fillColor = { default={ 1, 0.2, 0.5, 0.7 }, over={ 1, 0.2, 0.5, 1 } },                    
            left      = startingX,
            top       = x*55,
            labelAlign = "center",    
            onEvent   =   function(event) showSpecifics(event, x + 0) end    
        }
        
        
        boughtButton[x] = widget.newButton
        {        
            width     = scrollWidth*0.2,
            height    = 40,            
            left      = entry[x].x*2 + scrollWidth*0.05,
            top       = x*55 + 5,
            defaultFile = "Images/static_screen/st_money.png",                
            onEvent   =   function(event) buy(event, x + 0) end    
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

        entryData[x] = display.newText(gv.advertisements[x]:getEffect(), startingX, scrollWidth*0.9, 60,
        (x+1)*55, gv.font, gv.fontSize )
        entryData[x].anchorX,entryData[x].anchorY = 0,0
                                                                        
        scrollView:insert(entry[x])
        scrollView:insert(boughtButton[x])
        scrollView:insert(entryData[x])
    
    end



end



-------------------------------------------------
-- COMPOSER FUNCTIONS
-------------------------------------------------

-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view
    
    scrollView = widget.newScrollView
    {
        top = centerY(scrollHeight),
        left = centerX(scrollWidth),
        width = scrollWidth,
        height = scrollHeight,
        scrollWidth = scrollWidth*2,
        scrollHeight = scrollHeight*2,    
    }
    
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