def main():
    text = "ana are ana are mere rosii ana"
    lista_text = text.split(' ')
    cuvinte_unice = []
    for i in range(len(lista_text)):
        if lista_text[i] not in lista_text[0:i]:
            if lista_text[i] not in lista_text[i+1:]:
                cuvinte_unice.append(lista_text[i])
    print(cuvinte_unice)

main()