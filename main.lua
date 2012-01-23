display.setStatusBar( display.HiddenStatusBar ) 
--------------
local mainmenu = require "main_menu"
local Game = require "game"
local GameOver = require "gameover"
fonts = {neuropol = "Neuropol" }
--------------------
--Vars
local menu
local game
local score
--Global 
--------------------

function start()
	--local main_menu = MainMenu.new()
	--main_menu:show()
	showMenu()	
	Runtime:addEventListener("enterFrame",onEnterFrame)
end

function showMenu()
	menu = mainmenu.new()	
	menu:show()
	menu:onBtnStartTouched(function()
		local function listener(event)
			--showLoading("game")
			if not onGame then
				showGame(menu)			
			end
		end
		timer.performWithDelay(1000,listener)
	end)
end

function showLoading(screen)
	if screen == "game" then
		
	end
end

function showGame(sender)	
	onGame = true
	showGameOver = false	
	game = Game.new()
	game:load()
	game.x = display.contentWidth
	--TODO: remover ao inserir o loading 
	transition.to(game, {time = 500, x = 0,transition=easing.inQuad, onComplete = function() sender:unload() end})
end

function onEnterFrame (event)
	if game then score = game.score end
	if game and game.isOver and not showGameOver then
		showGameOver = true		
		onGame = false
		gameover = GameOver.new()
		gameover:show(score)
		gameover.x = display.contentWidth
		transition.to(gameover, {time = 500, x = 0,transition=easing.inQuad, onComplete = function() game:onGameOver() end})								
	end
end

function onRetry(sender)
	showGame(sender)
end

function onGoToMenu(sender)
	showMenu()
	if sender.unload then sender:unload() end	
end

start()