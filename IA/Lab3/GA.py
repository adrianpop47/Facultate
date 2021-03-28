from random import randint

from RealChromosome import Chromosome


class GA:
    def __init__(self, popSize=None, problParam=None):
        self.__popSize = popSize
        self.__problParam = problParam
        self.__population = []

    @property
    def population(self):
        return self.__population

    def initialisation(self):
        for _ in range(0, self.__popSize):
            c = Chromosome(self.__problParam)
            self.__population.append(c)

    def evaluation(self):
        for c in self.__population:
            c.fitness = self.modularity(c.repres, self.__problParam)

    def bestChromosome(self):
        best = self.__population[0]
        for c in self.__population:
            if (c.fitness < best.fitness):
                best = c
        return best

    def worstChromosome(self):
        best = self.__population[0]
        for c in self.__population:
            if (c.fitness > best.fitness):
                best = c
        return best

    def selection(self):
        pos1 = randint(0, self.__popSize - 1)
        pos2 = randint(0, self.__popSize - 1)
        if (self.__population[pos1].fitness < self.__population[pos2].fitness):
            return pos1
        else:
            return pos2

    def oneGeneration(self):
        newPop = []
        for _ in range(self.__popSize):
            p1 = self.__population[self.selection()]
            p2 = self.__population[self.selection()]
            off = p1.crossover(p2)
            off.mutation()
            newPop.append(off)
        self.__population = newPop
        self.evaluation()

    def oneGenerationElitism(self):
        newPop = [self.bestChromosome()]
        for _ in range(self.__popSize - 1):
            p1 = self.__population[self.selection()]
            p2 = self.__population[self.selection()]
            off = p1.crossover(p2)
            off.mutation()
            newPop.append(off)
        self.__population = newPop
        self.evaluation()

    def oneGenerationSteadyState(self):
        for _ in range(self.__popSize):
            p1 = self.__population[self.selection()]
            p2 = self.__population[self.selection()]
            off = p1.crossover(p2)
            off.mutation()
            off.fitness = self.modularity(off.repres, self.__problParam)
            worst = self.worstChromosome()
            if (off.fitness < worst.fitness):
                worst = off

    def modularity(self, communities, param):
        noNodes = param['noNodes']
        mat = param['mat']
        degrees = param['degrees']
        noEdges = param['noEdges']
        M = 2 * noEdges
        Q = 0.0
        for i in range(0, noNodes):
            for j in range(0, noNodes):
                if communities[i] == communities[j]:
                    Q += (mat[i][j] - degrees[i] * degrees[j] / M)
        return Q * 1 / M