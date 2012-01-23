module(...,package.seeall)

function new(parent)
	popup = display.newGroup()
	popup.show = function(popup,title,subtitle,buttons)
		popup.shader = display.newRect( popup, 0, 0, display.contentWidth, display.contentHeight )	
		popup.shader:setFillColor(0, 0, 0, 200)
		
		popup.background = display.newRoundedRect( popup, display.contentWidth/2 - 125, display.contentHeight/2 -125, 250, 200, 25 )
		popup.background:setFillColor(145,74,34)
		
		popup.title = display.newText(popup, title, 0, 0, fonts.neuropol, 15)
		popup.title:setTextColor(0,0,0)
		
		if buttons then
			popup:insert(buttons[1])
			popup:insert(buttons[2])
		end
	end
	parent:insert(popup)
	return popup
end