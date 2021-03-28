def decimal_binar(n):
    return bin(n).replace("0b", "")

def main():
    n = 4
    for i in range(n):
        print(decimal_binar(i+1))

main()