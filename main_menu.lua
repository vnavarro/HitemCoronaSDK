--[[MainMenu = {}
MainMenu.__index = MainMenu

function MainMenu.new()
	local mainmenu = {}
	setmetatable(mainmenu,MainMenu)
	
	
	
	return mainmenu
end

function MainMenu:destroy()
	
end

function MainMenu:show()
	self.view = display.newGroup()
	self.background = display.newRect( self.view, 0, 0, display.contentWidth, display.contentHeight )
	self.background:setFillColor(69,139,0)
end
]]--

module(...,package.seeall)
local controls = require "controls"

function new()
	local mainmenu = display.newGroup()
	mainmenu.startSound = audio.loadSound("startbtn.wav")
	
	
	mainmenu.show = function (self) 
		self.background = display.newRect(self, 0, 0, display.contentWidth, display.contentHeight )
		self.background:setFillColor(164,211,238)--205,200,177
		self.btnStart = controls.newButton()
		self.btnStart:show(display.contentWidth/2 - 50,display.contentHeight - 75,100,50)
		self.btnStart:setValue("Start")
		self:insert(self.btnStart)
		self.title = display.newText(self, "Hit'em!", display.contentWidth/2, 100, fonts.neuropol, 45)
		self.title.x = self.title.x - self.title.width/2
		self.title:setTextColor(16,78,139)--72,55,55
	end
	
	mainmenu.onBtnStartTouched = function(self,listener)			
		audio.setVolume(1,1)
		audio.play(startSound,
		{channel=1,loops=0,onComplete=function()
			self.btnStart.onTouch = listener
		end})
	end
	
	mainmenu.unload = function(self)
		self:removeSelf()
	end
	
	return mainmenu
end


