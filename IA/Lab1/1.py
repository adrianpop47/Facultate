def last_alphabetical_word(text):
    last_word = text[0].lower()
    for word in text:
        if last_word < word.lower():
            last_word = word.lower()
    return last_word

def main():
    text = "Ana are mere rosii si galbene"
    text_array = text.split(' ')
    print(last_alphabetical_word(text_array))

main()

