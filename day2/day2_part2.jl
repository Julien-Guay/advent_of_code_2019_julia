cd("D:/tvxiib/autre/advent_of_code/2019/day2")

total = 0
f = open("input")
ligne = readline(f)
caracteres = split(ligne,',')
nombres = [parse(Int,x) for x in caracteres]

function compute(nombres)
    i = 1 # Les tableaux sont indexés à partir de 1...
    continuer = true
    while continuer
        if nombres[i] == 1
            i1 = nombres[i+1]
            i2 = nombres[i+2]
            i3 = nombres[i+3]
            nombres[i3+1] = nombres[i2+1] + nombres[i1+1]
        elseif nombres[i] == 2
            i1 = nombres[i+1]
            i2 = nombres[i+2]
            i3 = nombres[i+3]
            nombres[i3+1] = nombres[i2+1] * nombres[i1+1]
        else
            continuer = false
        end
        i+=4
    end
    return nombres[1]
end

function solve(nombres)
    for i in 0:99
        for j in 0:99
            nombres[2] = i
            nombres[3] = j
            val = compute(copy(nombres))
            if val == 19690720
                print(100*i+j)
            end
        end
    end
end
solve(nombres)

compute(nombres)
