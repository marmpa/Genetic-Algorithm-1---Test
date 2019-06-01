local GA = require("geneticsClass")

function love.load()
  math.randomseed(os.time())--Setting random seed
  dtotal = 10

  positionX = math.random(1,10)
  positionY = math.random(1,10)
  startingLocation = {positionX,positionY}
  endLocation = {5,6}

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
  tmp = GA:new(arrayLength,arrayLength,startingLocation,endLocation)
  --tmp:SetMaxDistance(arrayLength,arrayLength)


end

function love.update(dt)
  dtotal = dtotal + dt
  if(dtotal>=1) then
    tmp:Fitness()
    --love.event.quit(0)

    for i,v in ipairs(tmp.currentLocations) do --Explore through all the population
      --love.graphics.rectangle("fill", v[1]*scale, v[2]*scale, scale, scale)
      print(i,"-",v[1],v[2])
    end
    --love.event.quit(0)
    dtotal=0
  end
end

function love.draw()
  for i,v in ipairs(t) do
    for k,j in ipairs(v) do
      love.graphics.rectangle("line", i*scale, k*scale, scale, scale)
    end
  end


  love.graphics.setColor(1,0.5,0.5)
  love.graphics.rectangle("fill", positionX*scale, positionY*scale, scale, scale)
  love.graphics.rectangle("fill", endLocation[1]*scale, endLocation[1]*scale, scale, scale)

  love.graphics.print(tmp:CalculateDistance(positionX,positionY,5,6))

  love.graphics.setColor(0.5,1,0.5)
  for i,v in ipairs(tmp.currentLocations) do --Explore through all the population
    love.graphics.rectangle("fill", v[1]*scale, v[2]*scale, scale, scale)

  end



end

function love.keypressed(key, scancode, isrepeat)
  if(key=="space") then
    positionX = math.random(1,10)
    positionY = math.random(1,10)
  elseif(key=="a") then
    table.sort(tmp.finalAnswers,function(a,b) return a[2] > b[2] end)
    file = love.filesystem.newFile("data.txt")
    file:open("w")

    file:write("Starting Location: "..tmp.startingLocation[1].." "..tmp.startingLocation[2].." endLocation:"..tmp.endLocation[1]..tmp.endLocation[2].."\n")

    for i,v in ipairs(tmp.finalAnswers) do
      file:write("Fitness Score: "..tostring(v[2]).." PositionSolved:"..v[3].."\n")
      for j,k in ipairs(v[1]) do
        file:write(tostring(k).." ")
      end
      file:write("\n\n")
    end

    file:close()
    love.event.quit(0)
  end

end
