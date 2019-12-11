cd("D:/tvxiib/autre/advent_of_code/2019/day10")
using LinearAlgebra

f = open("input")
lignes = readlines(f)
close(f)
lignes = map(collect,lignes)

function angleOriente(a,b)
    #print("a b ", a," ",b)
    determinant = a[1] * b[2] - a[2] * b[1]
    cosinus = dot(a, b) / (norm(a) * norm(b))
    if cosinus > 1
         cosinus = 1
    end
    if cosinus < -1
         cosinus = -1
    end
    if determinant > 0 # Afin d'avoir un resultat entre 0 et 2 pi
        return 2*pi - acos(cosinus)
    end
    return acos(cosinus)
end

function solve(lignes)
    retour = 1
    # i = 21
    # j = 21
    i = 21
    j = 21
    angleCourant = (-0.001,1)
    for cpt in 1:200
        minDiff = 10 # Entre 0 et 2 pi
        bestAngle = angleCourant
        compteur = -1 # Ne peut pas se détecter lui meme
        asteroideADetruire = (0,0)
        for i2 in 1:length(lignes)
            for j2 in 1:length(lignes[1])
                if lignes[i2][j2] == '#'
                    visible = 1
                    if i2 == i
                        for step in 1:abs(j2-j)-1
                            direction = j2 > j ? 1 : -1
                            x = i
                            y = j+direction*step
                            if lignes[x][y] == '#'
                                visible = 0
                            end
                        end
                    elseif j2 == j
                        for step in 1:abs(i2-i)-1
                            direction = i2 > i ? 1 : -1
                            x = i+direction*step
                            y = j
                            if lignes[x][y] == '#'
                                visible = 0
                            end
                        end
                    else
                        pgcd = gcd(abs(i2-i),abs(j2-j))
                        pasX = div((i2-i) , pgcd)
                        pasY = div((j2-j) , pgcd)
                        x = i + pasX
                        y = j + pasY
                        while (x,y) != (i2,j2)
                            if lignes[x][y] == '#'
                                visible = 0
                            end
                            (x,y) = (x + pasX , y + pasY )
                        end
                    end
                    if visible == 1
                        α = angleOriente(angleCourant,(j2-j,i-i2))
                        #println("coordonnees ",j2," ",i2)
                        #println("Angle ",α)
                        if 0.0001 < α < minDiff
                            minDiff = α
                            bestAngle = (j2-j,i-i2)
                            asteroideADetruire = (i2,j2)
                        end
                    end

                    compteur += visible
                    retour = max(compteur, retour)

                end
            end
        end
        # Destruction de l'asteroide
        lignes[asteroideADetruire[1]][asteroideADetruire[2]] = '.'
        angleCourant = bestAngle
        # On repasse dans le systeme de coordonnees attendu
        println(cpt," eme asteroideDetruit : ",asteroideADetruire[2]-1," ",asteroideADetruire[1]-1)
        #println("Angle courant ", angleCourant)
        #println(lignes)
    end
    return retour
end



solve(lignes)
