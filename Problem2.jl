#if any of these orders are acheived by anyplayer, that player wins
const bestorders = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [1, 4, 7], 
    [2, 5, 8], [3, 6, 9],[1, 5, 9], [7, 5, 3]] 
 #deciding who the winner is after considering the board
function victor(table, deck)
    choice = findall(x -> x == deck, table)
    for order in bestorders
        if length(order) <= length(choice) && order == sort(choice)[1:3]
            return true
        end
    end
    false
end
 #starting the functions that allow the player to take their turn here
function takeinput(input, prob)
    keep = '*'
    while !(keep in prob)
        print("\n", input, " ->  ")
        keep = lowercase(chomp(readline()))[1]
    end
    keep
end
 
choices(table) = findall(x -> x == ' ', table)
notdone(table) = [x for x in [1, 3, 7, 9] if table[x] == ' ']
convint(x) = Char(x + UInt8('0'))
convchar(x) = UInt8(x) - UInt8('0')
askem(ask) = takeinput(ask, ['y', 'n'])
whichinput(table) = convchar(takeinput("please make a choice between any move from 1 to 9", convint.(choices(table))))
 #code allowing the players turn to be entered onto the board
function contest(table, deck)
    plchold	= deepcopy(table)
    for playz in choices(plchold)
        plchold[playz] = deck
        if victor(plchold, deck)
            return playz
        end
        plchold[playz] = ' '
    end
    return nothing
end
 #movement conditions
function movchoice(table, mychar, oppmov)
    if all(x -> x == ' ', table)
        table[rand(notdone(table))] = mychar 
    elseif choices(table) == []
        println("Good game, neither of you won but neither of you lost either.")
        exit(0)
    elseif (x = contest(table, mychar)) != nothing || (x = contest(table, oppmov)) != nothing
        table[x] = mychar 
    elseif table[5] == ' '
        table[5] = mychar 
    elseif (edge = notdone(table)) != []
        table[rand(edge)] = mychar 
    else
        table[rand(choices(table))] = mychar 
    end
end
#matrix that represents the table.
function showscape(table)
    println("<<<<<<>>>>>")
    println("  ", table[1], "   ", table[2], "   ", table[3], "  ")
    println("  ", table[4], "   ", table[5], "   ", table[6], "  ")
    println("  ", table[7], "   ", table[8], "   ", table[9], "  ")
    println("<<<<<<>>>>>")
end
 #this starts the game 
function gametime()

    scape = fill(' ', 9)
    println("Moves to choose from are:\n 1 2 3\n 4 5 6\n 7 8 9")

    askthem = askem("Enter y if you'd like the first move (y/n)?")
    if askthem == 'y'
        mychar = 'O'
        oppmov = 'X'
        scape[whichinput(scape)] = oppmov
    else
        mychar = 'X'
        oppmov = 'O'
    end
    while true
        movchoice(scape, mychar, oppmov)
        println("A.I. took it's turn.")
        showscape(scape)
        if victor(scape, mychar)
            println("You lose this round")
            exit(0)
        elseif choices(scape) == []
            break
        end
        scape[whichinput(scape)] = oppmov
        println("Your move is over")
        showscape(scape)
        if victor(scape, oppmov)
            println("You win!")
            exit(0)
        elseif choices(scape) == []
            break
        end
    end
    println("Good game, neither of you won but neither of you lost either.")
end
 
gametime()
