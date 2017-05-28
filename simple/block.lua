block = {}

function block.new(x, y,w,h, name)
	local private = {}
	local public = {}
	private.x = x
	private.y = y
	private.h = h
	private.w = w
	private.name = name
	world1:add(private.name, private.x, private.y, private.w, private.h)
	
	function public.draw()
		love.graphics.rectangle("fill", private.x+camera.x, private.y+camera.y, private.w, private.h)
	end
	
	return public
end