# Coding Challenge 3, hangman.py
# Name: ALLAN FARAI MAKWEMBERE
# Student No: 2108418

# Hangman Game

# -----------------------------------
# Helper code
# You don't need to understand this helper code,
# but you will have to know how to use the functions
# (so be sure to read the docstrings!)
import random
import string

WORDLIST_FILENAME = "words.txt"

# Responses to in-game events
# Use the format function to fill in the spaces
responses = [
    "I am thinking of a word that is {0} letters long",
    "Congratulations, you won!",
    "Your total score for this game is: {0}",
    "Sorry, you ran out of guesses. The word was: {0}",
    "You have {0} guesses left.",
    "Available letters: {0}",
    "Good guess: {0}",
    "Oops! That letter is not in my word: {0}",
    "Oops! You've already guessed that letter: {0}",
]

def choose_random_word(all_words):
    return random.choice(all_words)

# end of helper code
# -----------------------------------


def load_words():
    # TODO: Fill in your code here
    print ('Loading wordlist from file: words.txt')
    input_file = open(WORDLIST_FILENAME, 'r')
    for l in input_file:
        wordlist = l.split()
        #wordlist = set(wordlist)
    input_file.close()

    print(str(len(wordlist)) + ' words loaded')
    return wordlist


# Load the list of words into the variable wordlist
# Accessible from anywhere in the program
# TODO: uncomment the below line once
# you have implemented the load_words() function
wordlist = load_words()
#wordlist = load_words()

def is_word_guessed(word, letters_guessed):
    # TODO: Fill in your the code here
    pos = 0
    for x in word:
        if x in letters_guessed:
            pos += 1
    return pos == len(word)






def get_guessed_word(word, letters_guessed):
    output = ""
    for i in range(0, len(word)):
        flag = True
        for k in range(0, len(letters_guessed)):
            if word[i] == letters_guessed[k]:
                flag = False
                output += letters_guessed[k]
                break
        if flag:
            output += "_ "
    return str(output)





def get_remaining_letters(letters_guessed):
    # TODO: Fill in your code here
    from string import ascii_lowercase
    Unguessed = list(ascii_lowercase)
    Alphabet = Unguessed
    def remainingletters(X, Y,):
        stored = X
        letters = Y
        for y in X:
            if y in stored:
                if y in Y:
                    Y.remove(y)
        return ''.join(str(y) for y in Y)
    return remainingletters(letters_guessed, Alphabet)

def hangman(word):
    score = 0
    from string import ascii_letters
    all_chars=list(ascii_letters)
    print("Hello! Welcome to Hangman Ultimate Edition")

    print("I am thinking of a word that is " + str(len(word)) + " letters long")
    print(" _ " * 7)
    word_guessed = False
    num=len(word)
    letters_guessed = " _ " * num
    tries = 6

    while tries > 0:
        print()
        if word == get_guessed_word(word, letters_guessed):
            word_guessed = True
            break
        print("You have " + str(tries) + " guesses left")
        print("Available letters: " + get_remaining_letters(letters_guessed))

        guess=input("Please guess a letter : ").lower()
        while len(guess) != 1 :
            print("Please enter a single letter")
            guess=input("Please guess a letter : ").lower()
        while guess not in all_chars:
            print("please enter a letter only")
            guess=input("Please guess a letter : ").lower()
        if guess in word:
            if guess in letters_guessed:
                print("Oops! You've already guessed that letter : " + get_guessed_word(word, letters_guessed))
                print("_ "*7)
            else:
                letters_guessed += guess
                print("Great guess :" + get_guessed_word(word, letters_guessed))
                print("_ "*7)
        else:
            if guess in letters_guessed:
                print("Oops! You've already guessed that letter: " + get_guessed_word(word, letters_guessed))
                print("_ "*7)
            else:
                letters_guessed += guess
                if guess in ["a", "e", "i", "o", "u"]:
                    tries -= 2
                else:
                    tries -= 1
                print("Oops! That letter is not in my word: " + get_guessed_word(word, letters_guessed))
                print("_ "*7)

    if word_guessed:
       print("Congratulations, you won!")
       score= len(set(word))* tries
       print("Your total score for this game is : " + str(score))
    elif tries == 0:
       print("Sorry, you ran out of guesses. The word was: " + word)


    # TODO: Fill in your code here


# ---------- Challenge Functions (Optional) ----------

def get_score(name):
    pass

def save_score(name, score):
    pass



# When you've completed your hangman function, scroll down to the bottom
# of the file and uncomment the last lines to test
# (hint: you might want to pick your own
# word while you're doing your own testing)


# -----------------------------------

def main():
    # Uncomment the line below once you have finished testing.
    word = choose_random_word(wordlist)

    # Uncomment the line below once you have implemented the hangman function.
    # hangman(word)
    load_words()
    hangman(word)

# Driver function for the program
if __name__ == "__main__":
    main()
