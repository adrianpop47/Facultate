def majoritar(sir):
    n = len(sir)
    for element in sir:
        if sir.count(element) > n/2:
            return element

def main():
    sir = [2,8,7,2,2,5,2,3,1,2,2]
    print(majoritar(sir))

main()