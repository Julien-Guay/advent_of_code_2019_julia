using DelimitedFiles
cd("D:/tvxiib/autre/advent_of_code/2019/day24")

function solve(caracteres)
    situationsRencontrees = [copy(caracteres)]
    while true
        caracteres = unTour(caracteres)
        if ! (caracteres in situationsRencontrees)
            push!(situationsRencontrees,caracteres)
        else
            println(caracteres)
            break
        end
    end
    return rating(caracteres)
end

function rating(caracteres)
    total = 0
    n = size(caracteres)[1]
    cpt = 0
    for i in 1:n
        for j in 1:n
            if caracteres[i,j] == '#'
                total += 2^(cpt)
            end
            cpt+=1
        end
    end
    return total
end

function unTour(caracteres)
    n = size(caracteres)[1]
    retour = copy(caracteres)
    for i in 1:n
        for j in 1:n
            if caracteres[i,j] == '#'
                if nbVirusAdj(caracteres,i,j) != 1
                    retour[i,j] = '.'
                end
            else
                if nbVirusAdj(caracteres,i,j) in (1,2)
                    retour[i,j] = '#'
                end
            end

        end
    end
    return retour
end

function nbVirusAdj(caracteres, x, y)
    n = size(caracteres)[1]
    total = 0
    for (Δx,Δy) in [(-1,0),(1,0),(0,-1),(0,1)]
            X = x+Δx
            Y = y+Δy
            if (X > 0 && Y <= n && Y > 0 && X <= n)
                if caracteres[X,Y] == '#'
                    total+=1
                end
        end
    end
    return total
end

total = 0
f = open("input")
lignes = readlines(f)
caracteresAux = [reshape(collect(ligne),1,5) for ligne in lignes]
caracteres = reduce(vcat, caracteresAux)
println(solve(caracteres))
