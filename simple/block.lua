block = {}

function block.new(x, y,w,h, name)
	local self = {}
	self.x = x
	self.y = y
	self.h = h
	self.w = w
	self.name = name
	world1:add(self.name, self.x, self.y, self.w, self.h)
	
	function self.draw()
		love.graphics.rectangle("fill", self.x+camera.x, self.y+camera.y, self.w, self.h)
	end
	
	return self
end