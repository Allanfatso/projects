def warden():
    import random
    lives = 5
    warden = 10
    wardenmoves = ['he punches', 'he shield bashes', 'he stuns', 'he throws a flurry of three attacks', 'he is dazed']
    print('The final level, the obstacle before your escape, the warden readies himself to attack you. He can shield bash which needs you to dodge(d). He can punch, which needs you to block(b). He can also block some of your attacks. He can stun you with his button which requires that you hold(h) and when he is dazed you can punch(p) ')
    count = 0
    while count != 4:
        n = random.choice(wardenmoves)
        p = input(n).lower()
        if n == wardenmoves[0] and p != 'b':
            count = count + 1
            lives = lives -1
            print('You get hit. You have '+str(lives)+' lives remaining')
        elif n == wardenmoves[0] and p == 'b':
            count = count +1
            print('You block his attack')
        elif n == wardenmoves[1] and p == 'd':
            count = count +1
            print('You dodge his shield')
        elif n == wardenmoves[1] and p != 'd':
            count = count +1
            lives = lives -1
            print('He knocks you down with his shield. You have '+ str(lives) + 'lives left')
        elif n == wardenmoves[2] and p != 'h':
            count = count +1
            lives = lives -1
            print('He stuns you and a surge of electricity flows through your bones')
        elif n == wardenmoves[2] and p == 'h':
            count = count +1
            warden = warden -2
            print('You manage to hold off his stunbutton and twist it into his eye, burning through his skin.')
        elif n == wardenmoves[3] and p == 'bbb':
            count = count+1
            print('You block all his three punches')
        elif n == wardenmoves[3] and p != 'bbb':
            count = count +1
            lives = lives - 3
            print('He strikes you three times. You have '+str(lives)+' lives remaining')
        elif n == wardenmoves[4] and p != 'p':
            print('You missed an opening to strike')
        else:
            warden = warden -1
            print('You knock out a tooth out of his mouth and he smiles, enjoying the challenge, enjoying the pain')
    print('He smirks impressed by your combat skills. He switches his stance and begins to conceal his every attack.')
    while warden > 0:
        if lives < 0:
            q = input('Game over. Press key to start from this point')
        k = random.choice(wardenmoves)
        move = input('His next move is concealed, guess the appropriate response')
        if k == wardenmoves[0] and move != 'b':
            lives = lives -1
            print('he punches you. You know have '+str(lives)+ ' lives left')
        elif k == wardenmoves[0] and move == 'b':
            print('You manage to block his attack')
        elif k == wardenmoves[1] and move != 'd':
            lives = lives -1
            print('He bashes you with his shield. You have '+str(lives)+' lives left')
        elif k == wardenmoves[1] and move == 'd':
            print('You manage to dodge his shield')
        elif k == wardenmoves[2] and move == 'h':
            warden = warden -1
            print('You get hold of his stun stick and twist it to his rib, burning into his skin')
        elif k == wardenmoves[2] and move !='h':
            lives = lives -2
            print('He stuns you with his stun stick. You have '+str(lives) + ' lives left')
        elif k == wardenmoves[3] and move != 'bbb':
            lives = lives -3
            print('He unleashed a flurry of three punches and leaves you dazed. You have '+str(lives)+'lives left')
        elif k == wardenmoves[3] and move == 'bbb':
            print('You block all three of his strikes')
        elif k == wardenmoves[4] and move != 'p':
            print('You missed a chance to punch')
        else:
            lives = lives-1
            print('You manage to punch him')
    print('The guard falls before you. Its over. You jump into the ocean and escape from ALCATRAZ. YOU WON. THE END!!!')



def intro():
    key = input("Welcome to Escape from Alcatraz. This is a word action game. You are a prisoner trying to escape the maximum security prison. To play this game type in simple commands by responding to your current situation. The game also tests your word logic, that is usage of the right word depending on the situation. For example, you are lockpicking the door in front of you. You hear the door click before you. Type in the appropriate response to escape the dungeon, clue: it ryhmes with happen").lower()
    response = "open"
    while response not in key:
        key = input("Try again!")
    cont = "Good. That is how the game is played. By typing in an appropriate action in every situation you are thrust in. You may encounter some enemies along the way, you would need to type in appropriate responses to fight back. Now that you know how the system works we can begin"
    return

def dog_confrontation():
    hiding_places = ('pool','tomb','ceiling')
    import random
    lives = 5
    bat = 3
    print("The cave leads to an empty tomb. Surrounding you is darkness. You need some light. Luckily you have something just for that in your coat")
    key = input().lower()
    response = "torch"
    while key!= response:
        key = input("You dont have that in your pocket but something else that produces light").lower()
    print("You switch on your "+ key + " and walk down the tunnel. You hear a rush of wind behind you, you have to respond to it")
    key = input().lower()
    response = "turn"
    if response not in key:
        lives = lives - 1
        print("You chose the wrong action. Claws slash into your back and a creature flees into the shadows, clearly you are not alone. You have "+ str(lives) +" lives remaining. You arm yourself with a rock")
    else:
        print("You turn and the creature is gone. You realize you are not alone and arm yourself with a rock")
    print("You have to confront whatever thing is stalking you but its hidden. You stand in a corner ready to hit it with a rock. There are three places it could be hiding. In the dark POOL beside you, behind the TOMB to the left of you or above you on the CEILING.")
    while bat > 0:
        print("Choose where to strike wisely between these places")
        key = input().lower()
        response = random.choice(hiding_places)

        if key in response:
            bat = bat -1
            print("You manage to hit it!")
            if bat > 0:
                print ("But it swipes you down and flees back into the shadows. Make your choice on where to hit again until it is down")
        else:
            lives = lives -1
            print("It leaps from the"+ str(response)+"and slashes you with its claws before retreating back into a hidden place. You have"+str(lives)+"lives remaining.")
            if lives >0 :
                print("Make your choice again.")
        if bat < 0:
            print("The creature collapses before you")
        elif lives < 0:
            p = input("The creature kills you! Game over. Press any key to start checkpoint")

            lives = lives+6

    print("You shine your torch at the creature. Its a malnourished dog that whimpers and cowers into the ground")
    continuation = (input("Press any key to continue"))
    move = input('You decide to spare the sad dog and you see a light at the end of the tomb')
    print('You move the tomb rock aside and find yourself out of the cave and enter an underground tunnel surrounded by stolen Art from the Byzantine era')



def sewers():
    import random
    attacks= ["Woosh!!! One of the guards fires a bow at you",'SHHHW!!!But before you from within the sewers, a snare rises with blades at the other end. It flies straight towards you.','You approach the end of the sewer canal. There is only one turn towards the right. Turn!']
    flag = False
    times = 7
    lives = 5
    print("You leap into the sewers and plunge knee deep into faeces and rats. You summon strength and sprint down the long stretch but guards pursue you from the back.")
    while flag == False:
        if lives < 0:
            input('GAME OVER. Press key to restart')
        elif times < 0:
            flag = True
        elif times < 0:
            flag = True
        n = random.choice(attacks)
        p = input(n).lower
        if n == attacks[0] and p != 'dodge':
            lives = lives -1
            print('Wrong move, the arrow impales you through your shoulder. You have ' + str(lives)+ 'lives left')
        elif n == attacks[0] and p == 'dodge':
            times = times -1
            print('You dodge the arrow but they keep coming')
        elif n == attacks[1] and p != 'jump':
            lives = lives - 1
            print('Wrong move, the blades cut into your legs.You have ' + str(lives)+ 'lives left. Type in the appropriate response of what you would do in the situation')
        elif n == attacks[1] and p == 'jump':
            times = times -1
            print('You dodge the iron gate ')
        elif n == attacks[2] and p != 'right':
            lives = lives - 1
            print('Wrong move. You run head first into the wall and trip down into the filth. You get back on your feet and turn right.You have ' + str(lives)+ 'lives left')
        elif n == attacks[2] and p == 'right':
            times = times -1
            print('You successfully turn right. But the guards keep coming for you.')
    print('You finally escape from the guards and reach the outside walls of the prison. But as you try to jump into the ocean, Behold the prison warden is before you with a shield and stun-button, you must defeat him to escape for good')







def tunnel():
    lives = 5
    Guard = 8
    import random
    sequence = ['He throws a flurry of three strikes','He is now dazed','He is dazed but swipes back','He conceals his attack']
    q = input("As you are mesmerized by the art surrounding you But someone dashes before you and reveals himself. Its a giant armored high guard armed with a spear").lower()
    p = input('You have to fight him. You grab a sword buried under the rubble. You can b. block, p. Swipe sword,').lower()
    while Guard > 0:
        if lives < 0:
            p = input('GAME OVER! Press any key to restart')
            lives = lives + 6
        for i in sequence:
            a = input(i)
            if i == sequence[0]:
                if a == 'bbb':
                    print('you block his attack.')
                else:
                    lives = lives - 3
                    print('he has damaged you. You now have '+str(lives)+' lives remaining. You must block three times')
            elif i == sequence[1]:
                if a == 'p':
                    Guard = Guard - 1
                    print('You managed to hit him.')
                else:
                    print('missed opportunity to strike')
            elif i == sequence[2]:
                if a == 'bp' or a == 'pb':
                    Guard = Guard -1
                    print('You block his attack and strike him')
                else:
                    lives = lives - 1
                    print('he manages to hit you and you have '+ str(lives) + ' lives remaining. You should block and punch at the same time for this type of attack')
            elif i == sequence[3]:
                meaning = ['he throws a flurry of three strikes','he is now dazed','he is dazed but strikes back']
                move = random.choice(meaning)
                if move == meaning[0]:
                    if a == 'bbb':
                        print('you blocked his three strikes')
                    else:
                        lives = lives - 3
                        print('he threw a flurry of strikes at you. you have '+ str(lives) + ' lives remaining now. Guess correctly')
                if move == meaning[1]:
                    if a == 'p':
                        Guard = Guard - 1
                        print('You manage to hit him. Good guess')
                    else:
                        print('Missed opportunity to punch')
                if move == meaning[2]:
                    if a == 'bp' or a == 'pb':
                        Guard = Guard -1
                        print('You block his attack and strike him. Good guess')
                    else:
                        lives = lives -1
                        print('he manages to hit you and you have '+ str(lives)+' lives remaining. Guess correctly')
        if lives < 0:
            p = input('GAME OVER! Press any key to restart')
            lives = lives + 6

    n = input('The guard dies before you but three of his partners notice your kill. They chase you down the tunnel. You then flee into the sewers')

def main():
    intro()
    key = input("You sneak down the narrow hallway of Alcatraz taking care not to be seen. A patrol guard starts coming towards you. Act quick").lower()
    response = 'hide'
    while response not in key:
        key = input("Wrong response. The guard sees you and shoots you down. Try again. A patrol guard starts coming towards you, write down what you would do").lower()
    key = input("Once you are hidden, you wait for the guard to pass by. Once he passes you grab a metal bar and sneak behind the guard. You want his keys and also to leave him unconscious").lower()
    response = ('strike')
    while response not in key:
        key = input('Wrong response! The guard turns around to see you out of your cell. Try again. Use your metal bar to render him unconcious').lower()
    print('You manage to strike him from behind. You drag him into your cell and steal his keys, his uniform and his torch. You tie him onto the bed and make your daring escape')
    key = input('You rush out of the facility and head straight towards the outside toilets. Just outside the toilet you notice a high guard.\n GUARD: Hey!! \nHe calls out to you! You need to quickly divert his attention before he raises the alarm').lower()
    response = 'salute'
    while response not in key:
        key =input('Wrong response, He sees through your disguise and raises the alarm. Try again. clue: a military gesture to show respect ').lower()
    print ('You manage to divert his attention and leave him unsuspecting. You enter the toilet. Behind the mirror there is your escape route. You break the mirror revealing a hollow echoing tunnel behind it. You leap into the tunnel and you slide down jagged rocks into a deep cave system. But you are not alone, there is something down there with you in that dark pit.')
    dog_confrontation()
    tunnel()
    sewers()
    warden()

if __name__ == '__main__':
        main()



