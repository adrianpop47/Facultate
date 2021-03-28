def main():
    sir = [1,2,3,4,2]
    sir.sort()
    for i in range(len(sir)):
        if sir[i] == sir[i+1]:
            print(sir[i])
            break

main()