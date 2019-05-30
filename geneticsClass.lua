local Class = require("lib/middleclass")
local Chromosome = require("chromosome")
local GA = Class("GA")

local directions = {["up"]={0,1},["down"]={0,-1},["left"]={-1,0},["right"]={1,0}}--the choices each gene can take

local populationSize = 10--Population size

function GA:initialize(arrayLengthX,arrayLengthY,startingLocation,endLocation)
  self:SetMaxDistance(arrayLengthX,arrayLengthY)

  self.startingLocation=startingLocation
  self.endLocation=endLocation

  self.population = {}
  for i=1,populationSize do
    table.insert(self.population,Chromosome:new(arrayLengthX))--arrayLength is how long the chromosome is
  end
end

function GA:Fitness()
  --Finds fitness of all population

  local currentFitness = {}

  for i,v in ipairs(self.population) do--Search through all population
    local projectedLocation = self.startingLocation
    for j,k in ipairs(v.genes) do -- Add all
      projectedLocation[0] = projectedLocation[0] + directions[k][0]
      projectedLocation[1] = projectedLocation[1] + directions[k][1]
    end
    tempFitness=self.maxDistance-self:CalculateDistance(projectedLocation[0],projectedLocation[1],endLocation[0],endLocation[1])
    table.insert(currentFitness,tempFitness)

  end

  table.sort(currentFitness,function(a,b) return a>b end)--Reverses the table e.g 5,4,3,2,1

  populationToMate = math.floor(#currentFitness)

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
