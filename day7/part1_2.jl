cd("D:/tvxiib/autre/advent_of_code/2019/day7")

total = 0
f = open("input")
ligne = readline(f)
caracteres = split(ligne,',')

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
    caracteres
    i # Registre d'instruction
    input
    Amplifier(code,input) = new(copy(code),1, input)
end

function compute(amplifier)
    caracteres = amplifier.caracteres
    continuer = true
    while continuer
        #println(caracteres)
        instruction = addZeros(caracteres[amplifier.i],5)
        opCode = instruction[end-1:end]
        paramMode = instruction[1:end-2]
        #println("opCode ",opCode)
        params = []
        nbParams = 1
        if opCode in ["01","02","07","08"]
            nbParams = 3
        elseif opCode in ["05","06"]
            nbParams = 2
        elseif opCode in ["03","04"]
            nbParams = 1
        elseif opCode == "99"
            println("Fin")
            return -1
            break
        else
            println("codeInconnu : ", opCode)
            exit(1)
        end
        for j in 1:nbParams
            param = parse(Int,caracteres[amplifier.i+j])
            append!(params,param)
        end
        if nbParams == 3 || nbParams == 2
            if paramMode[3] == '0'
                params[1] = parse(Int,caracteres[params[1]+1])
            end
            if paramMode[2] == '0'
                params[2] = parse(Int,caracteres[params[2]+1])
            end
        end

        if opCode == "01"
            caracteres[params[3]+1] = string(params[1]+params[2])
        elseif opCode == "02"
            caracteres[params[3]+1] = string(params[1]*params[2])
        elseif opCode == "03"
            caracteres[params[1]+1] = string(amplifier.input[1])
            deleteat!(amplifier.input,1)
        elseif opCode == "04"
            if paramMode[3] == '0'
                params[1] = parse(Int,caracteres[params[1]+1])
            end
            println("output ",params[1])
            amplifier.i += nbParams+1
            return params[1]
        elseif opCode == "05"
            if params[1] != 0
                amplifier.i=params[2]+1
                continue
            end
        elseif opCode == "06"
            if params[1] == 0
                amplifier.i=params[2]+1 # LES TABLEAUX SONT INDEXÉS A PARTIR DE 1 !!! 😢
                continue
            end
        elseif opCode == "07"
            if params[1] < params[2]
                caracteres[params[3]+1] = "1"
            else
                caracteres[params[3]+1] = "0"
            end
        elseif opCode == "08"
            if params[1] == params[2]
                caracteres[params[3]+1] = "1"
            else
                caracteres[params[3]+1] = "0"
            end
        end
        amplifier.i += nbParams+1
    end
end

# compute(["3","9","8","9","10","9","4","9","99","-1","8"], 9)
# compute(["3","9","7","9","10","9","4","9","99","-1","8"], 7)
# compute(["3","3","1107","-1","8","3","4","3","99"], 9)
# compute(["3","12","6","12","15","1","13","14","13","4","13","99","-1","0","1","9"], -1)


#ampli = Amplifier(caracteres, 5)


function solve(caracteres,phases)
    inputs = [[phases[i]] for i in 1:5]
    push!(inputs[1], 0)
    amplis = [Amplifier(caracteres, inputs[i]) for i in 1:5 ]
    out = compute(amplis[1])
    i = 2
    j = 2
    maxOutput = out
    while true
        #println("Ampli i ", i," ", amplis[i].i)
        push!(amplis[i].input,out)
        #println("inputs avant ",inputs[i])
        out = compute(amplis[i])
        maxOutput = max(maxOutput, out)
        if i == 5 && out == -1
            break
        end
        #println("inputs apres ",inputs[i])
        i+=1
        j+=1
        if i > 5
            i=1
        end
    end
    return maxOutput
end

function enumerer(caracteres, combinaison,chiffres)
    maxVal = 0
    if length(combinaison) == length(chiffres)
        return solve(caracteres, combinaison)
    end
    for x in chiffres
        if !(x in combinaison)
            nouvelleCombinaison = copy(combinaison)
            push!(nouvelleCombinaison,x)
            maxVal = max(maxVal, enumerer(caracteres, nouvelleCombinaison,chiffres))
        end
    end
    return maxVal
end
solve(caracteres,[9,7,8,5,6])
enumerer(caracteres, [], [5,6,7,8,9])
