function love.load()
	local bump = require('bump')
	require('player')
	require('block')
	require('bump')
	require('bullet')
	require('target')
	world1 = bump.newWorld()
	Player = player.new(50,20, "player 1")
	tnum = 0
	tcount = 0
	targettimer = 0
	camera = {}
	camera.x = -Player.x +love.graphics.getWidth()/2
	camera.y = -Player.y +love.graphics.getHeight()/2
	blocks = {}
	blocks["1"] = block.new(20,200,1000,50, "1")
	blocks["5"] = block.new(20,-200,1000,50, "5")
	blocks["2"] = block.new(20,-200,20,400, "2")
	blocks["3"] = block.new(1000,-200,20,400, "3")
	blocks["4"] = block.new(500,120,200,10, "4")
	targets = {}
end

function love.update(dt)
	targettimer = targettimer + dt
	print(tcount)
	if targettimer > 1 and tcount<9 then
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
	camera.x = -Player.x +love.graphics.getWidth()/2
	camera.y = -Player.y +love.graphics.getHeight()/2
end

function love.draw()
	for b, block in pairs(blocks) do
		block.draw()
	end
	Player.draw()
	for t, target in pairs(targets) do
		target.draw()
	end
	love.graphics.printf( fps, 0, 0, love.graphics.getWidth(), "right" )
end

function string.explode(str, div)
	assert(type(str) == "string" and type(div) == "string", "invalid arguments")
	local o = {}
	while true do
		local pos1,pos2 = str:find(div)
		if not pos1 then
			o[#o+1] = str
			break
        end
        o[#o+1],str = str:sub(1,pos1-1),str:sub(pos2+1)
    end
    return o
end