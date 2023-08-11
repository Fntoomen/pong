_G.love = require("love")

-- Save copied tables in `copies`, indexed by original table.
function deepcopy(orig, copies)
	copies = copies or {}
	local orig_type = type(orig)
	local copy
	if orig_type == 'table' then
		if copies[orig] then
			copy = copies[orig]
		else
			copy = {}
			copies[orig] = copy
			for orig_key, orig_value in next, orig, nil do
				copy[deepcopy(orig_key, copies)] = deepcopy(orig_value, copies)
			end
			setmetatable(copy, deepcopy(getmetatable(orig), copies))
		end
	else -- number, string, boolean, etc
		copy = orig
	end
	return copy
end

width, height = love.graphics.getDimensions( )
ball = {
	mode = "fill",
	x = width/2,
	y = height/2,
	radius = 20,
	vel = {x=10, y=1},
}


rect = {
	mode = "fill",
	x = 0,
	y = height/2,
	width = 10,
	height = 80,
}

rect2 = deepcopy(rect)
rect2.x = width-rect2.width

function love.load()
	love.graphics.setBackgroundColor(204 / 255, 255 / 255, 153 / 255)
	love.graphics.setColor(0 / 255, 153 / 255, 90 / 255)
end

function love.update(dt)
	if love.keyboard.isDown("w") then
		rect.y = rect.y - 5
	end
	if love.keyboard.isDown("s") then
		rect.y = rect.y + 5
	end

	if love.keyboard.isDown("up") then
		rect2.y = rect2.y - 5
	end
	if love.keyboard.isDown("down") then
		rect2.y = rect2.y + 5
	end

	ball.y = ball.y + ball.vel.y
	ball.x = ball.x + ball.vel.x

	if ball.x <= 0+rect.width + ball.radius and ball.y >= rect.y-rect.height/2-ball.radius and ball.y <= rect.y+rect.height/2+ball.radius then
		ball:bounce(-1, 1)
		ball.x = ball.x + 10
	end
	if ball.x >= width-rect2.width - ball.radius and ball.y >= rect2.y-rect2.height/2-ball.radius and ball.y <= rect2.y+rect2.height/2+ball.radius then
		ball:bounce(-1, 1)
		ball.x = ball.x - 10
	end
	if ball.x <= -width or ball.x >= width then
		ball:reset()
	end
	if ball.y <= -height*1.5 or ball.x >= height*1.5 then
		ball:reset()
	end
end

function ball:bounce(x, y)
	self.vel.x = x * self.vel.x
	self.vel.y = y * self.vel.y
end

function ball:reset()
	ball.x = 300
	ball.y = 200
	ball.vel = {}
	ball.vel.x = 3
	ball.vel.y = 1
	ball.height = 30
	ball.width = 30
end

function love.draw()
	love.graphics.rectangle(rect.mode, rect.x, rect.y, rect.width, rect.height)
	love.graphics.rectangle(rect2.mode, rect2.x, rect2.y, rect2.width, rect2.height)
	love.graphics.circle(ball.mode, ball.x, ball.y, ball.radius)
end
