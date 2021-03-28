def k_maxim(sir, k):
    lista_unica = []
    sir.sort(reverse=True)
    for element in sir:
        if element not in lista_unica:
            lista_unica.append(element)
    return lista_unica[k-1]

def main():
    sir = [7,4,6,3,9,1]
    k = 2
    print(k_maxim(sir, k))

main()