# Coding Challenge 2
# Name: Allan Farai Makwembere
# Student No: 2108418

# A Morse code encoder/decoder

MORSE_CODE = (
    ("-...", "B"), (".-", "A"), ("-.-.", "C"), ("-..", "D"), (".", "E"), ("..-.", "F"), ("--.", "G"),
    ("....", "H"), ("..", "I"), (".---", "J"), ("-.-", "K"), (".-..", "L"), ("--", "M"), ("-.", "N"),
    ("---", "O"), (".--.", "P"), ("--.-", "Q"), (".-.", "R"), ("...", "S"), ("-", "T"), ("..-", "U"),
    ("...-", "V"), (".--", "W"), ("-..-", "X"), ("-.--", "Y"), ("--..", "Z"), (".-.-.-", "."),
    ("-----", "0"), (".----", "1"), ("..---", "2"), ("...--", "3"), ("....-", "4"), (".....", "5"),
    ("-....", "6"), ("--...", "7"), ("---..", "8"), ("----.", "9"), ("-.--.", "("), ("-.--.-", ")"),
    (".-...", "&"), ("---...", ":"), ("-.-.-.", ";"), ("-...-", "="), (".-.-.", "+"), ("-....-", "-"),
    ("..--.-", "_"), (".-..-.", '"'), ("...-..-", "$"), (".--.-.", "@"), ("..--..", "?"), ("-.-.--", "!")

)
DICTIONARY = dict(MORSE_CODE)
def print_intro():
    intro = ('Welcome to Wolmorse. \nThis program encodes and decodes Morse code.')
    print(intro)
    return intro


def get_input():
    mode = str(input('Would you like to encode(e) or decode(d):'))
    mode = mode.lower()
    while (mode != "e" or mode != "d"):


        if mode == "d":
            message = str(input('What message would you like to decode:'))
            decode(message)
            break


        if mode == "e":
            message = str(input('What message would you like to encode:'))
            message = message.upper()
            encode(message)
            break
        mode = str(input('INVALID INPUT!!\nWould you like to encode(e) or decode(d)'))
        mode = mode.lower()


    return message, mode



def encode(message):
    value = list(message)
    encode = []
    morsetranslation = ""
    for x in value:
        for i in DICTIONARY.values():
            for y in DICTIONARY.keys():
                if x in i and i in DICTIONARY[y]:
                    encode.append(y)
                    morsetranslation = ' '.join(encode)
    print('encode'+ '(' +'"' + message +'"'+ ')'+ 'is ' + morsetranslation)





def decode(message):
    morsecode = message.split(' ')
    decode = []
    translation = ""
    for x in morsecode:
        for i in DICTIONARY:
            if (x == i):
                decode.append(DICTIONARY[x])
                translation = ' '.join(decode)
    print('decode'+'('+'"'+message+'"'+')'+'is: '+translation)

def repetition():
    option = str(input('Would you like to encode/decode another message? (y/n)'))
    option = option.lower()
    while(option != 'y' or option != 'n'):
        if (option == 'y'):
            get_input()

        if (option == 'n'):
            print('Thanks for using the program, goodbye!')
            break
        option = str(input('Would you like to encode/decode another message(y/n)'))
        option = option.lower()
    return option


def main():
        print_intro()
        message, mode = get_input()
        if (mode == 'e'):
            encode(message)
        elif (mode == 'd'):
            decode(message)
        repetition()





if __name__ == '__main__':
        main()