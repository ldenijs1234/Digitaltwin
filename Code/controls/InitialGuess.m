run("SetModel")
SimStart = 1 ;
SimEnd = length(t) ;
run("SetInputs")
run("SetParameters")

Guess1 = Lowerbound(1:3600/dt:end)' + 2 ;
Guess2 = meanline(1:3600/dt:end)' ; 
h24 = [0:24]' ;
Guess3 = sin(4*pi*(h24+2)/24) +  20 ;
Guess4 = 0.25*sin(4*pi*(h24+2)/24) +  Guess1 ;

Guesses = [Guess1, Guess2, Guess3, Guess4];

hold on
figure("WindowStyle", "docked");
plot(h24, Guess1)
plot(h24, Guess2)
plot(h24, Guess3)
hold off

Cost_Derivative = diff(simdaycost)./diff(t);
Windowwidth = 60;
Timeforward = 60;
windo

for i = 1:length(simdaycost) - Windowwidth
    windowavgnow(i) = sum(simdaycost(i:i+Windowwidth)) / windowwidth;
    windowavgforward(i) = sum(simdaycost(i+Timeforward-Windowwidth/2:i+Timeforward+Windowwidth/2));

end


