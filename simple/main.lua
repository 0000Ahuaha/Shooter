function love.load()
	local bump = require('bump')
	require('player')
	require('block')
	require('bullet')
	require('target')
	require('obj')
	require('level1')
	level = level1.new()
end

function love.update(dt)
	level.update(dt)
end

function love.draw()
	level.draw()                                                          
end

function love.keypressed(key, unicode)
	level.keypressed(key, unicode)
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

function coll(x1,y1,w1,h1,x2,y2,w2,h2)
	return x1 < x2+w2 and
			x2 < x1+w1 and
			y1 < y2+h2 and
			y2 < y1+h1
end

function dist(x1,y1,x2,y2)
	return math.sqrt(math.pow(x2-x1, 2)+ math.pow(y2-y1,2))
end