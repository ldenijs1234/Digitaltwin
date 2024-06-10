run("SetModel")
SimStart = 1 ;
SimEnd = length(t) ;
% run("SetInputs")
% run("SetParameters")

h24 = [0:24] ;
avg_cost = mean(simdaycost) ;
intersec = find(abs(simdaycost - avg_cost) <0.0001) ;
point1 = round(intersec(2)/length(t) *24) ;
point2 = round(intersec(3)/length(t) *24) ;
periodh = (point2 - point1) * 2;
hourshift = (point2 + point1)/2  - 5/4* periodh ;
period = 24/periodh * 2 * pi;
sinefunction = 1 * sin(period * (h24-hourshift)/ 24);

figure("WindowStyle", "docked")
plot(h24, sinefunction)


