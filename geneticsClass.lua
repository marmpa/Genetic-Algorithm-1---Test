local Class = require("lib/middleclass")
local GA = Class("GA")

function GA:initialize()

end

function GA:Fitness()

end

function GA:CalculateDistance(x1,y1,x2,y2)
  distance = math.sqrt(math.pow(x2-x1, 2) + math.pow(y2-y1,2))
  return distance
end

function GA:SetMaxDistance(arrayLengthX,arrayLengthY)
  self.maxDistance = self:CalculateDistance(1,1,arrayLengthX,arrayLengthY)
end
return GA
