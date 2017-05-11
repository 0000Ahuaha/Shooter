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