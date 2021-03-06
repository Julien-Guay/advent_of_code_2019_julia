cd("D:/tvxiib/autre/advent_of_code/2019/day11")

total = 0
f = open("input")
ligne = readline(f)
caracteres = split(ligne,',')

function array2Dico(caracteres)
    d = Dict()
    for i in 1:length(caracteres)
        d[string(i-1)] = caracteres[i]
    end
    return d
end

memoire = array2Dico(caracteres)

function somme(chaine1, chaine2)
    return string(parse(Int,chaine1)+parse(Int,chaine2))
end
function produit(chaine1, chaine2)
    return string(parse(Int,chaine1)*parse(Int,chaine2))
end
function addZeros(stringNumber, taille)
    while length(stringNumber) < taille
        stringNumber = string("0",stringNumber)
    end
    return stringNumber
end

mutable struct Amplifier
    memoire
    i # Registre d'instruction
    input
    relativeBase
    output
    Amplifier(code,input,output) = new(copy(code),0, input,0,output)
end

# Calcule l'adresse à utiliser, après indirection
function getAdresse(memoire, mode, adresseInitiale,relativeBase)
    if mode == '0'
        return memoire[adresseInitiale]
    elseif mode == '2'
        return string(relativeBase + parse(Int, memoire[adresseInitiale]))
    elseif mode == '1'
        return adresseInitiale
    else
        println("Erreur, mode inconnu ",mode)
        exit(1)
    end
end

function compute(amplifier)
    memoire = amplifier.memoire
    continuer = true
    while continuer
        instruction = addZeros(memoire[string(amplifier.i)],5)
        opCode = instruction[end-1:end]
        paramMode = instruction[1:end-2]
        nbParams = 1
        if opCode in ["01","02","07","08"]
            nbParams = 3
        elseif opCode in ["05","06"]
            nbParams = 2
        elseif opCode in ["03","04","09"]
            nbParams = 1
        elseif opCode == "99"
            println("Fin")
            return "Fin"
            break
        else
            println("codeInconnu : ", opCode)
            exit(1)
        end
        adresses = []
        for j in 1:nbParams
            ## Récupération des adresses des paramètres selon le mode
            adresse = getAdresse(memoire,paramMode[4-j],string(amplifier.i+j),amplifier.relativeBase)
            if !(adresse in keys(memoire))
                memoire[adresse] = "0"
            end
            push!(adresses, getAdresse(memoire,paramMode[4-j],string(amplifier.i+j),amplifier.relativeBase))
        end

        if opCode == "01"
            memoire[adresses[3]] = string(parse(Int,memoire[adresses[1]])+parse(Int,memoire[adresses[2]]))
        elseif opCode == "02"
            memoire[adresses[3]] = string(parse(Int,memoire[adresses[1]])*parse(Int,memoire[adresses[2]]))
        elseif opCode == "03"
            memoire[adresses[1]] = string(amplifier.input[1])
            deleteat!(amplifier.input,1)
        elseif opCode == "04"
            println("output ",memoire[adresses[1]])
            push!(amplifier.output, memoire[adresses[1]])
            # TODO : faire un truc propre
            amplifier.i += nbParams+1
            #return memoire[adresses[1]]
        elseif opCode == "05"
            if parse(Int,memoire[adresses[1]]) != 0
                amplifier.i=parse(Int,memoire[adresses[2]])
                continue
            end
        elseif opCode == "06"
            if parse(Int,memoire[adresses[1]]) == 0
                amplifier.i=parse(Int,memoire[adresses[2]])
                continue
            end
        elseif opCode == "07"
            if parse(Int,memoire[adresses[1]]) < parse(Int,memoire[adresses[2]])
                memoire[adresses[3]] = "1"
            else
                memoire[adresses[3]] = "0"
            end
        elseif opCode == "08"
            if parse(Int,memoire[adresses[1]]) == parse(Int,memoire[adresses[2]])
                memoire[adresses[3]]= "1"
            else
                memoire[adresses[3]] = "0"
            end
        elseif opCode == "09"
            amplifier.relativeBase += parse(Int,memoire[adresses[1]])
        end
        amplifier.i += nbParams+1
    end
end
#ampli = Amplifier(caracteres, 5)

function deplacement(position, direction, orientation)
    direction = parse(Int, direction)
    nouvelleOrientation = (0,0)
    if orientation == (0,1) && direction == 0
        nouvelleOrientation = (-1,0)
    elseif orientation == (0,1) && direction == 1
        nouvelleOrientation = (1,0)
    elseif orientation == (1,0) && direction == 0
        nouvelleOrientation = (0,1)
    elseif orientation == (1,0) && direction == 1
        nouvelleOrientation = (0,-1)
    elseif orientation == (0,-1) && direction == 0
        nouvelleOrientation = (1,0)
    elseif orientation == (0,-1) && direction == 1
        nouvelleOrientation = (-1,0)
    elseif orientation == (-1,0) && direction == 0
        nouvelleOrientation = (0,-1)
    elseif orientation == (-1,0) && direction == 1
        nouvelleOrientation = (0,1)
    else
        println("Direction ou orientation inconnue ",orientation, " ", direction )
        exit(1)
    end
    nouvellePosition = (position[1] + nouvelleOrientation[1], position[1] + nouvelleOrientation[2])
    return (nouvellePosition,nouvelleOrientation)
end

function solve(memoire)
    input = [0]
    output = []
    ampli = Amplifier(memoire, input, output)
    println("input : ",ampli.input)
    out = compute(ampli)
    position = (0,0)
    orientation = (0,1) # Robot dirigé vers le haut
    couleurs = Dict()
    while out != "Fin"
        compute(ampli)
        println("Output ", output)
        couleurAPeindre = output[1]
        direction = output[2]
        deleteat!(output,1)
        deleteat!(output,1)

        if position in keys(couleurs)
            couleurs[position] = couleurAPeindre
        end
        (position, orientation) = deplacement(position, direction, orientation)
        if !(position in keys(couleurs))
            couleurs[position] = 0
        end
        push!(input, couleurs[position])

    end
end

solve(memoire)
