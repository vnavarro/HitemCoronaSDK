module(...,package.seeall)
---------------------------
local controls = require "controls"
---------------------------
physics = require "physics"
physics.start()
physics.setDrawMode( "hybrid" )
--physics.setDrawMode( "normal" )
physics.setGravity(0,0)
scale = 45
physics.setScale(scale)
--physics.setPositionIterations( 1024 )
--physics.setVelocityIterations( 1024 )------
---------------------------
----------Square-------------
----------Bar-------------
----------Ball-------------

----------Game-------------
function new()
	local game = display.newGroup()
	game.score = 0 
	game.isOver = false
	game.squares = {}
	game.ballMoving = false
	game.pause = false
	
	game.load = function (game)
		physics.start()
				
		game.background = display.newRect( game, 0, 0, display.contentWidth,display.contentHeight )
		game.background:setFillColor(255,255,255)
				
		game.btnPause = controls.newImageButton()
		game:insert(game.btnPause)
		game.btnPause:show(270,10,"pauseButton.png")
		game.btnPause.onTouch = function ()
			game.pause = not game.pause
			if game.pause then 
				physics.pause()
				game.btnPause:setImage("playButton.png") 
			else 
				game.btnPause:setImage("pauseButton.png") 
				physics.start() 
			end			
			return true
		end
				
		game.txtScore = display.newText(game, game.score, 10, 10, fonts.neuropol, 20)
		game.txtScore:setTextColor(0,0,0)
		game.txtScore:setReferencePoint(display.TopLeftReferencePoint)
		game.txtScore.x = 10
		
		local function onLocalCollision( self,event )
	        if ( event.phase == "began" ) then
				--if self.name and event.other.name then
                --	print( self.name .. ":target.name??? collision began with " .. event.other.name )
				--end
	        elseif ( event.phase == "ended" ) then
				local vx,vy = game.ball:getLinearVelocity()
				local fx = 0
				local fy = 30
				if vx < 0 then fx=30 elseif vx > 0 then fx=-30 end
				if vy < 0 then fy=-30 elseif vy > 0 then fy=30 end
				print(game.ball:getLinearVelocity(),fx,fy)
				if event.other.name == "square" then					
					--game.ball:applyForce( 0, 45, game.ball.x, game.ball.y )
					game.ball:setLinearVelocity( vx,125 )
					game.score = game.score + 25 * event.other.value
					game.txtScore.text = game.score
					game.txtScore:setReferencePoint(display.TopLeftReferencePoint)
					game.txtScore.x = 10	
					table.remove(game.squares, event.other.index)														
					event.other:removeSelf()
					if #game.squares <= 0 then 
						game.isOver = true
					end
				elseif event.other.name == "bar" then
					if  game.ball.x < game.bar.x then fy = -45 fx = -125 
					elseif game.ball.x > game.bar.x then fy = -45 fx = 125
					else fy= -45 fx = 0 end
					game.ball:setLinearVelocity( fx,-125 )
					--game.ball:applyForce( fx, fy, game.ball.x, game.ball.y )
				elseif event.other.name == "wall_left" then
				--	game.ball:applyForce( fx, fy, game.ball.x, game.ball.y )
					--game.ball:applyLinearImpulse( 0, -1, game.ball.x, game.ball.y )
				elseif event.other.name == "wall_right" then
				--	game.ball:applyForce( fx, fy, game.ball.x, game.ball.y )					
					--game.ball:applyLinearImpulse( 0, -1, game.ball.x, game.ball.y )
				elseif event.other.name == "wall_top" then
				--	game.ball:applyForce( fx, fy, game.ball.x, game.ball.y )					
					--game.ball:applyLinearImpulse( 0, -1, game.ball.x, game.ball.y )
				elseif event.other.name == "wall_bottom" then
					game.isOver = true
					physics.pause()
				--	game.ball:applyForce( 0, -30, game.ball.x, game.ball.y )					
--					game:removeSelf()
				end
	        end
		end
		
		local function onCollision( event )
		        if ( event.phase == "began" ) then
		                print( "began: " .. event.object1.name .. " & " .. event.object2.name )

		        elseif ( event.phase == "ended" ) then

		                print( "ended: " .. event.object1.name .. " & " .. event.object2.name )

		        end
		end
		
		--Runtime:addEventListener( "collision", onCollision )
		for i=1,10 do
			for j=1,5 do
				local value = math.random(1,4)
				local square = display.newImage( game, "square_"..value..".png", (i-1)*32,(j+1)*32)			
				square.name = "square"
				square.value = value
				physics.addBody( square,"static", { density = 1.0, friction = 0, bounce = 0.2 } )
				--square.collision = onLocalCollision
				--square:addEventListener( "collision", square )				
				game.squares[#game.squares+1] = square
				square.index = #game.squares
			end
		end	
		
		game.bar = display.newImage( game, "bar.png" )	
		game.bar.x = display.contentWidth/2
		game.bar.y = 450
		game.bar.name = "bar"
		physics.addBody( game.bar,"static", { density = 1.0, friction = 0.3, bounce = 0.2 } )				
	
		game.ball = display.newImage( game, "ball.png")
		game.ball.x = 160
		game.ball.y = 425
		game.name = "ball"
		physics.addBody(game.ball,"dynamic",{ density = 1.0, friction = 0.3, bounce = 0.3,radius=12 })		
		game.ball.isBullet = true

		game.ball.collision = onLocalCollision
		game.ball:addEventListener( "collision", game.ball )

		--game.bar.collision = onLocalCollision
		--game.bar:addEventListener( "collision", game.bar )
		
		local wall = display.newRect( game, -5, 0, 5, display.contentHeight+game.ball.height*1.5 )
		wall.name = "wall_left"
		physics.addBody( wall,"static", { density = 1.0, friction = 0.0, bounce = 0.2 } )
		
		--wall.collision = onLocalCollision
		--wall:addEventListener( "collision", wall )
		
		local wall = display.newRect( game, display.contentWidth, 0, 5, display.contentHeight+game.ball.height*1.5 )
		wall.name = "wall_right"
		physics.addBody( wall,"static", { density = 1.0, friction = 0.0, bounce = 0.2 } )
		
		--wall.collision = onLocalCollision
		--wall:addEventListener( "collision", wall )
		
		local wall = display.newRect( game, 0, -5, display.contentWidth, 5)
		wall.name = "wall_top"
		physics.addBody( wall,"static", { density = 1.0, friction = 0.0, bounce = 0.2 } )
		
		--wall.collision = onLocalCollision
		--wall:addEventListener( "collision", wall )
		
		local wall = display.newRect( game, 0, display.contentHeight+game.ball.height*1.5, display.contentWidth, 5)
		wall.name = "wall_bottom"
		physics.addBody( wall,"static", { density = 1.0, friction = 0.0, bounce = 0.2 } )
		
		--wall.collision = onLocalCollision
		--wall:addEventListener( "collision", wall )
		
		game.touch = function (event)	
			if game.pause then return end
			if event.phase == "moved" then
				local x = 20
				print("moved",event.xStart-event.x)
				if event.x < game.bar.x-60 then 
					--game.bar:translate(-x,0)
				elseif event.x > game.bar.x+60 then
					--game.bar:translate(x,0)
				end
			elseif event.phase == "ended" then			
				print(event.y,game.bar.y - game.bar.height*4)
				print(game.ballMoving)
				if not game.ballMoving then 
					game.ballMoving = true
					game.ball:setLinearVelocity( 0,-125 )
				elseif event.y >= game.bar.y - game.bar.height*2 then
					local size = game.bar.width/2
					if event.x > game.bar.contentBounds.xMin then size= size *-1 end
										print("size",size)
					transition.to(game.bar, {time = 200, x = event.x + size })
				end
			end
		end
		
		game.onGameOver = function (game)
			game.isOver = false
			for i=1,#game.squares do
				local square = game.squares[i]
				--if square then square:removeSelf() end
				if square ~= nil then physics.removeBody(square) end
			end					
			physics.removeBody(game.bar)
			game.ball:removeEventListener("collision",game.ball)
			physics.removeBody(game.ball)
			Runtime:removeEventListener("touch",game.touch)
			game:removeSelf()
		end
		
		local function onEnterFrame (self,event)
			if game.pause then return end
			if self.isOver then
				self.isOver = false
				for i=1,#self.squares do
					local square = self.squares[i]
					square:removeSelf()
				end				
				self.bar:removeSelf()
				Runtime:removeEventListener("enterFrame",game.enterFrame)
				self:removeSelf()
				--self:onGameOver()				
			end
		end		
		--game.enterFrame = onEnterFrame		
		
		Runtime:addEventListener("touch",game.touch)			
		--Runtime:addEventListener("enterFrame",game)
	end
	return game
end