function love.load()
	
	
	hero = {}
	hero.x = 300
	hero.y = 450
	hero.width = 30
    hero.height = 15
	hero.speed = 200
	hero.shots = {}
	
	amountEnemies = 10
	killed = -1
	enemies = {}
	for i = 0,amountEnemies do
		enemy = {}
		enemy.width = 40
		enemy.height = 20
		enemy.x = i * (enemy.width + 30) + 25
		enemy.y = enemy.height + 100
		table.insert(enemies,enemy)
	end
	
	gameLost = false
	
	bg = love.graphics.newImage("bg.png")
	shootSound = love.audio.newSource("shoot.ogg", "static")
	death = love.audio.newSource("death.ogg", "static")
end

function love.keyreleased(key)
	if (key == " ") then
		shoot()
		love.audio.play(shootSound)
	end
end

function love.update(dt)
	love.audio.setVolume(0.3)
	if love.keyboard.isDown("left") then
		hero.x = hero.x - hero.speed*dt
	elseif love.keyboard.isDown("right") then
		hero.x = hero.x + hero.speed*dt
	end
	if hero.x>790 then
		hero.x=790-hero.speed*dt
	elseif hero.x<0 then
		hero.x=0+hero.speed*dt
	end
	
	local remEnemy = {}
	local remShot = {}
	
	-- update the shots
	for i,v in ipairs(hero.shots) do
	
		-- move them up up up
		v.y = v.y - dt * 100
		
		-- mark shots that are not visible for removal
		if v.y < 0 then
			table.insert(remShot, i)
		end
		
		-- check for collision with enemies
		for ii,vv in ipairs(enemies) do
			if CheckCollision(v.x,v.y,2,5,vv.x,vv.y,vv.width,vv.height) then
				
				-- mark that enemy for removal
				table.insert(remEnemy, ii)
				-- mark the shot to be removed
				table.insert(remShot, i)
				
			end
		end
		
		
		
	end
	
	
	-- remove the marked enemies
	for i,v in ipairs(remEnemy) do
		table.remove(enemies, v)
		love.audio.play(death)
		killed = killed + 1
	end
	
	for i,v in ipairs(remShot) do
		table.remove(hero.shots, v)
	end
	
	
	
	-- update those evil enemies
	for i,v in ipairs(enemies) do
		-- let them fall down slowly
		v.y = v.y + dt + 10
		
		-- check for collision with ground
		if v.y > 465 then
			gameLost = true
		end
		
	end
	
end

function love.draw()

	--draw the background image
	love.graphics.setColor(255,255,255,255)
	love.graphics.draw(bg)
	
	-- Draw the ground
	love.graphics.setColor(255,0,0,255)
	love.graphics.rectangle("fill", 0, 465, 800, 150)
	
	-- Draw the hero
	love.graphics.setColor(255,0,0,255)
	love.graphics.rectangle("fill", hero.x, hero.y, hero.width, hero.height)
	
	love.graphics.setColor(0,255,255,255)
	for i,v in ipairs(enemies) do
		love.graphics.rectangle("fill",v.x, v.y, v.width, v.height)
	end
	
	love.graphics.setColor(255,255,255,255)
	for i,v in ipairs(hero.shots) do
		love.graphics.rectangle("fill", v.x, v.y, 2, 5)
	end	
	
	love.graphics.print("Made by Jói",25,20)
	
	if gameLost == true then
		love.graphics.clear()
		love.graphics.print("You Lost \n\nGame over!",350,300)
	end
	
	if killed == amountEnemies then
		love.graphics.clear()
		love.graphics.print("You Won \n\Congratulations!",350,300)
	end
	
	
end

function shoot()
	local shot = {}
	shot.x = hero.x+hero.width/2
	shot.y = hero.y
	table.insert(hero.shots, shot)
end


function CheckCollision(ax1,ay1,aw,ah, bx1,by1,bw,bh)

  local ax2,ay2,bx2,by2 = ax1 + aw, ay1 + ah, bx1 + bw, by1 + bh
  return ax1 < bx2 and ax2 > bx1 and ay1 < by2 and ay2 > by1
end