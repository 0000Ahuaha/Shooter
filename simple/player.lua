player = {}

function player.new(x,y,name)
	local self = {}
	self.name = name
	self.x = x
	self.y = y
	self.coll = {}
	self.coll.t = false 
	self.coll.b = false 
	self.coll.l = false 
	self.coll.r = false
	self.dir = 1
	world1:add(self.name, self.x, self.y, 32, 32)
	self.yvel = 0
	self.xvel = 0
	self.mov = {}
	self.mov.x = 0
	self.mov.y = 0
	self.bulltimer = 0
	self.bulletcount = 0
	self.bulltimermax = 0.1
	self.mousevet = {}
	self.mousevet.x = 0
	self.mousevet.y = 0
	self.spray =5
	self.ivul = 0;
	self.timerdamage = 0;
	self.canmove = 1;
	self.bullets = {}
	
	local Playerfilter = function(item, other)
		--print(other)
		local name = string.explode(tostring(other), " ")
		if name[1] == "bullet" or name[1] == "t" then return "cross"
		else return "slide"
		end
	end
	
	function self.update(dt)
		self.bulltimer = self.bulltimer + dt
		self.mov.x = self.x + self.xvel *dt
		self.mov.y = self.y + self.yvel*dt
		if self.coll.b == false then
			self.yvel = self.yvel +dt*800
		else
			self.yvel = .001
		end
		if self.coll.t == true then
			self.yvel = 0
		end
		if self.ivul >0 then self.ivul = self.ivul-dt end
		if self.canmove == 0 then
			self.timerdamage = self.timerdamage+ dt
			if self.timerdamage >= 0.5 or self.coll.b == true then
				self.timerdamage = 0
				self.canmove = 1
			end
		else
			self.xvel = 0
		
			if love.keyboard.isDown("a") then
				self.xvel = -350
				self.dir = -1
			end
			if love.keyboard.isDown("d") then
				self.xvel = 350
				self.dir = 1
			end
			if love.keyboard.isDown("space") and self.coll.b == true then
				self.yvel = -500
			end
		end
		
		if love.mouse.isDown(1) and self.bulltimer > self.bulltimermax then
			self.bulletcount = (self.bulletcount+1)%300
			self.mousevet.x, self.mousevet.y = love.mouse.getPosition()
			
			self.mousevet.x = (self.mousevet.x- (love.graphics.getWidth()/2+16))+love.math.random(-self.spray, self.spray)
			self.mousevet.y = self.mousevet.y- (love.graphics.getHeight()/2+16)+love.math.random(-self.spray, self.spray)
			local angle = math.atan2((self.mousevet.y), (self.mousevet.x))
			print(self.mousevet.x .. ", " .. self.mousevet.y)
			
			
			local newbullet = bullet.new(self.x+11, self.y+11,self.dir,"bullet " .. tostring(self.bulletcount), self, angle)
			self.bullets[newbullet.name] = newbullet
			print(newbullet.name)
			self.bulltimer = 0
		end
		for b, bullet in pairs(self.bullets) do
			bullet.update(dt)
			if bullet.life<=0 then
				world1:remove(bullet.name)
				self.bullets[b]= nil
			end
		end
		
		self.coll.t = false 
		self.coll.b = false 
		self.coll.l = false 
		self.coll.r = false
		
		local actX, actY, cols, len = world1:move(self.name, self.mov.x, self.mov.y, Playerfilter)
		self.x = actX
		self.y = actY
		for i=1, len do
			local name = string.explode(cols[i].other, " ")
			if name[1] ~= "bullet" and name[1] ~= "t" then
				if cols[i].normal.y == -1 then self.coll.b = true end
				if cols[i].normal.y == 1 then self.coll.t = true end
			end
			if self.ivul <=0 then
				if name[1] == "t" then
					self.canmove = 0;
					self.yvel = -250
					self.xvel = 150 * cols[i].normal.x
					self.ivul =2
					self.coll.b = false
					break
				end
			end
		end
		
	end
	
	function self.draw()
		love.graphics.print(self.yvel, 0,0)
		love.graphics.print(self.x .. "\n" .. self.y .. "\n" .. tostring(self.coll.b) .. "\n" .. tostring(self.coll.t) .. "\n" .. self.bulltimer .. "\n" .. self.bulletcount .. "\n" .. self.ivul, 0,20)
		love.graphics.rectangle("fill", self.x+ camera.x, self.y+camera.y, 32, 32)
		for b, bullet in pairs(self.bullets) do
			bullet.draw()
		end
		
	end
	
	return self
end
