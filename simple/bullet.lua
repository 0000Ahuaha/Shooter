bullet = {}

function bullet.new(x,y, name, player, ang)
	local private = {}
	local public = {}
	private.x = x
	private.y = y
	private.mov = {}
	private.mov.x = 0
	private.mov.y = 0
	private.life = 100
	private.speed = 1500
	private.used = false
	private.name = name
	private.ang = {}
	private.ang.x = math.cos(ang)
	private.ang.y = math.sin(ang)
	private.mov = {}
	private.mov.x = 0
	private.mov.y = 0
	
	private.player = player
	world1:add(private.name, private.x, private.y,10,10)
	
	
	private.Bulletfilter = function(item, other)
		local name = string.explode(other, " ")
		if name[1] == "player" or name[1] == "bullet" then return "cross"
		else return "touch"
		end
	end
	
	
	
	function public.update(dt)
		private.mov.x = private.x + private.speed*private.ang.x*dt
		private.mov.y = private.y + private.speed*private.ang.y*dt
		local actX, actY, cols, len = world1:move(private.name, private.mov.x, private.mov.y, private.Bulletfilter)
		private.x = actX
		private.y = actY
		
		for i=1, len do
			local name = string.explode(cols[i].other, " ")
			if name[1] == "t" and private.used == false then
				private.used = true
				private.speed = 0
				targets[cols[i].other].damage()
				if targets[cols[i].other].getLife()<1 then
					world1:remove(cols[i].other)
					targets[cols[i].other] =nil
					tcount = tcount-1
				print("Hit")
				end
			end
			if name[1] ~= "player" and name[1] ~= "bullet" then
				world1:remove(private.name)
				private.player.bullets[private.name] = nil
				print("Hit")
			end
		end
	end
	
	function public.getLife()
		return private.life
	end
	
	function public.getName()
		return private.name
	end
	function public.draw()
		love.graphics.rectangle("line", private.x+camera.x, private.y+camera.y, 10,10)
	end
	return public
end