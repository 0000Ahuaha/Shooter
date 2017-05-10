bullet = {}

function bullet.new(x,y,dir, name, player, ang)
	local self = {}
	self.x = x
	self.y = y
	self.dir = dir
	self.mov = {}
	self.mov.x = 0
	self.mov.y = 0
	self.life = 100
	self.speed = 1500
	self.used = false
	self.name = name
	self.ang = {}
	self.ang.x = math.cos(ang)
	self.ang.y = math.sin(ang)
	self.mov = {}
	self.mov.x = 0
	self.mov.y = 0
	
	self.player = player
	world1:add(self.name, self.x, self.y,10,10)
	
	
	local Bulletfilter = function(item, other)
		local name = string.explode(other, " ")
		if name[1] == "player" or name[1] == "bullet" then return "cross"
		else return "touch"
		end
	end
	
	
	
	function self.update(dt)
		self.mov.x = self.x + self.speed*self.ang.x*dt
		self.mov.y = self.y + self.speed*self.ang.y*dt
		local actX, actY, cols, len = world1:move(self.name, self.mov.x, self.mov.y, Bulletfilter)
		self.x = actX
		self.y = actY
		
		for i=1, len do
			local name = string.explode(cols[i].other, " ")
			if name[1] == "t" and self.used == false then
				self.used = true
				self.speed = 0
				targets[cols[i].other].life = targets[cols[i].other].life-1
				if targets[cols[i].other].life<1 then
					world1:remove(cols[i].other)
					targets[cols[i].other] =nil
					tcount = tcount-1
				print("Hit")
				end
			end
			if name[1] ~= "player" and name[1] ~= "bullet" then
				world1:remove(self.name)
				self.player.bullets[self.name] = nil
				print("Hit")
			end
		end
	end
	
	function self.draw()
		love.graphics.rectangle("line", self.x+camera.x, self.y+camera.y, 10,10)
	end
	return self
end