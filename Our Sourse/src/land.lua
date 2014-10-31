--[[
    Purpose:    
        This screen is responcible for loading the land Screen and setting up components.
        On this screen the user can build fossil fueled power plants and nuclear power.
        He/She can also buy more land if more is needed. 
]]

local composer = require( "composer" )
local widget   = require( "widget" )
local gv       = require( "global" )
local landTile = require( "landTile" )
require "landOptions"

local scene       = composer.newScene()
local grid        = display
local tiles       = {}
local sceneGroup  = 0
-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

-- -------------------------------------------------------------------------------


local function loadOptions(counter, event)
   
    local options = {
        isModal = true
    }
    
    gv.marker = counter
    gv.tileClicked = tiles[counter]
    
    if ( "began" == event.phase ) then
    
        if (tiles[counter].tile:getType() == "open") then
          composer.showOverlay("landOptions", options)
        elseif (tiles[counter].tile:getType() == "city owned") then
            composer.showOverlay("cityOptions",options)
        elseif (tiles[counter].tile:getType()=="forest") then
            composer.showOverlay("forestOptions",options)
        elseif(tiles[counter].tile:getType()=="owned") then
             composer.showOverlay("ownedOptions",options)
        end
                                                  
    end    
end


local function setDataLabels()
    
    local openOwnedSpace  = -1
    local percentUsed     = 0
    local areaUsed        = 0
    
    for i = 0,14,1 do        
        if(tiles[i].tile:getType()=="owned")then
            areaUsed = areaUsed + 1
             openOwnedSpace = openOwnedSpace + 1            
        elseif(tiles[i].tile:getType()=="open")then
            openOwnedSpace = openOwnedSpace + 1            
        end    
    end
        
    percentUsed = math.round((areaUsed/14)*100)    
    setDataBox("Area Owned", openOwnedSpace, 1)
    setDataBox("Built on", areaUsed, 2)
    setDataBox(percentUsed.."% ","land used", 3)    
end


--Builds the tiles. All tiles start open but are changed later
local function buildTiles()

    local startX  = 15
    local startY  = -30
    local tileX   = startX
    local tileY   = startY
    local shiftX  = 155
    local shiftY  = 51
    local counter = 0

    for y = 0, 4, 1 do
        
        if (y % 2 == 0) then
            tileX = startX
        else
            tileX = 95
        end
          
        for x = 0, 2, 1 do
        
            tiles[counter] = widget.newButton
            {                                
                width       = 120,
                height      = 120,
                defaultFile = "Images/land_screen/lnd_tile_plain.png",              
                id          = "openLand",              
                left        = 0,
                top         = 0,
                onEvent = function(event) return loadOptions(3*y + x,event) end,                              
            }
            
            tiles[counter].anchorX  = 0
            tiles[counter].anchorY  = 0            
            tiles[counter].x        = tileX
            tiles[counter].y        = tileY                            
            tiles[counter].tile     = landTile.new("open")                                    
            sceneGroup:insert(tiles[counter])  
            counter                 = counter +1
            tileX = tileX + shiftX                      
        end        
        tileY = tileY + shiftY   
    end
    
    --This the extra tile that is cut off. Had to be disabled
    tiles[12]:setEnabled(false)
    tiles[12].isVisible = false


end 

function convertButton2(path,location,sc,type)

    local temp = tiles[location]
    sc:remove(tiles[location])
    
    
    local mask = graphics.newMask( "Images/land_screen/lnd_tile_forest_mask.png" )
    tiles[location] = display.newImageRect(path,0,0)
    
    tiles[location].anchorX = 0
    tiles[location].anchorY = 0
    tiles[location].width = 120
    tiles[location].height = 120
    tiles[location].x = temp.x
    tiles[location].y = temp.y
    tiles[location].tile = landTile.new(type)
    --tiles[location]:addEventListener( "tap", function(event) return loadOptions(location,event) end)
               
    
            
    tiles[location]:setMask( mask )    
--    tiles[location].maskX = tiles[location].x
--    tiles[location].maskY = tiles[location].y
--    tiles[location].maskScaleY = 0.234
--    tiles[location].maskScaleX = 0.234
        
    sc:insert(tiles[location])    
    
   

end


function convertButton(path,location,type)
           
    local temp = tiles[location]
    local mask = graphics.newMask( "Images/land_screen/lnd_tile_forest_mask.png" )
    sceneGroup:remove(tiles[location])
    
    tiles[location] = widget.newButton
    {
        --sheet = buttonSheet,  
        width       = 120,
        height      = 120,
        defaultFile = path,              
        id          = "openLand",              
        left        = 0,
        top         = 0,
        onEvent = function(event) return loadOptions(location,event) end,
    }
    
    tiles[location].anchorX = 0
    tiles[location].anchorY = 0    
    tiles[location].x       = temp.x
    tiles[location].y       = temp.y    
    tiles[location].tile    = landTile.new(type)
                    
    tiles[location]:setMask( mask )
    sceneGroup:insert(location+2,tiles[location])
    setDataLabels()           
end


local function buildStartingTiles()

     local type = "city owned"
    
     convertButton("Images/land_screen/lnd_tile_forest.png",0, type)
     convertButton("Images/land_screen/lnd_tile_forest.png",1, type)
     convertButton("Images/land_screen/lnd_tile_forest.png",3, type)
     convertButton("Images/land_screen/lnd_tile_forest.png",6, type)
     convertButton("Images/land_screen/lnd_tile_forest.png",7, type)
     convertButton("Images/land_screen/lnd_tile_forest.png",9, type)
     
     type = "forest"
     
     convertButton("Images/land_screen/lnd_tile_forest.png",10, type)
     convertButton("Images/land_screen/lnd_tile_forest.png",11, type)
     convertButton("Images/land_screen/lnd_tile_forest.png",13, type)
     convertButton("Images/land_screen/lnd_tile_forest.png",14, type) 
end


-- "scene:create()"
function scene:create( event )

    sceneGroup = self.view    
    
    grid          = display.newImage("Images/land_screen/lnd_grid.png")
    grid:scale(0.6,0.6)
    grid.x        = 0
    grid.y        = 0
    grid.anchorX  = 0
    grid.anchorY  = 0
    
           
    sceneGroup:insert(grid)
    buildTiles()
    buildStartingTiles()
    setDataLabels()    
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