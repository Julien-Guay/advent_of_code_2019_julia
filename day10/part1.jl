cd("D:/tvxiib/autre/advent_of_code/2019/day10")

f = open("input")
lignes = readlines(f)
close(f)


function solve(lignes)
    retour = 1
    for i in 1:length(lignes)
        for j in 1:length(lignes[1])
            if lignes[i][j] == '#'
                compteur = -1 # Ne peut pas se détecter lui meme
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
                            compteur += visible
                            retour = max(compteur, retour)
                            end
                        end
                    end
                end
            end
        end
    return retour
end

solve(lignes)
