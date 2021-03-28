def cele_mai_multe(matrice):
    max_suma = -1
    index = -1
    for i in range(len(matrice)):
        suma = 0
        for j in range(len(matrice[i])):
            suma += matrice[i][j]
        if suma > max_suma:
            max_suma = suma
            index = i
    return index



def main():
    matrice = [[0,0,0,1,1],
               [0,1,1,1,1],
               [0,0,1,1,1]]
    print(cele_mai_multe(matrice))

main()