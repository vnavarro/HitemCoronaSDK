module(...,package.seeall)
----------------------------
local controls = require "controls"
----------------------------

function new()
	gameover = display.newGroup()
	gameover.show = function(popup,score)
		--gameover.shader = display.newRect( gameover, 0, 0, display.contentWidth, display.contentHeight )	
		--gameover.shader:setFillColor(0, 0, 0, 200)
		
		gameover.background = display.newRect( gameover, 0,0,display.contentWidth, display.contentHeight)
		gameover.background:setFillColor(145,74,34)
		
		gameover.title = display.newText(gameover, "GameOver!", display.contentWidth/2, display.contentHeight/2, fonts.neuropol, 45)
		gameover.title.x = gameover.title.x - gameover.title.width/2
		gameover.title.y = gameover.title.y - gameover.title.height*2
		gameover.title:setTextColor(0,0,0)
		
		gameover.score = display.newText(gameover,score, display.contentWidth/2, display.contentHeight/2, fonts.neuropol, 45)
		gameover.score.x = gameover.score.x - gameover.score.width/2
		gameover.score.y = gameover.score.y - gameover.score.height/2
		gameover.score:setTextColor(0,0,0)
		
		gameover.btnRetry = controls.newButton()
		gameover.btnRetry:show(50,gameover.score.y + 45,45,45)
		gameover.btnRetry:setValue("R")
		gameover.btnRetry.onTouch = function()
		 	onRetry(gameover)
		end
		gameover:insert(gameover.btnRetry)
		
		gameover.btnMenu = controls.newButton()
		gameover.btnMenu:show(225,gameover.score.y + 45,45,45)
		gameover.btnMenu:setValue("M")
		gameover.btnMenu.onTouch = function() 
			onGoToMenu(gameover);
		end
		gameover:insert(gameover.btnMenu)		
	end	
	gameover.unload = function(self)
		self:removeSelf()
	end
	return gameover
end