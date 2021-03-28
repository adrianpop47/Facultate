import math

def distance(p1, p2):
    distance = math.sqrt(((p1[0] - p2[0]) ** 2) + ((p1[1] - p2[1]) ** 2))
    return distance

def main():
    p1 = [1, 5]
    p2 = [4, 1]
    print(distance(p1, p2))

main()