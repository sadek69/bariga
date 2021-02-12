

 --narisovat ese lica ese 6 raznih
 
-- problemi vse cerez intefeis  klienta  cerez genraciju redkih chisel item

--generator problem


local start = require 'pers1'
local general = require 'kiosk'

function love.load()

  game = {}
  game.state = 'start'--,'kiosk' sostoanie igri

end

function love.update(dt)

  if game.state == 'start' then
     pers1.update( dt )
  elseif game.state == 'kiosk' then
    kiosk.update( dt )
    if love.keyboard.isDown('escape') then
        pers1.y = 270
        pers1.x = 60
        game.state = 'start'
    end
  end

end

function love.draw()

  if game.state == 'start' then
    pers1.draw()
  elseif game.state == 'kiosk' then
    kiosk.draw()
  end



end
