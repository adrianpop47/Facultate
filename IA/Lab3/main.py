from random import randint
from tkinter.tix import MAX

import numpy as np
import networkx as nx
import matplotlib.pyplot as plt
import warnings

from GA import GA

def read(fileName):
    if fileName == 'karate.gml':
        G = nx.read_gml(fileName, label='id')
    else:
        G = nx.read_gml(fileName)
    net = {}
    net['noNodes'] = nx.number_of_nodes(G)
    net['noEdges'] = nx.number_of_edges(G)
    net['mat'] = nx.to_numpy_array(G)
    nodes = nx.nodes(G)
    degrees = []
    for i in nodes:
        d = nx.degree(G, i)
        degrees.append(d)
    net['degrees'] = degrees
    return net

def communities(repres):
    communities = []
    for c in repres:
        if c not in communities:
            communities.append(c)
    return len(communities)

network = read('polbooks.gml')
ga = GA(100, network)
ga.initialisation()
ga.evaluation()
for generation in range(1, 101):
    ga.oneGeneration()
    bestChromosome = ga.bestChromosome()
    print(str(generation) + " : " + str(bestChromosome.repres) + " Number of communities: " + str(communities(bestChromosome.repres)) + " f(x) = " + str(bestChromosome.fitness))

