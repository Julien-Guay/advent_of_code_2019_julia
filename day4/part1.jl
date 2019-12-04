cd("D:/tvxiib/autre/advent_of_code/2019/day4")

borne1 = 245182
borne2 = 790572

function correct(mdp)
    doublon = false
    croissant = true
    prevChar = 'a'
    for i in 1:length(mdp)-1
        c1 = mdp[i]
        c2 = mdp[i+1]
        c3 = 'a'
        if i+2 <= length(mdp)
            c3 = mdp[i+2]
        end
        if c1 == c2 && c3 != c2 && prevChar != c1
            doublon = true
        end
        if c1 > c2
            croissant = false
        end
        prevChar = c1
    end
    return doublon && croissant
end

function solve(borne1, borne2)
    somme = 0
    for i in borne1:borne2
        if correct(string(i))
            somme += 1
        end
    end
    return somme
end

print(solve(245182,790572))
