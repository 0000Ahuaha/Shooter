level1 = {}

function level1.new()
	local self = {}
	local bump = require('bump')
	world1 = bump.newWorld(128)
	Player = player.new(50,20, "player 1")
	tnum = 0
	tcount = 0
	targettimer = 0
	camera = {}
	camera.x = -Player.getX() +love.graphics.getWidth()/2
	camera.y = -Player.getY() +love.graphics.getHeight()/2
	blocks = {}
	blocks["b 1"] = block.new(20,200,1000,50, "b 1")
	blocks["b 2"] = block.new(20,-200,20,400, "b 2")
	blocks["b 3"] = block.new(1000,-200,20,400, "b 3")
	blocks["b 4"] = block.new(500,120,200,10, "b 4")
	blocks["b 5"] = block.new(20,-200,1000,50, "b 5")
	targets = {}
	obj = obj.new(50,150, "obj")

	function self.update(dt)
		targettimer = targettimer + dt
		print(tcount)
		if targettimer > 0.01 and tcount<15 then
			tnum = (tnum+1)%300
			newT = target.new(550,50,"t " .. tnum)
			targets[newT.name] = newT
			targettimer = 0
			tcount = tcount+1
		end
		Player.update(dt)
		for t, target in pairs(targets) do
			target.update(dt)
		end
		fps = love.timer.getFPS( )
		camera.x = -Player.getX() +love.graphics.getWidth()/2
		camera.y = -Player.getY() +love.graphics.getHeight()/2
	end
	
	function self.draw()
		for b, block in pairs(blocks) do
			block.draw()
		end
		Player.draw()
		for t, target in pairs(targets) do
			target.draw()
		end
		love.graphics.printf( fps, 0, 0, love.graphics.getWidth(), "right" )
		obj.draw()                                                           
	end
	return self
end	