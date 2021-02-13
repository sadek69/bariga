
local anim8 = require 'lib/anim8'
local cron = require 'lib/cron'

local image, animation

w = love.graphics.getWidth()
h = love.graphics.getHeight()




back = {}
back.pic = {}
back.pic[1] = love.graphics.newImage("gfx/priezd.png")--hack poslednaja kartinka ne budet otobazatsja
back.x = 0
back.y = 0
back.number = 0

car1 = {}
  car1.x= -20
  car1.y= 350
  car1.pic= love.graphics.newImage("gfx/car1.png")
  car1.timer = cron.every(0.01, function() car1.x = car1.x + 1 end)

car2 = {}
  car2.x= 600
  car2.y= 300
  car2.k= 1
  car2.pic= love.graphics.newImage("gfx/car2.png")
  car2.timer = cron.every(0.01, function() car2.x = car2.x - 1 end)

pers1 = {}
  pers1.x = 300
  pers1.y = 230
  pers1.state = 's'  --gr -goright,s-stay,gl-goleft,gd,gt,inc - incar
  pers1.picgoright = love.graphics.newImage('gfx/pers1rightv3.png')
  pers1.goright =  anim8.newGrid(32,49, pers1.picgoright:getWidth(), pers1.picgoright:getHeight())
  pers1.animationgoright = anim8.newAnimation(pers1.goright('1-9',1), 0.1)
  pers1.picgoleft = love.graphics.newImage('gfx/pers1left4.png')
  pers1.goleft = anim8.newGrid(32,49, pers1.picgoleft:getWidth(), pers1.picgoleft:getHeight())
  pers1.animationgoleft = anim8.newAnimation(pers1.goleft('1-7',1), 0.1)
  pers1.frontpic = love.graphics.newImage('gfx/front2.png')
  pers1.picgotop = love.graphics.newImage('gfx/pers1gotop.png')
  pers1.gotop = anim8.newGrid(32,49, pers1.picgotop:getWidth(), pers1.picgotop:getHeight())
  pers1.animationgotop = anim8.newAnimation(pers1.gotop('1-3',1), 0.15)
  pers1.picgodown = love.graphics.newImage('gfx/pers1godown.png')
  pers1.godown = anim8.newGrid(32,49, pers1.picgodown:getWidth(), pers1.picgodown:getHeight())
  pers1.animationgdown = anim8.newAnimation(pers1.godown('1-3',1), 0.15)
  pers1.speed = 15

  pers2 = {}
  pers2.x= 4
  pers2.y= 245
  pers2.picgoright = love.graphics.newImage('gfx/pers1rightv33.png')
  pers2.goright =  anim8.newGrid(32,49, pers1.picgoright:getWidth(), pers1.picgoright:getHeight())
  pers2.animationgoright = anim8.newAnimation(pers1.goright('1-9',1), 0.1)
  pers2.picgoleft = love.graphics.newImage('gfx/pers1left44.png')
  pers2.goleft = anim8.newGrid(32,49, pers1.picgoleft:getWidth(), pers1.picgoleft:getHeight())
  pers2.animationgoleft = anim8.newAnimation(pers1.goleft('1-7',1), 0.1)
  pers2.state = 's'  --gr -goright,s-stay,gl-goleft,gd,gt,inc - incar
  pers1.speed = 15
  pers2.timer = cron.every(0.04, function() pers2.x = pers2.x + 1 end)



function pers1.update(dt)

    if love.keyboard.isDown('q') then love.event.quit() end

    pers1.animationgoright:update(dt)
    pers1.animationgoleft:update(dt)
    pers1.animationgotop:update(dt)
    pers1.animationgdown:update(dt)

    pers2.animationgoright:update(dt)

    car1.timer:update(dt)
    if car1.x >= 600 then car1.x = -20 end
    car2.timer:update(dt)
    if car2.x <= -20 then car2.x = 600 end
    pers2.timer:update(dt)
    if pers2.x >= 600 then pers2.x = -20 end

    --upravlenie rabotaet tolko togda kogda pasazir ne v marwrutke
     if love.keyboard.isDown('left') and pers1.state ~= 'inc' then
       pers1.state = 'gl'
       pers1.x=pers1.x - (pers1.speed * dt)
     elseif love.keyboard.isDown('right') and pers1.state ~= 'inc' then
       pers1.state = 'gr'
       pers1.x = pers1.x + (pers1.speed * dt)
     elseif love.keyboard.isDown('up') and pers1.state ~= 'inc' then
       pers1.state = 'gt'
       pers1.y=pers1.y - (pers1.speed*dt)
     elseif love.keyboard.isDown('down') and pers1.state ~= 'inc' then
       pers1.state = 'gd'
       pers1.y=pers1.y + (pers1.speed*dt)
     else pers1.state = 's' end
     --ograni4enija po peredvizeniju personaza na pervom ekrane! i smena smena statusa na kiosk
     if pers1.x <= 0 then pers1.x=pers1.x+1 end
     if pers1.x >= w-20 then pers1.x=pers1.x-1 end
     if pers1.y >= 252 then pers1.y=pers1.y-1 end--285
     if pers1.y <= 242 then pers1.y=pers1.y+1 end--275
     if pers1.y > 242 and pers1.y < 248 and pers1.x < 194 and pers1.x > 188 then game.state = 'kiosk' end
     --upravlenie bakgroundom
     if game.state == 'start' then
       back.number = 1
       pers2.state = 'gr'
     end

end

function pers1.draw()

  love.graphics.draw(back.pic[back.number],back.x,back.y)
  if pers1.state == 'gr' then pers1.animationgoright:draw(pers1.picgoright,pers1.x,pers1.y)
  elseif pers1.state == 'gl' then pers1.animationgoleft:draw(pers1.picgoleft,pers1.x,pers1.y)
  elseif pers1.state == 'gt' then pers1.animationgotop:draw(pers1.picgotop,pers1.x,pers1.y)
  elseif pers1.state == 'gd' then pers1.animationgdown:draw(pers1.picgodown,pers1.x,pers1.y)
  elseif pers1.state == 'inc' then game.state = 'drive' --zapuskaem backgrounda peremewenie
  else love.graphics.draw(pers1.frontpic,pers1.x,pers1.y) end
  if pers2.state == 'gr' then pers2.animationgoright:draw(pers2.picgoright,pers2.x,pers2.y) end
  love.graphics.draw(car2.pic,car2.x,car2.y)
  love.graphics.draw(car1.pic,car1.x,car1.y)

end
