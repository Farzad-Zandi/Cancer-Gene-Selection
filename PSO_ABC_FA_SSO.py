## Farzad Zandi, Mohamad Goodarzi, 2023.
# Gene selection using meta-heurestic methods for prostate cancer diagnosis.
import math
import csv
import numpy as np
import pandas as pd
from sklearn import preprocessing
from mealpy.swarm_based import PSO, ABC, FA, SSO
from sklearn.neighbors import KNeighborsClassifier as knn
from sklearn.model_selection import KFold, cross_val_score

## Loading data.
print("=========================================")
print("Farzad Zandi, Mohammad Goodarzi, 2023...")
print("Gene selection using meta-heurestic methods for prostate cancer diagnosis...")
print("Loading data...")
data = pd.read_csv("data/prostate.csv", header= None)
N = data.shape[1]-1
label = data.iloc[:,N]
data = data.drop(data.columns[N], axis=1)
print("Data dimension: ", data.shape)
N = N-1

## Main Code.
def amend_position(position, lower, upper):
    for j in range(N):
        if np.random.random() < 1/(1+math.exp(-position[j])):
            position[j] = int(1)
        else:
            position[j] = int(0)
    return position

def fitness_function(solution):
    idx = np.flatnonzero(solution)
    cv = KFold(n_splits=5, random_state=0, shuffle=True)
    clf = knn(n_neighbors=3)
    acc = cross_val_score(clf, data[:,idx], label, scoring='accuracy', cv=cv)
    acc = 0.7*np.mean(acc) + (1-0.7)*(1-(np.sum(solution)/N))
    return np.mean(acc)

problem = {"fit_func" : fitness_function,
           "minmax" : 'max',
           'lb' : [-1, ] * N,
           'ub' : [1, ] * N,
           "amend_position" : amend_position}

term_dict = {'max_early_stop' : 30}

methods = {'PSO', 'BA', 'FA', 'SSA'}
results = []
numCols = []

## Original PSO.
# print("-------------------------------------------------------------------")
# print('Feature selection by original particle swarm optimization algorithm...')
# model = PSO.OriginalPSO(epoch=100, pop_size=20)
# for i in range(10):
#     best_position, best_fitness = model.solve(problem, termination=term_dict)
#     print(f"Accuracy in iteration {i+1} is {best_fitness} with {np.sum(best_position)} gene")
#     results.append(best_fitness)
#     numCols.append(int(np.sum(best_position)))

## Original ABC.
# print("-------------------------------------------------------------")
# print('Feature selection by Original artificial bee colony algorithm...')
# for i in range(10):
#     model = ABC.OriginalABC(epoch=100, pop_size=20)
#     best_position, best_fitness = model.solve(problem, termination=term_dict)
#     print(f"Accuracy in iteration {i+1} is {best_fitness} with {np.sum(best_position)} gene")
#     results.append(best_fitness)
#     numCols.append(int(np.sum(best_position)))

## Original FA.
# print("-----------------------------------------------")
# print('Feature selection by Original firefly algorithm...')
# for i in range(10):
#     model = FA.OriginalFA(epoch=100, pop_size=20)
#     best_position, best_fitness = model.solve(problem, termination=term_dict)
#     print(f"Accuracy in iteration {i+1} is {best_fitness} with {np.sum(best_position)} gene")
#     results.append(best_fitness)
#     numCols.append(int(np.sum(best_position)))

## Original SSO.
print("-----------------------------------------------------")
print('Feature selection by Original social spider algorithm...')
for i in range(10):
    model = SSO.OriginalSSO(epoch=100, pop_size=20)
    best_position, best_fitness = model.solve(problem, termination=term_dict)
    print(f"Accuracy in iteration {i+1} is {best_fitness} with {np.sum(best_position)} gene")
    results.append(best_fitness)
    numCols.append(int(np.sum(best_position)))

results.to_csv('Accuracy.csv')
numCols.to_csv('selectedGenes.csv')