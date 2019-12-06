cd("D:/tvxiib/autre/advent_of_code/2019/day6")

f = open("input")
lignes = readlines(f)
close(f)

function toTree(lignes)
    tree = Dict()
    for x in lignes
        parent = split(x,')')[1]
        enfant = split(x,')')[2]
        if !(parent in keys(tree))
            tree[parent] = []
        end
        if !(enfant in keys(tree))
            tree[enfant] = []
        end
        push!(tree[parent],enfant)
    end
    return tree
end

function compter(noeud,tree)
    somme = 0
    if tree[noeud] == []
        return 0
    else
        for enfant in tree[noeud]
            somme += 1
            somme += compter(enfant, tree)
        end
    end
    return somme
end

function compterTotal(tree)
    total = 0
    for parent in keys(tree)
        total += compter(parent, tree)
    end
    return total
end

function distTo(source, dest, tree)
    if source == dest
        return 0
    elseif tree[source] == []
        return 999999999
    else
        return 1+minimum(map(child -> distTo(child,dest,tree),tree[source]))
    end
end


tree = toTree(lignes)
println(compterTotal(tree))


println(distTo("COM","YOU",tree))
minimum(map(x -> distTo(x,"YOU",tree) + distTo(x,"SAN",tree),collect(keys(tree))))-2
println()
