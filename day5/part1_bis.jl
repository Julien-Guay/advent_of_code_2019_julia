cd("D:/tvxiib/autre/advent_of_code/2019/day5")

f = open("input")
ligne = readline(f)
close(f)
code = split(ligne,',')

function completer(s,n)
    while length(s) != n
        s = string("0",s)
    end
    return s
end

struct Instruction
    mode
    opCode
    params
end

# Différence d'indexation entre julia et le reste du monde
# retourne un entier
function readValue(code, i)
    return parse(Int,code[i+1])
end

# Différence d'indexation entre julia et le reste du monde
function writeValue(code, i, value)
    code[i+1] = string(value)
end

function add(code, params, mode)
    if mode[1] == '0'
        params[1] = readValue(code, params[1])
    elseif mode[1] != '1'
        println("Mode inconnu : ", mode[1])
        exit(1)
    end
    if mode[2] == '0'
        params[2] = readValue(code, params[2])
    elseif mode[2] != '1'
        println("Mode inconnu : ", mode[2])
        exit(1)
    end
    writeValue(code, params[3], params[1] + params[2])
end

function mult(code, params, mode)
    if mode[1] == '0'
        params[1] = readValue(code, params[1])
    elseif mode[1] != '1'
        println("Mode inconnu : ", mode[1])
        exit(1)
    end
    if mode[2] == '0'
        params[2] = readValue(code, params[2])
    elseif mode[2] != '1'
        println("Mode inconnu : ", mode[2])
        exit(1)
    end
    writeValue(code, params[3], params[1] * params[2])
end

function jumpIfTrue(programme, params, mode)
    code = programme.code
    if mode[1] == '0'
        params[1] = readValue(code, params[1])
    elseif mode[1] != '1'
        println("Mode inconnu : ", mode[1])
        exit(1)
    end
    if mode[2] == '0'
        params[2] = readValue(code, params[2])
    elseif mode[2] != '1'
        println("Mode inconnu : ", mode[2])
        exit(1)
    end
    if params[1] != 0
        programme.i = params[2] + 1
    end
end

function jumpIfFalse(programme, params, mode)
    code = programme.code
    if mode[1] == '0'
        params[1] = readValue(code, params[1])
    elseif mode[1] != '1'
        println("Mode inconnu : ", mode[1])
        exit(1)
    end
    if mode[2] == '0'
        params[2] = readValue(code, params[2])
    elseif mode[2] != '1'
        println("Mode inconnu : ", mode[2])
        exit(1)
    end
    if params[1] == 0
        programme.i = params[2] + 1
    end
end

function lessThan(code, params, mode)
    if mode[1] == '0'
        params[1] = readValue(code, params[1])
    elseif mode[1] != '1'
        println("Mode inconnu : ", mode[1])
        exit(1)
    end
    if mode[2] == '0'
        params[2] = readValue(code, params[2])
    elseif mode[2] != '1'
        println("Mode inconnu : ", mode[2])
        exit(1)
    end
    if params[1] < params[2]
        writeValue(code, params[3], 1)
    else
        writeValue(code, params[3], 0)
    end
end

function equals(code, params, mode)
    if mode[1] == '0'
        params[1] = readValue(code, params[1])
    elseif mode[1] != '1'
        println("Mode inconnu : ", mode[1])
        exit(1)
    end
    if mode[2] == '0'
        params[2] = readValue(code, params[2])
    elseif mode[2] != '1'
        println("Mode inconnu : ", mode[2])
        exit(1)
    end
    if params[1] == params[2]
        writeValue(code, params[3], 1)
    else
        writeValue(code, params[3], 0)
    end
end

function getInstruction(code, instructionPointer)
    instruction = completer(code[instructionPointer],5)
    opCode = instruction[end-1:end]
    mode = []
    push!(mode, instruction[3])
    push!(mode, instruction[2])
    push!(mode, instruction[1])
    nbParams = 0
    if opCode in ["01", "02"]
        nbParams = 3
    elseif opCode in ["05","06"]
        nbParams = 2
    elseif opCode in ["03", "04"]
        nbParams = 1
    elseif opCode != "99"
        println("Code inconnu : ",opCode)
        exit(1)
    end
    # Chargement des valeurs des paramètres
    params = []
    for i in 1:nbParams
        param = parse(Int,code[instructionPointer+i])
        push!(params,param)
    end
    return Instruction(mode, opCode, params)
end

mutable struct Programme
    code
    i # Registre d'instruction
    input
    Programme(code,input) = new(copy(code),1, input)
end

# Exécute une instruction, retourne true si pas d'erreur
function execute(programme)
    code = programme.code
    instructionCourrante = getInstruction(code, programme.i)
    params = instructionCourrante.params
    mode = instructionCourrante.mode
    println("opcode ",instructionCourrante.opCode)
    if instructionCourrante.opCode == "01"
        add(code, params, mode)
    elseif instructionCourrante.opCode == "02"
        mult(code, params, mode)
    elseif instructionCourrante.opCode == "03"
        writeValue(code, params[1], programme.input)
    elseif instructionCourrante.opCode == "04"
        println("output ",readValue(code, params[1]))
    elseif instructionCourrante.opCode == "05"
        jumpIfTrue(programme,params,mode)
    elseif instructionCourrante.opCode == "06"
        jumpIfFalse(programme,params,mode)
    elseif instructionCourrante.opCode == "07"
        lessThan(code, params, mode)
    elseif instructionCourrante.opCode == "08"
        equals(code, params, mode)
    elseif instructionCourrante.opCode == "99"
        println("Fin")
        return -1
    else
        println("opCode inconnu ", instructionCourrante.opCode)
        exit(1)
    end
    programme.i += 1 + length(instructionCourrante.params)
    return 0
end

function solve(code)
    programme = Programme(code, 5)
    println("blah")
    res = 0
    while res != -1
        res = execute(programme)
        println("res ",res)
    end
end

solve(code)
