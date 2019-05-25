local GA = require("geneticsClass")

function love.load()
  --Creating a 2d array
  arrayLength=10
  t = {}
  for i=1,arrayLength do
    t[i] = {}
    for k=1,arrayLength do
      t[i][k]=0
    end
  end
  --..................
  scale = 30
  tmp = GA:new()

  positionX = math.random(1,10)
  positionY = math.random(1,10)
end

function love.update()

end

function love.draw()
  for i,v in ipairs(t) do
    for k,j in ipairs(v) do
      love.graphics.rectangle("line", i*scale, k*scale, scale, scale)
    end
  end

  love.graphics.rectangle("fill", positionX*scale, positionY*scale, scale, scale)
  love.graphics.rectangle("fill", 5*scale, 6*scale, scale, scale)

  love.graphics.print(tmp:CalculateDistance(positionX,positionY,5,6))
end

function love.keypressed(key, scancode, isrepeat)
  if(key=="space") then
    positionX = math.random(1,10)
    positionY = math.random(1,10)
  end

end
