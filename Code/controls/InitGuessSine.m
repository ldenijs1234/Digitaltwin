run("SetModel")
SimStart = 1 ;
SimEnd = length(t) ;
% run("SetInputs")
% run("SetParameters")

h24 = [0:24] ;
hourshift = -3; 
period = 16/4 * pi;
peaklocation = 1/4* period/(2*pi) * 24 + hourshift;

sinefunction = 1 * sin(period * (h24-hourshift)/ 24);

figure("WindowStyle", "docked")
plot(h24, sinefunction)