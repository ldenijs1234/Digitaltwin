run("SetModel")
SimStart = 1 ;
SimEnd = length(t) ;
% run("SetInputs")
% run("SetParameters")

h24 = [0:24] ;
point1 = 5 ;
point2 = 12 ;
periodh = (point2 - point1) * 2 +2;
hourshift = (point2 + point1)/2  - 3/4* periodh ;
period = 24/periodh * 2 * pi;
sinefunction = 1 * sin(period * (h24-hourshift)/ 24);

figure("WindowStyle", "docked")
plot(h24, sinefunction)


