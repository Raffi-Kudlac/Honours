--[[
    Purpose:    
        This screen appears on top of the land screen (layOver screen) and is responcible
        for displaying possible build options to the user. This screen only appears if the user owns
        the land that he/she selected.

]]

local composer = require( "composer" )
local widget   = require( "widget" )
local gv       = require( "global" )

local scene             = composer.newScene()
local circleWidth       = 30
local circleHeight      = 30
local buildOptionsTop   = 0
local buildOptionsLeft  = 0
local d                 = 280
local prosWidth         = d*0.7
local prosHeight        = 0

local costText          = ""
local productionText    = ""
local prosText          = ""
local consText          = ""
local consumptionText   = ""
local currentEnergySourse = powerPlant

-------------------------------------------------
-- PRIVATE FUNCTIONS
-------------------------------------------------

local function createText(ffSpecs)
    
    currentEnergySourse = ffSpecs
    
    costText = display.newText("Costs: $"..ffSpecs:getCost(), buildOptionsLeft + 35,
    buildOptionsTop + 20, gv.font, gv.fontSize )
    costText.anchorX,costText.anchorY = 0,0
    
    productionText = display.newText("Produses: "..ffSpecs:getProduces().."GW",costText.x,costText.y+20,gv.font,gv.fontSize)
    productionText.anchorX,productionText.anchorY = 0,0
    
    consumptionText = display.newText("Consumes: "..ffSpecs:getConsumption(),costText.x,productionText.y+20,gv.font,gv.fontSize)
    consumptionText.anchorX,consumptionText.anchorY = 0,0
    
    prosText = display.newText(ffSpecs:getPros(), costText.x,consumptionText.y +30,prosWidth,prosHeight, gv.font,gv.fontSize)
    prosText.anchorX, prosText.anchorY = 0,0    
    prosText.height = prosText.height + 15    
    
    consText = display.newText(ffSpecs:getCons(), costText.x,prosText.y + prosText.height, prosWidth,prosHeight, gv.font,gv.fontSize)
    consText.anchorX, consText.anchorY = 0,0

end

function setLandCurrentEnergySourse(ffSpecs)
    currentEnergySourse = ffSpecs
end

local function setText(ffSpecs, kind)
        
    currentEnergySourse = ffSpecs
    costText.text = "Costs: $"..ffSpecs:getCost()
    productionText.text = "Produces: "..ffSpecs:getProduces().."GW"
    consumptionText.text = "Consumes: "..ffSpecs:getConsumption()
    prosText.text = ffSpecs:getPros()
    consText.text = ffSpecs:getCons()

end


function landPurchasedConfirmed()

    gv.money    = gv.money - currentEnergySourse:getCost()
    local kind  = "owned"
    
    if(currentEnergySourse:getType() =="oil") then
        convertButton("Images/land_screen/lnd_tile_oil.png",gv.marker, kind, "oil")  
        gv.groups[0]:setStatus(-gv.oilInfluence) 
        gv.oilBuildCounter = gv.oilBuildCounter + 1      
    elseif(currentEnergySourse:getType() =="coal") then    
        convertButton("Images/land_screen/lnd_tile_coal.png",gv.marker, kind, "coal")
        gv.groups[0]:setStatus(-gv.coalInfluence)
        gv.coalBuildCounter = gv.coalBuildCounter + 1
    elseif(currentEnergySourse:getType() =="gas") then
        gv.groups[0]:setStatus(-gv.gasInfluence)
        convertButton("Images/land_screen/lnd_tile_gas.png",gv.marker, kind, "gas")
        gv.gasBuildCounter = gv.gasBuildCounter + 1
    elseif(currentEnergySourse:getType() =="nuclear") then
        gv.groups[1]:setStatus(-gv.nuclearInfluence)
        convertButton("Images/land_screen/lnd_tile_nuke.png",gv.marker, kind, "nuclear")
        gv.nuclearBuildCounter = gv.nuclearBuildCounter + 1
    end
    
    print("The envirementalists level is")
    print(gv.groups[0]:getNumberStatus())
            
end


local function buy( event )

    if (event.phase == "began") then
        if(currentEnergySourse:getCost()<=gv.money) then
          landPurchasedConfirmed()
          setMoney()
          composer.hideOverlay()    
        end
    end

end


local function cancel( event )
	
	if (event.phase == "began") then
    	composer.hideOverlay()
    end
end 


-------------------------------------------------
-- COMPOSER FUNCTIONS
-------------------------------------------------

-- "scene:create()"
function scene:create( event )

    local sceneGroup  = self.view
    buildOptionsTop   = centerY(d)
    buildOptionsLeft  = centerX(d) + 20
    local widthShift  = 10
    local heightShift = 20
    
    local buildOptions = widget.newButton
    {        
        width       = d -20,
        height      = d -10,                
        defaultFile = "Images/land_screen/lnd_buildOverlay.png",              
        id          = "BO",              
        left        = centerX(d),
        top         = centerY(d),        
    }
    
  
    local btnoil = widget.newButton
    {           
        width       = circleWidth,
        height      = circleHeight, 
        id          = "btnoil",
        defaultFile = "Images/land_screen/lnd_oil.png",
        onEvent     = function() return setText(gv.oilSpecs, "oil") end,
        top         = buildOptionsTop + heightShift,
        left        = buildOptionsLeft - widthShift
    }
    
    heightShift  = heightShift + 40
    
   local btngas = widget.newButton
   {
      width       = circleWidth,
      height      = circleHeight,
      defaultFile = "Images/land_screen/lnd_gas.png",
      id          = "btngas",           
      onEvent     = function() return setText(gv.gasSpecs, "gas") end, 
      top         = buildOptionsTop + heightShift,
      left        = buildOptionsLeft - widthShift
   }
   
   heightShift = heightShift + 40
   
   local btncoal = widget.newButton
   {
      width       = circleWidth,
      height      = circleHeight,
      defaultFile = "Images/land_screen/lnd_coal.png",
      id          = "btncoal",
      onEvent     = function() return setText(gv.coalSpecs, "coal") end,
      top         = buildOptionsTop + heightShift,
      left        = buildOptionsLeft - widthShift
   }
   heightShift = heightShift + 40
   
   local btnNP = widget.newButton
   {      
      width       = circleWidth,
      height      = circleHeight,      
      id          = "btnNP",
      defaultFile = "Images/land_screen/lnd_nuclear.png",
      onEvent     = function() return setText(gv.nuclearSpecs, "nuc") end,
      top         = buildOptionsTop + heightShift,
      left        = buildOptionsLeft - widthShift
   }
  
    local btnBuy = widget.newButton
    { 
        width         = 50,
        height        = 20,
        shape         = "roundedRect",
        cornerRadius  = 10,     
        label         = "Buy",      
        id            = "btnBuy",            
        top           =  buildOptions.height - 20,
        left          = buildOptionsLeft+40,
        onEvent       = buy     
    }
    
    btnBuy.anchorY = 0
    
    local btnCancel = widget.newButton
    {
        width         = 60,
        height        = 20,
        shape         = "roundedRect",
        cornerRadius  = 10,
        label         = "Cancel",
        id            = "btnCancel",
        top           = btnBuy.y,
        left          = btnBuy.x + 70,
        onEvent       = cancel           
    }
    createText(gv.oilSpecs)
     
    sceneGroup:insert(buildOptions)
    sceneGroup:insert(btnoil)
    sceneGroup:insert(btngas)
    sceneGroup:insert(btncoal)
    sceneGroup:insert(btnNP)
    sceneGroup:insert(costText)
    sceneGroup:insert(productionText)
    sceneGroup:insert(consumptionText)
    sceneGroup:insert(prosText)
    sceneGroup:insert(consText)
    sceneGroup:insert(btnBuy)
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