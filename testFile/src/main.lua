
local path = system.pathForFile( "localHighScores.txt", system.DocumentsDirectory)
local widget    = require( "widget" )

local name = ""
local winningYear = 16
local winningMonth = 3
local winningBlackoutCounter = 5
local currentTotalMonths = winningYear*12 + winningMonth
local sceneGroup = display.newGroup()
local nameField = 0
local submit = 0
local position = 0 

local heighScoreData = {}

heighScoreData[1] = {"Harry", 3, 4, 10}
heighScoreData[2] = {"Ben", 13, 14, 11}
heighScoreData[3] = {"Kim", 33, 34, 12}
heighScoreData[4] = {"PLayer 1", 43, 44, 13}
heighScoreData[5] = {"Tim", 53, 54, 14}


local function textListener( event )
    
    if (event.phase == "ended" or event.phase == "submitted") then
        name = event.target.text
        
        if (name == nil ) then
            name = "Player 1"
        end        
          
    end
end


local function close( event )

    if(event.phase == "ended") then
                
        local winningData = {name,winningYear, winningMonth, winningBlackoutCounter}
        table.insert(heighScoreData, position, winningData)
        
                                 
        -- trims the high scores so only 5 exist
        if (#heighScoreData == 6) then
            table.remove(heighScoreData, 6)
        end
        
        write()
        --createFile()
        
        for j = 1,5,1 do
            local joke = false
            
            for k = 1, 4,1 do
                if(heighScoreData[j][k] == nil ) then
                    joke = true
                end
            end
            
            if( joke == false ) then
                print(heighScoreData[j][1] .."\t\t" .. heighScoreData[j][2] .. "\t\t" .. 
                heighScoreData[j][3] .. "\t\t" .. heighScoreData[j][4] )
            end
        end
         sceneGroup:remove(submit)
    end
                 
end

local function getNameFromUser()

    nameField = native.newTextField( 200,200, 100, 50 )
    nameField:addEventListener( "userInput", textListener )
    
    
    submit = widget.newButton
        {        
            width     = 100,
            height    = 100,
            shape     = "roundedRect",
            fillColor = { default={ 1, 0.2, 0.5, 0.7 }, over={ 1, 0.2, 0.5, 1 } },                    
            left      = 100,
            top       = 100,
            labelAlign = "center",
            label     = "Submit",    
            onEvent   =   close,    
        }
    
    sceneGroup:insert(nameField)
    sceneGroup:insert(submit)
end


local function createFile()

    local file = io.open(path , "w+")
    io.close(file)
    file = nil
end

function write()

  local file = io.open(path , "w+")
    for x=1,5, 1 do
        for y=1,4,1 do
            file:write(heighScoreData[x][y] .. "\n")
        end
    end 
    
    io.close(file)
    file = nil
       
end

local function main()
    
    path = system.pathForFile( "localHighScores.txt", system.DocumentsDirectory)
    
    for x =1,5,1 do
        heighScoreData[x] = {-1,-1,-1,-1}
    end
    
    if ( path ~= nil) then
        file = io.open(path , "r")
        
        if (file == nil ) then
            createFile()
            file = io.open(path , "r")
        end
            
        local x = 1
        local y=1
        for line in file:lines() do
          heighScoreData[x][y] = line
          
          if (y ~= 1) then
              heighScoreData[x][y] = tonumber(heighScoreData[x][y])
          end
          
          y = y +1
          
          if(y==5) then
            y = 1
            x = x+1
          end
        end
        
        io.close(file)
        
        for x = 1, 5, 1 do
        
            tempMonths = heighScoreData[x][2]*12 + heighScoreData[x][3]
            
            --print("The temp months is " .. tempMonths)
            
            if (tempMonths < currentTotalMonths ) then
                
                -- winner place above
                position = x                
                getNameFromUser()
                break                                
            elseif ( tempMonths > currentTotalMonths ) then
                
                -- not a high score. do nothing                
            elseif (tempMonths == currentTotalMonths and winningBlackoutCounter <= heighScoreData[x][4]) then                
                
                position = x                
                getNameFromUser()
                break       
                
            elseif (tempMonths == currentTotalMonths and winningBlackoutCounter > heighScoreData[x][4]
             and x ~= 5 and winningBlackoutCounter <= heighScoreData[x+1][4]) then                

                position = x                
                getNameFromUser()
                break                       

            end                
        end
        
        -- trims the high scores so only 5 exist
        if (#heighScoreData == 6) then
            table.remove(heighScoreData, 6)
        end
        
        write()
        --createFile()
        
        for j = 1,5,1 do
            local joke = false
            
            for k = 1, 4,1 do
                if(heighScoreData[j][k] == nil ) then
                    joke = true
                end
            end
            
            if( joke == false ) then
                print(heighScoreData[j][1] .."\t\t" .. heighScoreData[j][2] .. "\t\t" .. 
                heighScoreData[j][3] .. "\t\t" .. heighScoreData[j][4] )
            end
        end
        
        --createText(sceneGroup)
    end
    
    
    
    
    
    
    
    
    
--    if (tempMonths < currentTotalMonths ) then
--                
--                -- winner place above
--                local name = getNameFromUser()
--                print("marker 1")
--                local winningData = {name,winningYear, winningMonth, winningBlackoutCounter}
--                table.insert(heighScoreData, x, winningData)
--                break                                
--            elseif ( tempMonths > currentTotalMonths ) then
--                
--                -- not a high score. do nothing                
--            elseif (tempMonths == currentTotalMonths and winningBlackoutCounter <= heighScoreData[x][4]) then
--                
--                -- place above
--                print(" marker 2")
--                local name = getNameFromUser()
--                winningData = {name,winningYear, winningMonth, winningBlackoutCounter}
--                table.insert(heighScoreData, x, winningData)   
--                break           
--            elseif (tempMonths == currentTotalMonths and winningBlackoutCounter > heighScoreData[x][4]
--             and x ~= 5 and winningBlackoutCounter <= heighScoreData[x+1][4]) then                
--                -- place below
--                local name  = getNameFromUser()                
--                winningData = {name,winningYear, winningMonth, winningBlackoutCounter}
--                table.insert(heighScoreData, x+1, winningData)
--                break              
--            end                
--        end
--        
--        -- trims the high scores so only 5 exist
--        if (#heighScoreData == 6) then
--            table.remove(heighScoreData, 6)
--        end
--        
--        write()
--        --createFile()
--        
--        for j = 1,5,1 do
--            local joke = false
--            
--            for k = 1, 4,1 do
--                if(heighScoreData[j][k] == nil ) then
--                    joke = true
--                end
--            end
--            
--            if( joke == false ) then
--                print(heighScoreData[j][1] .."\t\t" .. heighScoreData[j][2] .. "\t\t" .. 
--                heighScoreData[j][3] .. "\t\t" .. heighScoreData[j][4] )
--            end
--        end
        
        --createText(sceneGroup)
    
    
    
--    print("The path is: ".. path)
--    if (path ~= nil) then
--
--        local write = false        
--        local file = nil
--        if write then
--            file = io.open(path , "w+")
--        else
--            file = io.open(path , "r")
--        end
--        
--        if file then
--            
--            if write then
--                --file:write("Hello Smith ", "1 year and 5 months ", 123)
--                
--                for x=1,5, 1 do
--                    for y=1,4,1 do
--                        file:write(array[x][y] .."\n")
--                    end
--                end                  
--                print("data has been writen")    
--            else
--                print("we read the file and got")
--                for line in file:lines() do
--                    print( line )
--                end
--            end
--            io.close()
--            file = nil
--        else
--            print("The connection to the file was not made")
--        end
--    
--    else
--        print("The path was nil")
--    end 




end
main()
