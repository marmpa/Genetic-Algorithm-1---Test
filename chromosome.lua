local Class = require("lib/middleclass")
local Chromosome = Class("Chromosome")

local directions = {"up","down","left","right"}--the choices each gene can take

function Chromosome:initialize(length,genes)
  self.genes = genes or self:RandomChromosome(length)

end

function Chromosome:RandomChromosome(length)
  -- Creates a new child chromosome
  childChromosome={}
  for i=1,length do
    table.insert(childChromosome,self:Mutation())
  end

  return childChromosome
end

function Chromosome:Mutation()--Returns a mutated gene
  gene = directions[math.random(#directions)]
  return gene
end

function Chromosome:Mate(parent)
  --Reproduces new offspring
  childChromosome={}
  for i=1,#self.genes do
    prob = math.random()--Propability for which gene to select

    if(prob<0.45) then--The probability of which thing the child inherits
      table.insert(childChromosome,self.genes[i])
    elseif(prob<0.9) then
      table.insert(childChromosome,parent.genes[i])
    else
      table.insert(childChromosome,self:Mutation())--Generates random thingie
    end
  end
end



return Chromosome
