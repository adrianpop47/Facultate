def suma_submatrice(matrice, pereche):
    suma = 0
    x0 = pereche[0][0]
    y0 = pereche[0][1]
    x1 = pereche[1][0]
    y1 = pereche[1][1]
    for i in range(x0, x1+1):
        for j in range(y0, y1+1):
            suma += matrice[i][j]
    return suma

def main():
    matrice = [[0,2,5,4,1],
               [4,8,2,3,7],
               [6,3,4,6,2],
               [7,3,1,8,3],
               [1,5,7,9,4]]
    perechi = [((1,1), (3,3)), ((2, 2),(4, 4))]
    for pereche in perechi:
        print(suma_submatrice(matrice, pereche))

main()