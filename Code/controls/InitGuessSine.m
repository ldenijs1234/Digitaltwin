run("SetModel")
SimStart = 1 ;
SimEnd = length(t) ;
run("SetInputs")
run("SetParameters")

sinefunction = 6 * sin(2 * pi * t/ 24);
plot(t, sinefunction)