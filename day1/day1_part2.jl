cd("D:/tvxiib/autre/advent_of_code/2019/day1")

total = 0
f = open("instance1")
lignes = readlines(f)

function fuel(x)
     val = div(x,3)-2
     if val > 0
         return val + fuel(val)
    elseif val < 0
        return 0
    else
        return val
    end
end

for l in lignes
    val = parse(Int, l)
    global total += fuel(val)
end
println(total)
