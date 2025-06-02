def print_intro():
    intro = ("Welcome to the Wolving compound interest calculator. \nThis program calculates your potential returns when you invest with us.")
    print(intro)
    return intro

def get_input():
        principal = int(input ("How much would you like to invest?"))
        rate = float(input("What is the interest rate on your account as a percentage?")) / 100
        #Converts amount to decimal as well
        years = int(input("How long are you planning to invest?"))
        return principal, rate, years


def simple_interest(principal, rate, years):
        simple_output = principal * (1 + (rate * years))
        print('£' +str(principal) +' invested at ' +str(rate * 100) +'%'+ ' for ' + str(years)+' years ' + ' is: ' +'£'+ str(simple_output))
        return simple_output

def compound_interest(principal, rate, years):
        compound_output = principal * ((1 + rate / 4)**(4*years))
        print('£' + str(principal) + ' invested at ' + str(rate * 100) + '% ' + ' for '  + str(years)+' years '+' compounded ' + str(4) + ' times a year is: '+'£' +str(round(compound_output, 2 )))
        return compound_output

def print_simple_output(principal, rate, years, result):
        Var = (round(simple_interest(principal, rate, years),2))

        return Var

def print_compounding_output(principal, rate, years, result):
        riable = (round(compound_interest(principal, rate, years), 2))

        return riable


def main():

        print_intro()
        principal, rate, years = get_input()
        simple_output = simple_interest(principal, rate, years)
        compounding_output = compound_interest(principal, rate, years)


if __name__ == '__main__':
        main()