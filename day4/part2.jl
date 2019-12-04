cd("D:/tvxiib/autre/advent_of_code/2019/day3")

f = open("input")
ligne1 = readline(f)
ligne2 = readline(f)
close(f)
tuyau1 = split(ligne1,',')
tuyau2 = split(ligne2,',')


function positionsParcourues(tuyau)
    positionCourante = (0,0)
    positions = []
    nbMouvements = Dict()
    n = 0
    for mouvement in tuyau
        nbCases = parse(Int,mouvement[2:end])
        Δx = 0
        Δy = 0
        if mouvement[1] == 'R'
            Δx = 1
        elseif mouvement[1] == 'U'
            Δy = 1
        elseif mouvement[1] == 'L'
            Δx = -1
        elseif mouvement[1] == 'D'
            Δy = -1
        else
            println("Mouvement inconnu ",mouvement)
            exit(1)
        end
        for i in 1:nbCases
            nbMouvements[positionCourante] = n
            positionCourante = (positionCourante[1] + Δx, positionCourante[2] + Δy)
            push!(positions,positionCourante)
            n+=1
        end
    end
    return (positions, nbMouvements)
end

positionsParcourues1,nbMouv1 = positionsParcourues(tuyau1)
positionsParcourues2,nbMouv2 = positionsParcourues(tuyau2)

function manhattan(coord1,coord2)
    return abs(coord1[1]-coord2[1]) + abs(coord1[2]-coord2[2])
end

intersections = intersect(positionsParcourues1,positionsParcourues2)
distances = map(coord -> nbMouv1[coord] + nbMouv2[coord], intersections)


function solve(intersections,nbMouv1,nbMouv2)
    for coord in intersections
        dist = nbMouv1[coord] + nbMouv2[coord]
    end
end

print(minimum(distances))
