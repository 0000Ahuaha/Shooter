target ={}

function target.new(x,y,name)
	local self = {}
	self.x = x
	self.y = y
	self.dir = 1
	self.xvel = 200 --love.math.random(180,220)
	self.yvel = 0
	self.coll = {}
	self.coll.b = false
	self.mov = {}
	self.mov.x = 0
	self.mov.y = 0
	self.w = 32
	self.h = 64
	self.name = name
	self.life = 15
	world1:add(self.name, self.x, self.y, self.w, self.h)
	
	local Targetfilter = function(item, other)
		--print(other)
		local name = string.explode(tostring(other), " ")
		if name[1] == "player" or name[1] == "t" then return "cross"
		else return "slide"
		end
	end
	
	self.update = function(dt)
		if self.coll.b == false then
			self.yvel = self.yvel +dt*800
		else
			self.yvel = 0
		end
		self.mov.x = self.x + dt*self.xvel*self.dir
		self.mov.y = self.y + dt*self.yvel
		local actX, actY, cols, len = world1:move(self.name, self.mov.x, self.mov.y, Targetfilter)
		self.x = actX
		self.y = actY
		
		self.coll.b = false 
		for i=1, len do
			local name = string.explode(cols[i].other, " ")
			if name[1] == "b" then
				if cols[i].normal.y == -1 then self.coll.b = true end
				if cols[i].normal.x ~=0 then
					self.dir = self.dir *(-1)
				end
			end
		end
	end
	
	self.draw = function()
		love.graphics.rectangle("fill", self.x+camera.x, self.y + camera.y, self.w, self.h)
	end
	
	self.delete = function()
		world1:remove(self.name)
		targets[self.name] = nil
		tcount = tcount-1
	end
	
	return self
end