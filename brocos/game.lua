module(...,package.seeall)
---------------------------
local physics = require "physics"
physics.start()
physics.setGravity(0,0)
physics.setDrawMode("hybrid")
---------------------------
local fonts = {neuropol = "Neuropol"}
local dbcontroller = require "dbcontroller"

function new()
	local game = display.newGroup()	
	game.hitbarSound = audio.loadSound("barhit.wav")
	game.hitblockSound = audio.loadSound("hitblock.wav")	
	game.dbc = dbcontroller.new()

	game.show = function(game)
		game.score = 0
		game.isNotStarted = true		

		game.background = display.newRect(game,0,0,
			display.contentWidth,display.contentHeight)
		game.background:setFillColor(23,134,45)

		game.scoreTitleText = display.newText(game,"Score:",
			20,20,fonts.neuropol,25)
		game.scoreTitleText:setTextColor(0,0,0)

		game.scoreValueText = display.newText(game,game.score,
			game.scoreTitleText.x + game.scoreTitleText.width,
			20,fonts.neuropol,25)
		game.scoreValueText:setTextColor(0,0,0)

		for j=1,10 do
			for i=1,display.contentWidth/32 do
				local index = math.random(1,4)
				local block = display.newImage(game,
					"square_"..index..".png",
					(32*(i-1)),80+(32*(j-1)))
				block.name = "square"
				block.value = index * 35
				physics.addBody(block,"static",
					{density=1,friction=0.3,bounce=0})
			end
		end

		-- Aqui comeca a barra
		game.bar = display.newImage(game,"bar.png",
			display.contentWidth/2,display.contentHeight)
		game.bar.x = game.bar.x - game.bar.width/2
		game.bar.y = game.bar.y - game.bar.width
		game.bar.name = "bar"	
		
		physics.addBody(game.bar,"static",
			{density=1,friction=.3,bounce=0})					
		
		--Aqui comeca a bola
		game.ball = display.newImage(game,"ball.png",
			display.contentWidth/2,
			game.bar.y)
		game.ball.x = game.ball.x - game.ball.width/2
		game.ball.y = game.ball.y - game.ball.width - 10

		physics.addBody(game.ball,"dynamic",
			{density=1,friction=.3,bounce=0,radius=10})

		local function isInsideBarPiece(ballBounds,barBounds,
			pieceWidth,pieceSection)
			--print(ballBounds.xMin,ballBounds.xMax,barBounds.xMin+pieceWidth*(pieceSection-1),barBounds.xMin+pieceWidth*pieceSection,pieceSection)
			local insideXmin = (ballBounds.xMin >= barBounds.xMin
				+ pieceWidth*(pieceSection-1) and
				ballBounds.xMin < barBounds.xMin 
				+ pieceWidth*pieceSection)
			local insideXmax = (ballBounds.xMax >= barBounds.xMin 
				+ pieceWidth*(pieceSection-1) and
				ballBounds.xMax < barBounds.xMin 
				+ pieceWidth*pieceSection)
			--print(insideXmin,insideXmax)
			return insideXmin or insideXmax
		end
			
		local function onLocalCollision(self,event)			
			print(event.phase)		
			if event.phase == "began" then
			
				local vx,vy = game.ball:getLinearVelocity()
				local fx = 0
				local fy = 0				
				print(game.ball:getLinearVelocity(),fx,fy)								
				if event.other.name == "square" then					
					fy = 200
					game.ball:setLinearVelocity( -vx,fy )
					--print("blocks",event.other.value)
					game.score = game.score + event.other.value
					game.scoreValueText.text = game.score
					event.other:removeSelf()
					
					audio.play(game.hitblockSound)
					
				elseif event.other.name == "bar" 
					and game.isNotStarted == false then						
					local pieceWidth = game.bar.width/5						
					if isInsideBarPiece(game.ball.contentBounds,
						game.bar.contentBounds,pieceWidth,1) then
						print("esq")
						fy = -200
						fx = -600
					elseif isInsideBarPiece(game.ball.contentBounds,
						game.bar.contentBounds,pieceWidth,2) then
						print("esq")
						fy = -200
						fx = -400
					elseif isInsideBarPiece(game.ball.contentBounds,game.bar.contentBounds
						,pieceWidth,3) then	
						print("reto")
						fy = -200
						fx = 0						
					elseif isInsideBarPiece(game.ball.contentBounds,game.bar.contentBounds
						,pieceWidth,4) then
						print("dir")
						fy = -200
						fx = 400						
					elseif isInsideBarPiece(game.ball.contentBounds,game.bar.contentBounds
						,pieceWidth,5) then
						print("dir")
						fy = -200
						fx = 600						
					end					
					game.ball:setLinearVelocity( fx,fy )
					
					audio.play(game.hitbarSound)
					
				elseif event.other.name == "wall_left" then					
					local fy = 200
					if vy < 0 then											
						fy = -fy					
					end					
					game.ball:setLinearVelocity( -vx,fy )
				--	game.ball:applyForce( fx, fy, game.ball.x, game.ball.y )
					--game.ball:applyLinearImpulse( 0, -1, game.ball.x, game.ball.y )
					
					audio.play(game.hitblockSound)
					
				elseif event.other.name == "wall_right" then					
					local fy = 200
					if vy < 0 then											
						fy = -fy					
					end
					game.ball:setLinearVelocity( -vx,fy )
				--	game.ball:applyForce( fx, fy, game.ball.x, game.ball.y )					
					--game.ball:applyLinearImpulse( 0, -1, game.ball.x, game.ball.y )
					
					audio.play(game.hitblockSound)
				elseif event.other.name == "wall_top" then
					game.ball:setLinearVelocity( vx,200 )
				--	game.ball:applyForce( fx, fy, game.ball.x, game.ball.y )					
					--game.ball:applyLinearImpulse( 0, -1, game.ball.x, game.ball.y )
					
					audio.play(game.hitblockSound)
				elseif event.other.name == "wall_bottom" then
					--game.ball:setLinearVelocity( vx,-200 )
					game.isOver = true
					game.dbc.saveGameHighScore(game.score)
					physics.pause()
					--game:removeSelf()
				--	game.ball:applyForce( 0, -30, game.ball.x, game.ball.y )					
				end
			end
		end		

		game.ball.collision = onLocalCollision
		game.ball:addEventListener( "collision",
			game.ball )

		local leftWall = display.newRect(game,-1,0,1,
			display.contentHeight)
			leftWall.name = "wall_left"
		leftWall:setFillColor(0,0,0,0)
		physics.addBody(leftWall, "static",
			{density=1, friction=1, bounce=0})

		local rightWall = display.newRect(game,
			display.contentWidth,0,1,
			display.contentHeight)
			rightWall.name = "wall_right"
		rightWall:setFillColor(0,0,0,0)
		physics.addBody(rightWall, "static", {density=1,
			friction=.3, bounce=0})

		local roof = display.newRect(game,0,-1,
			display.contentWidth,1)
		roof.name = "wall_top"
		roof:setFillColor(0,0,0,0)
		physics.addBody(roof, "static", {density=1,
			friction=.3, bounce=0})

		local flor = display.newRect(game,
			0,display.contentHeight,display.contentWidth,
			1)
		flor.name = "wall_bottom"
		flor:setFillColor(0,0,0,0)
		physics.addBody(flor, "static",
			{density=1, friction=.3, bounce=0})
	end	

	game.onTouch = function(event)
		if game.isOver then return end
		
		if event.phase == "ended"
			and game.isNotStarted then
			--game.ball:applyLinearImpulse(game.speedX,game.speedY,
			--	game.ball.x,game.ball.y)
			--game.ball:applyForce(0,-1000,
			--	game.ball.x,game.ball.y)			
			--game.ball:setLinearVelocity(0,-2000)
			game.ball:setLinearVelocity( 0,-200 )							
			game.isNotStarted = false
		end
		if event.y >= game.bar.y - game.bar.height*2 then
			local size = game.bar.width/2
			if event.x > game.bar.contentBounds.xMin then 
				size= size *-1 
			end
			print("size",size)
			transition.to(game.bar, 
				{time = 500, x = event.x + size })
		end
	end

	game:addEventListener("touch",game.onTouch)

	game.onEnterFrame = function(event)
	end

	Runtime:addEventListener("enterFrame",game.onEnterFrame)

	return game
end