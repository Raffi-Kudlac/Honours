local function main()

    local path = system.pathForFile( "localHighScores.txt", system.DocumentsDirectory)
    
    local array = {}
    
    array[1] = {"Harry", 3, 4, 10}
    array[2] = {"Ben", 13, 14, 11}
    array[3] = {"Kim", 33, 34, 12}
    array[4] = {"PLayer 1", 43, 44, 13}
    array[5] = {"Tim", 53, 54, 14}
    
    defaultField = native.newTextField( 150, 150, 180, 30 )
    
    print("The path is: ".. path)
    if (path ~= nil) then

        local write = false        
        local file = nil
        if write then
            file = io.open(path , "w+")
        else
            file = io.open(path , "r")
        end
        
        if file then
            
            if write then
                --file:write("Hello Smith ", "1 year and 5 months ", 123)
                
                for x=1,5, 1 do
                    for y=1,4,1 do
                        file:write(array[x][y] .."\n")
                    end
                end                  
                print("data has been writen")    
            else
                print("we read the file and got")
                for line in file:lines() do
                    print( line )
                end
            end
            io.close()
            file = nil
        else
            print("The connection to the file was not made")
        end
    
    else
        print("The path was nil")
    end 




end
main()
