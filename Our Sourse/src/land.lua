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

local scene = composer.newScene()
local openLand = widget

local tiles = {}
-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

-- -------------------------------------------------------------------------------


local function loadOptions(counter, event)
    
    local options = {
        isModal = true
    }

    if ( "began" == event.phase ) then
      if (tiles[counter].tile:getType() == "open") then
          composer.showOverlay("landOptions",options)
      elseif (tiles[counter].tile:getType() == "city owned") then
          composer.showOverlay("cityOptions",options)
      elseif (tiles[counter].tile:getType()=="forest") then
          composer.showOverlay("forestOptions",options)
      end
                                          
    end    

end


local function buildTiles(sc)

    local startX = 15
    local startY = -30
    local tileX = startX
    local tileY = startY
    local shiftX = 155
    local shiftY = 51
    
    
--    local options =
--{
--    --required parameters
--    width = 120,
--    height = 120,
--    numFrames = 1,   
--    
--    sheetContentWidth = 512,  -- width of original 1x size of entire sheet
--    sheetContentHeight = 512
--}
--    
--    local buttonSheet = graphics.newImageSheet( "Images/land_screen/lnd_tile_nuke.png", options)
    

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
                --sheet = buttonSheet,  
                width = 120,
                height = 120,
                defaultFile = "Images/land_screen/lnd_tile_nuke.png",              
                id          = "openLand",              
                left        = 0,
                top         = 0,
                onEvent = function(event) return loadOptions(3*y + x,event) end,                              
            }
            
            tiles[counter].anchorX = 0
            tiles[counter].anchorY = 0
            
            tiles[counter].x = tileX
            tiles[counter].y = tileY
                            
            tiles[counter].tile = landTile.new("forest")
            
            sc:insert(tiles[counter])  
            counter = counter +1
            tileX = tileX + shiftX  
                    
        end
        
        tileY = tileY + shiftY   
    end
    
    tiles[12]:setEnabled(false)
    tiles[12].isVisible = false


end 


local function buildCityTiles()

   tiles[0].defaultFile = "Images/land_screen/lnd_tile_forest.png"
--   tiles[1]
--   tiles[6]
--   tiles[7]
--   tiles[9]
    

end

-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view
--    print("made it to the land screen")
    local d = 100
    
    local grid = display.newImage("Images/land_screen/lnd_grid.png")
    grid:scale(0.6,0.6)
    grid.x = 0
    grid.y = 0
    grid.anchorX = 0
    grid.anchorY = 0
    
           
    sceneGroup:insert(grid)
    buildTiles(sceneGroup)
    buildCityTiles()    
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