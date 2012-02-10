module(...,package.seeall)
-----------------
require "sqlite3"
-----------------
local DB_FILENAME = "Brocos.sqlite"
local PLAYER_SCRIPT = "CREATE TABLE IF NOT EXISTS [Player] ([highscore] INTEGER NOT NULL ON CONFLICT ROLLBACK);"
local PLAYER_SCRIPT_INSERT = "INSERT INTO [Player] values(0)"
-----------------

function new()
	local db = {}	
	
	db.getDbFile = function()
		return system.pathForFile(DB_FILENAME,
			system.DocumentsDirectory)
	end
	
	db.openOrCreateDb = function()
		db.sqliteBase = sqlite3.open(db.getDbFile())
		print("Is base created?",db.sqliteBase)
				
		db.system = function( event )
			if event.type == "applicationExit"
				and db.sqliteBase:isopen() then              
					print("CLOSE DB")					
					db.sqliteBase:close()
			end
		end	
	
		Runtime:addEventListener( "system", db.system )
	end
	
	db.setupBasicData = function(table_name,script)
		local count = 0 
		for row in db.sqliteBase:nrows("SELECT count(*) AS '# of "..table_name.."' FROM ["..table_name.."]") do
			count = row["# of "..table_name..""]
			print("Count",table_name,count)
		end
		if count <= 0 then
			local error = db.sqliteBase:exec(script)
			print("DB error:",table_name,error);
		end
	end
	
	db.setupBase = function()			                
        if not db.sqliteBase:isopen() then 
            print ("dbcontroller:setupbase()","DB isnt open")
            return 
        end        
		function showrow(udata,cols,values,names)
			 print('exec:')
			 for i=1,cols do print('',names[i],values[i]) end
			 return 0
		end
		local error = db.sqliteBase:exec(PLAYER_SCRIPT,
			showrow,'base_setup')
		print("any errors?",error)
	
		db.setupBasicData("Player",PLAYER_SCRIPT_INSERT)
	end
	
	db.getGameHighScore= function()
        for totalScore in db.sqliteBase:urows("SELECT highscore FROM [Player] LIMIT 1") do
            return totalScore
        end
        return 0 
	end

	db.saveGameHighScore = function(highscore)
        db.sqliteBase:exec("UPDATE [Player] SET highscore = "..highscore.." WHERE highscore < "..highscore)
	end
	
	db.openOrCreateDb()
	db.setupBase()	
	db.setupBasicData("Player",PLAYER_SCRIPT_INSERT)
	
	return db
end