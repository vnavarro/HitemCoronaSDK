module(...,package.seeall)
-------------------
local controls = require "controls"
-------------------
function new()
	local menu = display.newGroup()
	
	menu.startSound = audio.loadSound("startbtn.wav")
	
	menu.background = display.newRect(menu,0,0,
		display.contentWidth,display.contentHeight)	
	menu.background:setFillColor(142,54,66)
	menu.title = display.newText(menu,"Brocos",
		display.contentWidth/2, 20,native.systemFont,64)
	menu.title:setTextColor(0,0,0)
	menu.title.x = menu.title.x - menu.title.width/2
	
	--[[local buttonStart = display.newRect(display.contentWidth/2 - 80,
		display.contentHeight-70,160,60)	
	buttonStart:setFillColor(0,230,230)
	local btnStartTouch = function(event) 		
		if event.phase == "ended" then
			print("start touched")
		end
	end
	buttonStart:addEventListener("touch",btnStartTouch)	]]--
		
	--[[menu.buttonStart = controls.newButton()
	menu.buttonStart:show(display.contentWidth/2 - 80,
		display.contentHeight-70,160,60)
	menu.buttonStart:setValue("Start")
	menu.buttonStart.onTouch = function() 
		menu:removeSelf()
	end	
	menu:insert(menu.buttonStart)]]--
	
	menu.buttonStartImage = controls.newImageButton()
	menu.buttonStartImage:show(display.contentWidth/2 - 200,
		display.contentHeight-140,"btnStart.png")	
	menu.buttonStartImage.onTouch = function()		
		--audio.setVolume(0.5)
		local function soundEnded()
			if menu.startTouched ~= true 
			and menu.onStartTouch ~= nil then
				menu.startTouched = true
				menu:onStartTouch()					
			end		
		end
		
		local channeltemp= audio.play(menu.startSound,
		{channel=1,loops=0,onComplete=soundEnded})		
		audio.setVolume(0.5,channeltemp)
	end	
	
	menu.buttonStartImage.background:scale(0.5,0.5)
	menu:insert(menu.buttonStartImage)
	
	menu.logo = display.newImage(menu,"square_2.png",
		display.contentWidth/2 - 10,
		display.contentHeight/2 -32)
	menu.logo:scale(10,10)
	
	return menu
end







