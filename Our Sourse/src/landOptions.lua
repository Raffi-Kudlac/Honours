local composer = require( "composer" )
local widget    = require( "widget" )
local gv              = require( "global" )

local scene = composer.newScene()
local circleWidth = 30
local circleHeight = 30
local buildOptionsTop = 0
local buildOptionsLeft = 0
local d = 280
local prosWidth = d*0.7
local prosHeight = 0

local costText = ""
local productionText = ""
local prosText = ""
local consText = ""
local consumptionText = ""
local font = native.systemFont
local fontSize = 8
local currentEnergySourse = powerPlant
-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

-- -------------------------------------------------------------------------------
local function createText(ffSpecs)
    
    currentEnergySourse = ffSpecs
    
    costText = display.newText("Costs: $"..ffSpecs:getCost(), buildOptionsLeft + 35,
    buildOptionsTop + 20, font, fontSize )
    costText.anchorX,costText.anchorY = 0,0
    
    productionText = display.newText("Produses: "..ffSpecs:getProduces().."GW",costText.x,costText.y+20,font,fontSize)
    productionText.anchorX,productionText.anchorY = 0,0
    
    consumptionText = display.newText("Consumes: "..ffSpecs:getConsumption(),costText.x,productionText.y+20,font,fontSize)
    consumptionText.anchorX,consumptionText.anchorY = 0,0
    
    prosText = display.newText(ffSpecs:getPros(), costText.x,consumptionText.y +30,prosWidth,prosHeight, font,fontSize)
    prosText.anchorX, prosText.anchorY = 0,0    
    prosText.height = prosText.height + 15    
    
    consText = display.newText(ffSpecs:getCons(), costText.x,prosText.y + prosText.height, prosWidth,prosHeight, font,fontSize)
    consText.anchorX, consText.anchorY = 0,0

end

local function setText(ffSpecs)

    costText.text = "Costs: $"..ffSpecs:getCost()
    productionText.text = "Produces: "..ffSpecs:getProduces().."GW"
    consumptionText.text = "Consumes: "..ffSpecs:getConsumption()
    prosText.text = ffSpecs:getPros()
    consText.text = ffSpecs:getCons()

end


local function purchasedConfirmed()

end

local function buy( event )

    if(currentEnergySourse:getCost()<=gv.money) then
      purchasedConfirmed()
      composer.hideOverlay()    
    end

end

local function cancel( event )

    composer.hideOverlay()
end 


-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view

    buildOptionsTop = centerY(d)
    buildOptionsLeft = centerX(d) + 20
    local widthShift = 10
    local heightShift = 20
    
    local buildOptions = widget.newButton
    {        
        width       = d -20,
        height      = d -10,        
        --shape = "rect",
        defaultFile = "Images/lnd_buildOverlay.png",              
        id          = "BO",              
        left        = centerX(d),
        top         = centerY(d),
        --fillColor = { default={ 0.6, 0, 0, 1 }, over={ 1, 0.2, 0.5, 1 } },
        --label = "Build this"                
    }
    
    
  
    local btnoil = widget.newButton
    {           
        width       = circleWidth,
        height      = circleHeight, 
        id          = "btnoil",
        defaultFile = "Images/st_ff.png",
        onEvent     = function() return setText(gv.oilSpecs) end,
        top         = buildOptionsTop + heightShift,
        left        = buildOptionsLeft - widthShift
    }
    
    heightShift = heightShift + 40
    
    local btngas = widget.newButton
   {
      width       = circleWidth,
      height      = circleHeight,
      defaultFile = "Images/st_land.png",
      id          = "btngas",           
      onEvent     = function() return setText(gv.gasSpecs) end, 
      top         = buildOptionsTop + heightShift,
      left        = buildOptionsLeft - widthShift
   }
   
   heightShift = heightShift + 40
   
   local btncoal = widget.newButton
   {
      width       = circleWidth,
      height      = circleHeight,
      defaultFile = "Images/st_plant.png",
      id          = "btncoal",
      onEvent     = function() return setText(gv.coalSpecs) end,
      top         = buildOptionsTop + heightShift,
      left        = buildOptionsLeft - widthShift
   }
   heightShift = heightShift + 40
   
   local btnNP = widget.newButton
   {      
      width       = circleWidth,
      height      = circleHeight,      
      id          = "btnNP",
      defaultFile = "Images/st_city.png",
      onEvent     = function() return setText(gv.nuclearSpecs) end,
      top         = buildOptionsTop + heightShift,
      left        = buildOptionsLeft - widthShift
   }
  
  local btnBuy = widget.newButton
  { 
      width = 50,
      height = 20,
      shape = "roundedRect",
      cornerRadius = 10,     
      label       = "Buy",      
      id          = "btnBuy",            
      top         =  buildOptions.height - 20,
      left        = buildOptionsLeft+40,
      onEvent = buy     
  }
  
  btnBuy.anchorY = 0
  
  local btnCancel = widget.newButton
  {
      width = 60,
      height = 20,
      shape = "roundedRect",
      cornerRadius = 10,
      label = "Cancel",
      id = "btnCancel",
      top = btnBuy.y,
      left = btnBuy.x + 70,
      onEvent = cancel  
          
  
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