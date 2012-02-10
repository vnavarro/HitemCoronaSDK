display.setStatusBar(display.HiddenStatusBar)
-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
local menuControl = require "menu"
local gameScreen = require "game"
-----------
function start()
	local menuPrincipal = menuControl.new()
	local game = gameScreen.new()	
	menuPrincipal.onStartTouch = function(sender)
		game:show()				
		game.y = display.contentHeight		
		game.alpha = 0
		transition.to(game,{time=1500,
			transition=easing.inOutQuad,y=0,alpha=1,
			onComplete=function() sender:removeSelf() end})		
	end
end
start()