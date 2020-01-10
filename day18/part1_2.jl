cd("D:/tvxiib/autre/advent_of_code/2019/day18")

total = 0
f = open("input")
lignes = readlines(f)
carte = [collect(ligne) for ligne in lignes]
close(f)

function explorerCasesAdjascentes(centre, carte, distances, cles)
    x = centre[1]
    y = centre[2]
    n = size(carte)[1]
    retour = false
    for (Δx,Δy) in [(1,0),(0,1),(0,-1),(-1,0)]
        if ((x + Δx) > 0 && (x + Δx) <= n
            && (y + Δy) > 0 && (y + Δy) <= n
            # Si la case est vide               ou contient une porte dont on a la clé      ou est un clé
            && (carte[x + Δx][y + Δy] == '.' || lowercase(carte[x + Δx][y + Δy]) in cles || 'a' <= carte[x + Δx][y + Δy] <= 'z')
            && (distances[x + Δx,y + Δy] == -1 || distances[x + Δx,y + Δy] > distances[x,y] +1))
            distances[x + Δx,y + Δy] = distances[x,y] +1
            explorerCasesAdjascentes((x + Δx,y + Δy), carte, distances, cles)
        end
    end
    return retour
end

function dijkstra(depart, carte, cles)
    n = size(carte)[1]
    distances = -ones(Int,n,n)
    distances[depart[1],depart[2]] = 0
    continuer = true
    while continuer
        continuer = false
        continuer = continuer || explorerCasesAdjascentes(depart, carte, distances,cles)
    end
    return distances
end

function positionsCles(carte)
    n = size(carte)[1]
    positions = Dict()
    for i in 1:n
        for j in 1:n
            if 'a' <= carte[i][j] <= 'z'
                positions[carte[i][j]] = (i,j)
            end
        end
    end
    return positions
end

mutable struct Solution
    valeur
end

function solve(carte)
    n = size(carte)[1]
    positionCourante = nothing
    positionDesCles = positionsCles(carte)
    distancesEntreCles = distancesEntreLesCles(positionDesCles)
    println("Positions des clés :")
    println(positionDesCles)
    for i in 1:n
        for j in 1:n
            if carte[i][j] == '@'
                positionCourante = (i,j)
                break
            end
        end
    end
    carte[positionCourante[1]][positionCourante[2]] = '.'
    meilleureSolution = Solution(10000000)

    branchAndBound(positionDesCles, positionCourante, Solution(0), [], meilleureSolution, carte, distancesEntreCles)
    return meilleureSolution.valeur
end

function distancesEntreLesCles(positionDesCles)
    distancesEntreCles = Dict()
    for cle1 in keys(positionDesCles)
        distances = dijkstra(positionDesCles[cle1], carte, keys(positionDesCles)) # On ignore les portes en passant toutes les clés en paramètre
        for cle2 in keys(positionDesCles)
            if cle1 != cle2
                distancesEntreCles[(cle1,cle2)] = distances[positionDesCles[cle2][1],positionDesCles[cle2][2]]
            end
        end
    end
    return distancesEntreCles
end

# Construction d'une borne inf pour élaguer l'arbre de recherche
function complementBorneInf(distancesEntreCles, clésRecupérées, nbCles)
    minDist = 10000000000
    distances = []
    for key in keys(distancesEntreCles)
        if !(key[1] in clésRecupérées && key[2] in clésRecupérées)
            push!(distances, distancesEntreCles[key])
        end
    end
    sort!(distances)
    resultat = sum(distances[1:(nbCles - length(clésRecupérées))])
    return resultat
end


# Agit par effet de bords sur meilleureSolution, résultat dans meilleureSolution.valeur
function branchAndBound(positionDesCles, positionCourante, solutionCourante, clésRecupérées, meilleureSolution, carte, distancesEntreCles)
    # Si on a récupéré toutes les clés
    if length(positionDesCles) == length(clésRecupérées)
        if solutionCourante.valeur < meilleureSolution.valeur
            meilleureSolution.valeur = solutionCourante.valeur
            println("Clés ",clésRecupérées)
            println(solutionCourante)
        end
    else
        # Sinon on calcule les distances entre la position courante et chacune des clés et on teste toutes les solutions réalisables (et non sous optimales)
        distances = dijkstra(positionCourante, carte, clésRecupérées) # Calcul des distances via l'algo de dijkstra
        for cle in keys(positionDesCles)
            pos = positionDesCles[cle]
            if (distances[pos[1],pos[2]] != -1             # Si la solution est réalisable
                && !(cle in clésRecupérées))
                # Construction d'une borne inf.
                complementBorne =  complementBorneInf(distancesEntreCles, clésRecupérées, length(positionDesCles))
                if(distances[pos[1],pos[2]] + solutionCourante.valeur + complementBorne < 4500) # Si la solution n'est pas sous optimale
                    nouvelleSolutionCourante = Solution(solutionCourante.valeur + distances[pos[1],pos[2]])
                    nouvellesClésRécupérées = copy(clésRecupérées)
                    nouvellePositionCourante = positionDesCles[cle]
                    push!(nouvellesClésRécupérées, cle)
                    branchAndBound(positionDesCles, nouvellePositionCourante, nouvelleSolutionCourante, nouvellesClésRécupérées, meilleureSolution, carte, distancesEntreCles)
                else
                    println("Elagage ",clésRecupérées)
                end
            end
        end
    end
end
solve(carte)
