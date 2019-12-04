cd("D:/tvxiib/autre/advent_of_code/2019/day1")

total = 0
f = open("instance1")
lignes = readlines(f)
for l in lignes
    val = parse(Int, l)
    global total += div(val,3)-2
end
println(total)
