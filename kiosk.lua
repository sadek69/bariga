local cron = require 'lib/cron'

local image
local utf8 = require("utf8")

w = love.graphics.getWidth()
h = love.graphics.getHeight()

beep = love.audio.newSource("/sound/hit.mp3", "static")
Font = love.graphics.newFont("/font/avantel.ttf", 18)

--perekljuchatel vibora teksta kioskera
local switchtext = 1

--pereklju4aet rezim pokupatel prodavec ili mimohod
showtext = "none"

kiosk = {}
kiosk.pic = love.graphics.newImage("gfx/kiosk.png")--hack poslednaja kartinka ne budet otobazatsja
kiosk.x = 0
kiosk.y = 0
kiosk.money = 100 --ot nulja do beskone4nosti?
kiosk.item = 10 --tovar ot nulja do beskone4nostki ?
kiosk.baditem = 0
kiosk.exp = 0 -- opit ot 0 do beskone4nostki ?
kiosk.text = {}
kiosk.text[1] = "Пошел нахуй "
kiosk.text[2] = "Отьебись"
kiosk.text[3] = "Ок"
kiosk.text[4] = "Вот держи совем новый"
kiosk.text[5] = "нет"
kiosk.text[6] = "Ну лан возму ,на держи 5$"
kiosk.text[7] = "Вот бЛин чТО ЗА ХУЙНЯ"





klient = {}
klient.x =150
klient.y = 140
klient.item = 0 --esli 0 vozvrat esli -1 ili +1 mimohod,esli -2 esli bolse 2 do 12 to prodavec esli 13 eto beda!
klient.exp = 0 --esli visokii kidaet sam esli nizkii ego mozna kinut
klient.money = 0
klient.pic = {}
klient.pic[1] = love.graphics.newImage("gfx/klient.png")
klient.pic[2] = love.graphics.newImage("gfx/klient2.png")
klient.pic[3] = love.graphics.newImage("gfx/klient3.png")
klient.pic[4] = love.graphics.newImage("gfx/klient4.png")
klient.text = {}
klient.text[1] = "Я просто посмотрю "
klient.text[2] = "Есть че? Мобилу продашь?"
klient.text[3] = "А я у вас телефон покупал,он че то неработает,посмотрите ?"
klient.text[4] = "Телефончик не нужен?Совсем новый тока что купил."
klient.text[5] = "VID забрали у вас товар и деньги.Осталось тока то что вы заныкали трусах."




timer = {}
timer.t = 0
timer.start = cron.every(6, function()--MOZET BIT PROBLEMA GENERACII NOVOGO POKUPATELJA POKA NE OBSLUZIL
   if timer.t == 0 then
     klient.item = love.math.random(-5,13)
     klient.money = love.math.random(25,225)
     klient.exp = love.math.random(1, 100)
     timer.t = 1
     picselect = love.math.random(1,4)

   end
 end
)

function kiosk.update( dt )
  --update nuzno stob dat znat sto pora zapustit novogo pokupatelja
  timer.start:update(dt)
  if love.keyboard.isDown('return') then
    timer.t = 0
    showtext = ""
    love.audio.play(beep)
    love.timer.sleep(0.3)
    if switchtext == 4 and kiosk.item > 0 then
      kiosk.money = kiosk.money + klient.money
      kiosk.item = kiosk.item - 1
      kiosk.exp = kiosk.exp + 1
    end
    --sdes delaem naeb prodaza pokupatelju polomanogo telefona esli kon4ilis horowie :)
    if switchtext == 4 and kiosk.item == 0 and kiosk.baditem > 0 then
      kiosk.money = kiosk.money + klient.money
      kiosk.baditem = kiosk.baditem - 1
      kiosk.exp = kiosk.exp + 1
    end
    --sdes prohodit pokupka telefonov dlja prodazi
    if switchtext == 6 then
      kiosk.money = kiosk.money - 5
      kiosk.exp = kiosk.exp + 1
      if love.math.random(1,2) == 1 then kiosk.item = kiosk.item + 1--sdes delaem naeb kioskera v 1/2 slu4aev.
      else  kiosk.baditem = kiosk.baditem  + 1 end
    end
    if switchtext == 7 then
      kiosk.money = 50
      kiosk.item = 0
      kiosk.exp = kiosk.exp + 10
    end


  elseif love.keyboard.isDown("up") then
    love.audio.play(beep)
    love.timer.sleep(0.3)
    switchtext=switchtext+1
  elseif love.keyboard.isDown('down')  then
    love.audio.play(beep)
    love.timer.sleep(0.3)
    switchtext=switchtext-1
  end
  --esli podvalivaet klient s item -1 do 1 eto mimohod katorii necego ne pokupaet
  if klient.money ~= 0 then
     if klient.item == -1 or klient.item == 1 then showtext = "mimohod" end
  end
  -- klient vozvrat
  if klient.money ~= 0 then
    if klient.item == 0 then showtext = "vozvrat" end
  end
  --v rezime mimohod ogranicenie fraz prodavca
  if showtext == "mimohod" then
    if switchtext > 3 then switchtext =switchtext-1 end
    if switchtext < 1 then switchtext =switchtext+1 end
  end
  --esli klient item -2 i bolse bolse minus to eto pokupatel
  if klient.item <= -2 then showtext = "pokupatel" end
  --ogranicenie fraz prodavca v rezime pokupatel
  if showtext == "pokupatel" then
    if switchtext < 4 then switchtext = switchtext+1 end
    if switchtext > 5 then switchtext = switchtext-1 end
  end
  --v rezime vozvrat ogranicenenie fraz prodavca
  if showtext == "vozvrat" then
    if switchtext > 2 then switchtext =switchtext-1 end
    if switchtext < 1 then switchtext =switchtext+1 end
  end
  --sdes opredelaem kogda budet prodavec
  if klient.item >=2 and klient.item <=12 then showtext = "prodavan" end
  --opredelaem ogranicenie fraz v rezime kogda kiosku prodajut telefon
  if showtext == "prodavan" then
    if switchtext < 5 then switchtext = switchtext+1 end
    if switchtext > 6 then switchtext = switchtext-1 end
  end
  --vipal sektor 13 sjurpiz obisk i izjatie
  if klient.item == 13 then showtext = "obisk" end
  --opredeljaem ograni4enie fraz prodavca v rezime obisk
  if showtext == "obisk" then
    if switchtext < 7 then switchtext = switchtext+1 end
    if switchtext > 7 then switchtext = switchtext-1 end
  end


end


function kiosk.draw()
  love.graphics.setFont(Font)

  love.graphics.draw(kiosk.pic,kiosk.x,kiosk.y)
  love.graphics.print(kiosk.money,w/2-10,20)
  love.graphics.print(kiosk.item,w/2+100,20)
  love.graphics.print(kiosk.baditem,w/2+200,20)

  --love.graphics.print(timer.t,170,40)
  --love.graphics.print(klient.money,170,60)
  --love.graphics.print(klient.exp,170,80)
  --love.graphics.print(klient.item,170,100)

  --love.graphics.print("switchtext : "..switchtext,170,120)
  if timer.t == 1 then love.graphics.draw(klient.pic[picselect],klient.x,klient.y) end

  --fraza klienta v rezime mimohod
  if showtext == "mimohod" then love.graphics.print("Покупатель :"..klient.text[1],80,300) end
  --otobrazenie frazi prodavca v zavisimosti ot switchtext
  if showtext == "mimohod" then love.graphics.print("Продавец : "..kiosk.text[switchtext],90,320) end
  --fraza klienta v rezime pokupatel
  if showtext == "pokupatel" then love.graphics.print("Покупатель : "..klient.text[2],80,300) end
  --otobrazenie frazi prodavca v zavisimosti ot switchtext
  if showtext == "pokupatel" then love.graphics.print("Продавец : "..kiosk.text[switchtext],90,320) end
  --fraza klienta vozvrat
  if showtext == "vozvrat" then love.graphics.print("Покупатель : "..klient.text[3],80,300) end
  --fraza prodavca vozvrat
  if showtext == "vozvrat" then love.graphics.print("Продавец : "..kiosk.text[switchtext],90,320) end
  --fraza klienta prodajushego telefon
  if showtext == "prodavan" then love.graphics.print("Покупатель : "..klient.text[4],80,300) end
  --fraza kioskera v otevet prodavanu
  if showtext == "prodavan" then love.graphics.print("Продавец : "..kiosk.text[switchtext],90,320) end
  --fraza klienta
  if showtext == "obisk" then love.graphics.print(klient.text[5],80,300) end
  --fraza prodavca
  if showtext == "obisk" then love.graphics.print("Продавец : "..kiosk.text[switchtext],90,320) end

end
