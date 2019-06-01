local Class = require("lib/middleclass")
local Chromosome = require("chromosome")
local GA = Class("GA")

local directions = {["up"]={0,-1},["down"]={0,1},["left"]={-1,0},["right"]={1,0}}--the choices each gene can take

local populationSize = 100--Population size

function GA:initialize(arrayLengthX,arrayLengthY,startingLocation,endLocation)
  self:SetMaxDistance(arrayLengthX,arrayLengthY)

  self.startingLocation=startingLocation
  self.endLocation=endLocation
  self.geneLength = arrayLengthX--The length of genes
  self.currentLocations = {}--The location of the childs
  self.bounds = arrayLengthX
  self.finalAnswers = {}


  self.population = self:Reinitialize()--Sets new table childs
end

function GA:Reinitialize()--Initializes all childs
  newGeneration = {}
  for i=1,populationSize do
    table.insert(newGeneration,Chromosome:new(self.geneLength))--arrayLength is how long the chromosome is

  end

  return newGeneration
end

function GA:Fitness()
  --Finds fitness of all population
  print(self.startingLocation[1],self.startingLocation[2],"Starting location")
  local currentFitness = {}
  local newGeneration = {}--The generation that follows

  for i,v in ipairs(self.population) do--Search through all population
    local projectedLocation = table.clone(self.startingLocation)
    local tempFitness = 0
    local gotOutsideOfBounds = false
    print(projectedLocation[1],"projectedLocationXBef")
    print(projectedLocation[2],"projectedLocationYBef")
    for j,k in ipairs(v.genes) do -- Add all

      projectedLocation[1] = projectedLocation[1] + directions[k][1]
      projectedLocation[2] = projectedLocation[2] + directions[k][2]


      if(projectedLocation[1]<1 or projectedLocation[1]>self.bounds) then--Punish in case out of bounds
        tempFitness = tempFitness - (0.1 * self.maxDistance)
        gotOutsideOfBounds = true--Sets flag for if got outside of bounds
      end
      if(projectedLocation[2]<1 or projectedLocation[2]>self.bounds) then--Punishment
        tempFitness = tempFitness - (0.1 * self.maxDistance)
        gotOutsideOfBounds = true--Sets flag for if got outside of bounds
      end

      if(self:CompareVectorLocations(projectedLocation,endLocation)) then--Gives bigger score in case it finds path sooner or just finds the path
        tempFitness = tempFitness + (0.2 * self.maxDistance)*(self.geneLength-j+1)--Multiply the maxScore with .1 and multiply that by how fast it found

        table.insert(self.finalAnswers,{table.clone(v.genes),tempFitness,j})
        break
      end
    end

    print(projectedLocation[1],"projectedLocationXAF")
    print(projectedLocation[2],"projectedLocationYAF\n")


    tempFitness=tempFitness + self.maxDistance-self:CalculateDistance(projectedLocation[1],projectedLocation[2],endLocation[1],endLocation[2])
    if(projectedLocation[1]<1 or projectedLocation[1]>self.bounds) then--Punish in case out of bounds
      tempFitness = 0
    end
    if(projectedLocation[2]<1 or projectedLocation[2]>self.bounds) then--Punish in case out of bounds
      tempFitness = 0
    end

    print(tempFitness,"FAT")

    if(not gotOutsideOfBounds) then--Add to table only if it stayed inside table
      table.insert(currentFitness,{tempFitness,v,projectedLocation })
    end
    print("AFter fat")


  end


  --TODO Make currentFitness contain parent

  table.sort(currentFitness,function(a,b) return a[1]>b[1] end)--Reverses the table e.g 5,4,3,2,1
  --print(currentFitness[1][1],currentFitness[10][1])
  print("End of loop")

  --In case none found do nothing
  if(#currentFitness==0) then
    newGeneration = self:Reinitialize()
    self.population = newGeneration
    print("Choice 1------------")
    return

  elseif(#currentFitness<4) then--Second option if there are three or all less take them all
    print("Choice 2------------")
    table.insert(newGeneration,currentFitness[1][2])

    local safeValue = 10
    for i,v in ipairs(currentFitness) do
      parent1 = currentFitness[math.random(math.floor(#currentFitness))][2]

      repeat -- So it does not choose same thingie
        parent2 = currentFitness[math.random(math.floor(#currentFitness))][2]
        safeValue = safeValue-1
      until (parent2 ~= parent1 or safeValue<=0)

      child = parent1:Mate(parent2)--New child
      table.insert(newGeneration,child)
    end

    --Inserts new childs
    currentGenPopulation = #newGeneration
    for i=currentGenPopulation,populationSize-1 do
      table.insert(newGeneration,Chromosome:new(self.geneLength))
    end
    print("After Choice 2------------")

  else--Any other case
    print("Choice 3------------")
    for i=1,math.floor(#currentFitness*0.1) do--Gets 10% of things
      table.insert(newGeneration,currentFitness[i][2])
    end


    for i=1,math.floor(#currentFitness*0.9) do--For the rest 50% of the population mates

      parent1 = currentFitness[math.random(math.floor(#currentFitness*0.5))][2]

      repeat -- So it does not choose same thingie
        parent2 = currentFitness[math.random(math.floor(#currentFitness*0.5))][2]
      until (parent2 ~= parent1)

      child = parent1:Mate(parent2)
      table.insert(newGeneration,child)
    end

    currentGenPopulation = #newGeneration
    for i=currentGenPopulation,populationSize-1 do
      table.insert(newGeneration,Chromosome:new(self.geneLength))
      print("CHoice 3 inserted:",populationSize-1-currentGenPopulation," more")
      print("There were ",#currentFitness," In this generation")
    end
    print("After Choice 3------------")
  end


  print("After dat end of dat loop")

  self.population = newGeneration--Sets population to new Generation
  --Print genes
  --for i=1,populationSize do
  --  print(self.population[i]:PrintGenes())
  --end


  self.currentLocations = {}

  for i,v in ipairs(currentFitness) do
    table.insert(self.currentLocations,v[3])
    print(v[3][1],v[3][2],i,"Locations")
  end

  --local  populationToMate = math.floor(#currentFitness)

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

function GA:CompareVectorLocations(table1,table2)
  --Sees if tables are equal or not
  assert(type(table1)=="table","Table 1 is not a table")
  assert(type(table2)=="table","Table 1 is not a table")

  for i,v in pairs(table1) do
    if(table1[i]~=table2[i]) then
      return false
    end
  end

  return true
end

function table.clone(org)
  return {unpack(org)}
end
return GA
