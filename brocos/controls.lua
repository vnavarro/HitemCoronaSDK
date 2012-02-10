--[[
display.CenterReferencePoint
display.TopLeftReferencePoint
display.TopCenterReferencePoint
display.TopRightReferencePoint
display.CenterRightReferencePoint
display.BottomRightReferencePoint
display.BottomCenterReferencePoint
display.BottomLeftReferencePoint
display.CenterLeftReferencePoint
]]--
module(...,package.seeall)

local fonts = {neuropol = "Neuropol" }

function newButton()
	local button = display.newGroup()
	button.value = "Button"	
	button.show = function (button,x,y,width,height) 		
		button.background = display.newRoundedRect(button, x, y, width, height,12 )
		button.background:setFillColor(16,78,139)--72,55,55)
		button.background2 = display.newRoundedRect(button, x, y, width-2, height-2,12 )
		button.background2:setFillColor(79,148,205)--108,93,83)
		button.valueText = display.newText(button, button.value, x, y, fonts.neuropol, 15)		
		button.valueText.x = x + width/2
		button.valueText.y = y + height/2 - button.valueText.height/4
		button.valueText:setTextColor(16,78,139)--46,35,35)
	end	
	
	button.touch = function (event)	
		if event.phase == "ended" then
			if button.onTouch then 
				return button:onTouch()
			end
			button.background:setFillColor(16,78,139)
			button.background2:setFillColor(79,148,205)
			button.valueText:setTextColor(16,78,139)
		else
			button.background2:setFillColor(16,78,139)
			button.background:setFillColor(79,148,205)
			button.valueText:setTextColor(79,148,205)
		end
	end
	button:addEventListener("touch",button.touch)
	
	button.setValue = function (button,value) 
		button.valueText.text = value
	end
	return button
end

function newImageButton()
	local button = display.newGroup()
	
	button.show = function (self,x,y,bg)
		self.background = display.newImage(self,bg, x, y)
	end
	
	button.setImage = function (self,bg)
		local xPos=self.background.x-self.background.width/2
		local yPos=self.background.y-self.background.height/2
		self.background:removeSelf()
		self.background = display.newImage(self,bg,xPos,yPos)						
	end
	
	button.touch = function (event)	
		if event.phase == "ended" then
			if button.onTouch then 
				return button:onTouch()
			end
		end
	end
	button:addEventListener("touch",button.touch)
	
	return button
end