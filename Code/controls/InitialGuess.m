run("SetModel")
SimStart = 1 ;
SimEnd = length(t) ;
h24 = [0:24]' ;
run("SetInputs")
run("SetParameters")

% Initiate multiple guesses to find the best starting point for gradient descend
Guess1 = Lowerbound(1:3600/dt:end)' + 1;
Guess2 = Lowerbound(1:3600/dt:end)' + 2 ;
Guess3 = meanline(1:3600/dt:end)' ; 
Guess4 = sin(15/4*pi*(h24+1)/24) +  20 ;
Guess5 = 0.25*sin(4*pi*(h24+2)/24) +  Guess2 ;


% Educated guesses
Cost_Derivative = diff(simdaycost)./diff(t);
Windowwidth = 65;
Timeforward = 70;
windowavgnow = zeros(1, length(simdaycost));
windowavgforward = zeros(1, length(simdaycost));
Guess6 = Lowerbound + 1.5;


for i = 1:length(simdaycost) - (windowwidth + Timeforward)
    windowavgnow(i) = sum(simdaycost(i:i+windowwidth/3)) / (windowwidth / 3);
        windowavgforward(i) = sum(simdaycost(i+Timeforward:i+Timeforward+windowwidth)) / windowwidth;
    if windowavgforward(i) > 1.2 * windowavgnow(i)
        Guess6(i) = Guess6(i) + (windowavgforward(i) / windowavgnow(i) - 1) * 10;
        Guess6(i) = min(Guess6(i), Upperbound(i));
    end
end
Guess6 = Guess6(1:3600/dt:end)';

h24 = [0:24]' ;
avg_cost = mean(simdaycost) ;
intersec = find(abs(simdaycost - avg_cost) <0.0001) ;
point1 = round(intersec(2)/length(t) *24) ;
point2 = round(intersec(3)/length(t) *24) ;
periodh = (point2 - point1) * 2;
hourshift = (point2 + point1)/2  - 5/4* periodh ;
period = 24/periodh * 2 * pi;
Guess7 = 1 * sin(period * (h24-hourshift)/ 24) + Guess2;

Guesses = [Guess1, Guess2, Guess3, Guess4, Guess5, Guess6, Guess7];


