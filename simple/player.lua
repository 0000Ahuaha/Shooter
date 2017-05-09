player = {}

function player.new(x,y,name)
	local private = {}
	local public = {}
	private.name = name
	private.x = x
	private.y = y
	private.coll = {}
	private.coll.t = false 
	private.coll.b = false 
	private.coll.l = false 
	private.coll.r = false
	private.dir = 1
	world1:add(private.name, private.x, private.y, 32, 32)
	private.yvel = 0
	private.xvel = 0
	private.mov = {}
	private.mov.x = 0
	private.mov.y = 0
	private.bulltimer = 0
	private.bulletcount = 0
	private.bulltimermax = 0.1
	private.mousevet = {}
	private.mousevet.x = 0
	private.mousevet.y = 0
	private.spray =5
	private.ivul = 0;
	private.timerdamage = 0;
	private.canmove = 1;
	private.bullets = {}
	
	local Playerfilter = function(item, other)
		--print(other)
		local name = string.explode(tostring(other), " ")
		if name[1] == "bullet" or name[1] == "t" then return "cross"
		else return "slide"
		end
	end
	
	function public.getX()
		return private.x
	end
	function public.getY()
		return private.y
	end
	
	function public.update(dt)
		private.bulltimer = private.bulltimer + dt
		private.mov.x = private.x + private.xvel *dt
		private.mov.y = private.y + private.yvel*dt
		if private.coll.b == false then
			private.yvel = private.yvel +dt*800
		else
			private.yvel = .001
		end
		if private.coll.t == true then
			private.yvel = 0
		end
		if private.ivul >0 then private.ivul = private.ivul-dt end
		if private.canmove == 0 then
			private.timerdamage = private.timerdamage+ dt
			if private.timerdamage >= 0.5 or private.coll.b == true then
				private.timerdamage = 0
				private.canmove = 1
			end
		else
			private.xvel = 0
		
			if love.keyboard.isDown("a") then
				private.xvel = -350
				private.dir = -1
			end
			if love.keyboard.isDown("d") then
				private.xvel = 350
				private.dir = 1
			end
			if love.keyboard.isDown("space") and private.coll.b == true then
				private.yvel = -500
			end
		end
		
		if love.mouse.isDown(1) and private.bulltimer > private.bulltimermax then
			private.bulletcount = (private.bulletcount+1)%300
			private.mousevet.x, private.mousevet.y = love.mouse.getPosition()
			
			private.mousevet.x = (private.mousevet.x- (love.graphics.getWidth()/2+16))+love.math.random(-private.spray, private.spray)
			private.mousevet.y = private.mousevet.y- (love.graphics.getHeight()/2+16)+love.math.random(-private.spray, private.spray)
			local angle = math.atan2((private.mousevet.y), (private.mousevet.x))
			print(private.mousevet.x .. ", " .. private.mousevet.y)
			
			
			local newbullet = bullet.new(private.x+11, private.y+11,private.dir,"bullet " .. tostring(private.bulletcount), private, angle)
			private.bullets[newbullet.name] = newbullet
			print(newbullet.name)
			private.bulltimer = 0
		end
		for b, bullet in pairs(private.bullets) do
			bullet.update(dt)
			if bullet.life<=0 then
				world1:remove(bullet.name)
				private.bullets[b]= nil
			end
		end
		
		private.coll.t = false 
		private.coll.b = false 
		private.coll.l = false 
		private.coll.r = false
		
		local actX, actY, cols, len = world1:move(private.name, private.mov.x, private.mov.y, Playerfilter)
		private.x = actX
		private.y = actY
		for i=1, len do
			local name = string.explode(cols[i].other, " ")
			if name[1] ~= "bullet" and name[1] ~= "t" then
				if cols[i].normal.y == -1 then private.coll.b = true end
				if cols[i].normal.y == 1 then private.coll.t = true end
			end
			if private.ivul <=0 then
				if name[1] == "t" then
					private.canmove = 0;
					private.yvel = -250
					private.xvel = 150 * cols[i].normal.x
					private.ivul =2
					private.coll.b = false
					break
				end
			end
		end
		
	end
	
	function public.draw()
		love.graphics.print(private.yvel, 0,0)
		love.graphics.print(private.x .. "\n" .. private.y .. "\n" .. tostring(private.coll.b) .. "\n" .. tostring(private.coll.t) .. "\n" .. private.bulltimer .. "\n" .. private.bulletcount .. "\n" .. private.ivul, 0,20)
		love.graphics.rectangle("fill", private.x+ camera.x, private.y+camera.y, 32, 32)
		for b, bullet in pairs(private.bullets) do
			bullet.draw()
		end
		
	end
	
	return public
end
