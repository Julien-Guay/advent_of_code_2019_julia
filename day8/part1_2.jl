cd("D:/tvxiib/autre/advent_of_code/2019/day8")

f = open("input")
ligne = readline(f)
close(f)

x = 25
y = 6
tailleCouche = x*y
nbLayers = div(length(ligne),tailleCouche)
nombres = [ parse(Int,c) for c in ligne ]
couches = reshape(nombres,(tailleCouche,nbLayers))


function solve(couches)
    min0 = 1000000000000
    nb1 = 0
    nb2 = 0
    for i in 1:size(couches)[2]
        coucheCourrante = couches[:,i]
        nb0Courant = 0
        for x in coucheCourrante
            if x == 0
                nb0Courant +=1
            end
        end
        if nb0Courant < min0
            min0 = nb0Courant
            nb1 = 0
            nb2 = 0
            for x in coucheCourrante
                if x == 1
                    nb1 +=1
                end
                if x == 2
                    nb2 +=1
                end
            end
        end
    end
    return (nb1 * nb2)
end

function afficher(couches, x , y, nbLayers)
    min0 = 1000000000000
    for i in 1:x*y
        caractereCourant = 2
        for j in 1:nbLayers
            coucheCourrante = couches[:,j]
            if caractereCourant == 2
                caractereCourant = coucheCourrante[i]
            end
        end
        if caractereCourant == 1
            print("*")
        else
            print(" ")
        end
        if i % x == 0
            println()
        end
    end
end

afficher(couches,x,y,nbLayers)
print(solve(couches))
