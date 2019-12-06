cd("D:/tvxiib/autre/advent_of_code/2019/day5")

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

function compute(caracteres, input)
    i = 1 # Les tableaux sont indexés à partir de 1...
    output = []
    continuer = true
    while continuer
        #println(caracteres)
        instruction = addZeros(caracteres[i],5)
        opCode = instruction[end-1:end]
        paramMode = instruction[1:end-2]
        println("opCode ",opCode)
        params = []
        nbParams = 1
        if opCode in ["01","02","07","08"]
            nbParams = 3
        elseif opCode in ["05","06"]
            nbParams = 2
        elseif opCode in ["03","04"]
            nbParams = 1
        else
            break
        end
        for j in 1:nbParams
            param = parse(Int,caracteres[i+j])
            append!(params,param)
        end
        if nbParams == 3 || nbParams == 2
            if paramMode[3] == '0'
                params[1] = parse(Int,caracteres[params[1]+1])
                println("Param 1 ", params[1])
            end
            if paramMode[2] == '0'
                params[2] = parse(Int,caracteres[params[2]+1])
                println("Param 2 ", params[2])
            end
        end

        if opCode == "01"
            caracteres[params[3]+1] = string(params[1]+params[2])
        elseif opCode == "02"
            caracteres[params[3]+1] = string(params[1]*params[2])
        elseif opCode == "03"
            caracteres[params[1]+1] = string(input)
        elseif opCode == "04"
            if paramMode[3] == '0'
                params[1] = parse(Int,caracteres[params[1]+1])
            end
            println("output ",params[1])
        elseif opCode == "05"
            if params[1] != 0
                i=params[2]+1
                continue
            end
        elseif opCode == "06"
            if params[1] == 0
                i=params[2]+1 # LES TABLEAUX SONT INDEXÉS A PARTIR DE 1 !!! 😢
                println("i ",i)
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
        else
            continuer = false
        end
        i += nbParams+1
    end
end

# compute(["3","9","8","9","10","9","4","9","99","-1","8"], 9)
# compute(["3","9","7","9","10","9","4","9","99","-1","8"], 7)
# compute(["3","3","1107","-1","8","3","4","3","99"], 9)
# compute(["3","12","6","12","15","1","13","14","13","4","13","99","-1","0","1","9"], -1)
compute(caracteres,5)
