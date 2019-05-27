local Class = require("lib/middleclass")
local GA = Class("GA")

function GA:initialize(arrayLengthX,arrayLengthY)
  self:SetMaxDistance(arrayLengthX,arrayLengthY)
end

function GA:Fitness()

end

function GA:CalculateDistance(x1,y1,x2,y2)
  --Calculates pythagorean distance
  distance = math.sqrt(math.pow(x2-x1, 2) + math.pow(y2-y1,2))
  return distance
end

function GA:SetMaxDistance(arrayLengthX,arrayLengthY)
  --Initiate ArrayLength so that Fitness can be calculated correctly
  assert(arrayLengthX and arrayLengthY,"Give both array length(Experimental will change later)")
  self.maxDistance = self:CalculateDistance(1,1,arrayLengthX,arrayLengthY)
end
return GA
