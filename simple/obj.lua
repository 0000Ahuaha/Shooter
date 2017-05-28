obj = {}

function obj.new(x,y, name)
	public = {}
	private = {}
	private.name = name
	private.r = 200;
	private.x = x
	private.y = y 
	
	function public.update(dt)
		
	end
	
	public.draw = function()
		love.graphics.circle("line",private.x+camera.x, private.y+camera.y, private.r)
		love.graphics.rectangle("fill", private.x+camera.x,private.y+camera.y,1,1)
	end
	
	return public
end