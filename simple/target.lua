target ={}

function target.new(x,y,name)
	local private = {}
	local public = {}
	private.x = x
	private.y = y
	private.dir = 1
	private.xvel = 200 --love.math.random(180,220)
	private.yvel = 0
	private.coll = {}
	private.coll.b = false
	private.mov = {}
	private.mov.x = 0
	private.mov.y = 0
	private.w = 32
	private.h = 64
	private.name = name
	private.life = 5
	world1:add(private.name, private.x, private.y, private.w, private.h)
	
	private.Targetfilter = function(item, other)
		--print(other)
		local name = string.explode(tostring(other), " ")
		if name[1] == "player" or name[1] == "t" then return "cross"
		else return "slide"
		end
	end
	
	public.update = function(dt)
		if private.coll.b == false then
			private.yvel = private.yvel +dt*800
		else
			private.yvel = 0
		end
		private.mov.x = private.x + dt*private.xvel*private.dir
		private.mov.y = private.y + dt*private.yvel
		local actX, actY, cols, len = world1:move(private.name, private.mov.x, private.mov.y, private.Targetfilter)
		private.x = actX
		private.y = actY
		
		private.coll.b = false 
		for i=1, len do
			local name = string.explode(cols[i].other, " ")
			if name[1] == "b" or name[1] == "obj" then
				if cols[i].normal.y == -1 then private.coll.b = true end
				if cols[i].normal.x ~=0 then
					private.dir = private.dir *(-1)
				end
			end
		end
	end
	
	public.damage = function()
		private.life = private.life-1
		
	end
	
	public.getLife = function()
		return private.life
	end
	
	public.getName = function()
		return private.name
	end
	
	public.draw = function()
		love.graphics.rectangle("fill", private.x+camera.x, private.y + camera.y, private.w, private.h)
	end
	
	public.delete = function()
		world1:remove(private.name)
		targets[private.name] = nil
		tcount = tcount-1
	end
	
	return public
end