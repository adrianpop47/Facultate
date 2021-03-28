def produs_scalar(v1, v2):
    produs = 0
    for i in range(max(len(v1), len(v2))):
        produs = produs + v1[i] * v2[i]
    return produs

def main():
    v1 = [1,0,2,0,3]
    v2 = [1,2,0,3,1]
    print(produs_scalar(v1, v2))

main()