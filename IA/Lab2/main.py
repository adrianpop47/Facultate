import itertools

n = 0
matrix = []
source = 0
destination = 0
solution = []



def read():
    global n, matrix, source, destination
    f = open("input.txt")
    n = int(f.readline())
    for i in range(n):
        line = [int(distance) for distance in f.readline().strip().split(',')]
        matrix.append(line)
    source = int(f.readline())
    destination = int(f.readline())
    f.close()


def shortest_path(current, destinations):
    minimum = 999999999
    closest_destination = -1
    for d in destinations:
        distance = matrix[current][d]
        if distance < minimum:
            minimum = distance
            closest_destination = d
    return closest_destination


def find_way(current, destinations, end):
    solution.append(current)
    destinations.remove(current)
    next_destination = shortest_path(current, destinations)
    if current == end and end != -1:
        return
    if destinations:
        find_way(next_destination, destinations, end)


def second_solution():
    global solution
    destinations = []
    for i in range(n):
        destinations.append(i)
    find_way(destination - 1, destinations, source - 1)
    solution.reverse()
    solution_distance = calculate_distance(solution)
    for i in range(len(solution)):
        solution[i] += 1
    print(len(solution))
    print(solution)
    print(solution_distance)

def calculate_distance(destinations):
    distance = 0
    for i in range(len(destinations)-1):
        distance += matrix[destinations[i]][destinations[i+1]]
    return distance


def first_solution():
    global solution
    destinations = []
    for i in range(n):
        destinations.append(i)
    find_way(0, destinations, -1)

    solution_distance = calculate_distance(solution)
    solution_distance += matrix[0][solution[len(solution)-1]]
    for i in range(len(solution)):
        solution[i] += 1
    print(solution)
    print(solution_distance)
    solution = []


def main():
    read()
    first_solution()
    second_solution()


main()
