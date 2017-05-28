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
	private.buttons = {}
	private.buttons.left = {}
	private.buttons.left.x = love.graphics.getWidth()/18
	private.buttons.left.y = (love.graphics.getHeight()/10)*8
	private.buttons.left.w = love.graphics.getWidth()/7
	private.buttons.left.h = love.graphics.getHeight()/7
	private.buttons.right = {}
	private.buttons.right.x = (love.graphics.getWidth()/18)*4
	private.buttons.right.y = (love.graphics.getHeight()/10)*8
	private.buttons.right.w = love.graphics.getWidth()/7
	private.buttons.right.h = love.graphics.getHeight()/7
	private.buttons.jump = {}
	private.buttons.jump.x = (love.graphics.getWidth()/10)*7.8
	private.buttons.jump.y = (love.graphics.getHeight()/10)*4.8
	private.buttons.jump.w = love.graphics.getWidth()/7
	private.buttons.jump.h = love.graphics.getHeight()/7
	private.stick = {}
	private.stick.x = (love.graphics.getWidth()/10)*8.5
	private.stick.y = (love.graphics.getHeight()/10)*8
	private.stick.r = love.graphics.getWidth()/10
	private.teste = false
	
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
	
	function private.movleft()
				private.xvel = -350
				private.dir = -1
	end
	
	function private.movright()
				private.xvel = 350
				private.dir = 1
	end
	
	function private.shoot(angle)
				private.bulletcount = (private.bulletcount+1)%300
				local newbullet = bullet.new(private.x+11, private.y+11,"bullet " .. tostring(private.bulletcount), private, angle)
				private.bullets[newbullet.getName()] = newbullet
				print(newbullet.getName())
				private.bulltimer = 0
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
				private.movleft()
			end
			if love.keyboard.isDown("d") then
				private.movright()
			end
			if love.keyboard.isDown("space") and private.coll.b == true then
				private.yvel = -500
			end
		end
		
		if love.system.getOS() ~= "Android" then
			if love.mouse.isDown(1) and private.bulltimer > private.bulltimermax then
				private.mousevet.x, private.mousevet.y = love.mouse.getPosition()
				
				private.mousevet.x = (private.mousevet.x- (love.graphics.getWidth()/2+16))+love.math.random(-private.spray, private.spray)
				private.mousevet.y = private.mousevet.y- (love.graphics.getHeight()/2+16)+love.math.random(-private.spray, private.spray)
				local angle = math.atan2((private.mousevet.y), (private.mousevet.x))
				print(private.mousevet.x .. ", " .. private.mousevet.y)
				
				private.shoot(angle)
			end
		else
			private.teste = false
    		local touches = love.touch.getTouches()
			for i,touch in pairs(touches) do
				
				local x,y = love.touch.getPosition(touch)
				for b,button in pairs(private.buttons) do
					if coll(x,y,1,1,button.x, button.y, button.w, button.h) and private.canmove ~= 0 then
						if b == 'left' then
							private.movleft()
						end
						if b == 'right' then
							private.movright()
						end
						if b == 'jump' and private.coll.b then
							private.yvel = -500
						end
					end
					if dist(x,y,private.stick.x, private.stick.y)<private.stick.r and private.bulltimer>private.bulltimermax then
						private.mousevet.x = (x-private.stick.x)+love.math.random(-private.spray, private.spray)
						private.mousevet.y = (y-private.stick.y)+love.math.random(-private.spray, private.spray)
						local angle = math.atan2(private.mousevet.y, private.mousevet.x)
						private.shoot(angle)
					end
				end
			end
		end
		
		for b, bullet in pairs(private.bullets) do
			bullet.update(dt)
			if bullet.getLife()<=0 then
				world1:remove(bullet.getName())
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
		--if(love.system.getOS() == "Android") then
			for bu,button in pairs(private.buttons) do
				love.graphics.rectangle("line", button.x, button.y, button.w, button.h)
			end
		--end
		if private.teste == true then
			love.graphics.print("whoo",0,120)
		end
		love.graphics.circle("line", private.stick.x,private.stick.y,private.stick.r)
	end
	
	
	return public
end