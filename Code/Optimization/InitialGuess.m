run("SetModel")
SimStart = 1 ;
SimEnd = length(t) ;
h24 = [0:24]' ;
run("SetInputs")

% Initiate multiple guesses to find the best starting point for gradient descend
Guess1 = Lowerbound(1:3600/dt:end)' + 1;
Guess2 = Lowerbound(1:3600/dt:end)' + 2;
Guess3 = meanline(1:3600/dt:end)' ; 
Guess4 = 0.5*sin(15/4*pi*(h24+1)/24) + Guess2 ;
Guess5 = 0.25*sin(4*pi*(h24+2)/24) +  Guess2 ;


% Educated guesses
Cost_Derivative = diff(simdaycost)./diff(t);
windowwidth = 63;
Timeforward = 70;
windowavgnow = zeros(1, length(simdaycost));
windowavgforward = zeros(1, length(simdaycost));
Guess6 = Lowerbound + 1.5;


for i = 1:length(simdaycost) - (windowwidth + Timeforward)
    windowavgnow(i) = sum(simdaycost(i:i+windowwidth/3)) / (windowwidth / 3);
        windowavgforward(i) = sum(simdaycost(i+Timeforward:i+Timeforward+windowwidth)) / windowwidth;
    if windowavgforward(i) > 1.2 * windowavgnow(i)
        Guess6(i) = Guess6(i) + (windowavgforward(i) / windowavgnow(i) - 1) * 10;
        Guess6(i) = min(meanline(i), max(Guess6(i), Lowerbound(i)+1));
    end
end
Guess6 = Guess6(1:3600/dt:end)';



h24 = [0:24]' ;
avg_cost = mean(simdaycost) ;
tol = 0.001;
for i = 1:10000
    intersec = find(abs(simdaycost - avg_cost) <tol) ;
    if length(intersec) == 4 || length(intersec) ==5
        break
    else
        tol = tol/1.3 ;
    end
end

point1 = round(intersec(2)/length(t) *24) ;
point2 = round(intersec(3)/length(t) *24) ;
periodh = (point2 - point1) * 2;
hourshift1 = (point2 + point1)/2  - 5/4* periodh ;
hourshift2 = (point2 + point1)/2  - 3/4* periodh ;
hourshift3 = (point2 + point1)/2  - 1/2* periodh ;
hourshift4 = (point2 + point1)/2  + 1/6* periodh ;
period = 24/periodh * 2 * pi;
Guess7 = 1 * sin(period * (h24-hourshift1)/ 24) + Guess1;
Guess8 = 1 * sin(period * (h24-hourshift2)/ 24) + Guess1;
Guess9 = 0.5 * sin(period * (h24-hourshift1)/ 24) + Guess1;
Guess10 = 0.5 * sin(period * (h24-hourshift2)/ 24) + Guess1;
Guess11 = 0.5*sin(15/4*pi*(h24+1)/24) + Guess1;
Guess12 = 0.25 * sin(period * (h24-hourshift2)/ 24) + Guess1;
Guess13 = 0.25 * sin(period * (h24-hourshift3)/ 24) + Guess1;
Guess14 = 0.25 * sin(period * (h24-hourshift1)/ 24) + Guess1;
norm = (simdaycost - mean(simdaycost)) / (max(abs(simdaycost - mean(simdaycost))));
Guess15 = Guess1 - 0.5 * norm(1:3600/dt:end)';
Guess16 = Guess1 - norm(1:3600/dt:end)';
Guess17 = Guess1 - 1.5 * norm(1:3600/dt:end)';

windowwidth = 63;
Timeforward = 70;
windowavgnow = zeros(1, length(simdaycost));
windowavgforward = zeros(1, length(simdaycost));

Guess18 = Lowerbound + 1;
for i = 1:length(simdaycost) - (windowwidth + Timeforward)
    windowavgnow(i) = sum(simdaycost(i:i+windowwidth/3)) / (windowwidth / 3);
        windowavgforward(i) = sum(simdaycost(i+Timeforward:i+Timeforward+windowwidth)) / windowwidth;
    if windowavgforward(i) > 1.2 * windowavgnow(i)
        Guess18(i) = Guess18(i) + (windowavgforward(i) / windowavgnow(i) - 1) * 4;
        Guess18(i) = min(meanline(i), max(Guess18(i), Lowerbound(i)+1));
    end
end
Guess18 = Guess18(1:3600/dt:end)';

Guess19 = Lowerbound + 1;
for i = 1:length(simdaycost) - (windowwidth + Timeforward)
    windowavgnow(i) = sum(simdaycost(i:i+windowwidth/3)) / (windowwidth / 3);
        windowavgforward(i) = sum(simdaycost(i+Timeforward:i+Timeforward+windowwidth)) / windowwidth;
    if windowavgforward(i) > 1.2 * windowavgnow(i)
        Guess19(i) = Guess19(i) + (windowavgforward(i) / windowavgnow(i) - 1) * 6;
        Guess19(i) = min(meanline(i), max(Guess19(i), Lowerbound(i)+1));
    end
end
Guess19 = Guess19(1:3600/dt:end)';

windowwidth = 50;
Timeforward = 50;
windowavgnow = zeros(1, length(simdaycost));
windowavgforward = zeros(1, length(simdaycost));


Guess20 = Lowerbound + 1;
for i = 1:length(simdaycost) - (windowwidth + Timeforward)
    windowavgnow(i) = sum(simdaycost(i:i+windowwidth/2)) / (windowwidth / 2);
        windowavgforward(i) = sum(simdaycost(i+Timeforward:i+Timeforward+windowwidth)) / windowwidth;
    if windowavgforward(i) > 1.2 * windowavgnow(i)
        Guess20(i) = Guess20(i) + (windowavgforward(i) / windowavgnow(i) - 1) * 4.5;
        Guess20(i) = min(meanline(i), max(Guess20(i), Lowerbound(i)+1));
    end
end
Guess20 = Guess20(1:3600/dt:end)';

Guess21 = Lowerbound + 1;
for i = 1:length(simdaycost) - (windowwidth + Timeforward)
    windowavgnow(i) = sum(simdaycost(i:i+windowwidth/2)) / (windowwidth / 2);
        windowavgforward(i) = sum(simdaycost(i+Timeforward:i+Timeforward+windowwidth)) / windowwidth;
    if windowavgforward(i) > 1.2 * windowavgnow(i)
        Guess21(i) = Guess21(i) + (windowavgforward(i) / windowavgnow(i) - 1) * 7;
        Guess21(i) = min(meanline(i), max(Guess21(i), Lowerbound(i)+1));
    end
end
Guess21 = Guess21(1:3600/dt:end)';


Guess22 = Lowerbound + 1;
for i = 1:length(simdaycost) - (windowwidth + Timeforward)
    windowavgnow(i) = sum(simdaycost(i:i+windowwidth/5)) / (windowwidth / 5);
        windowavgforward(i) = sum(simdaycost(i+Timeforward:i+Timeforward+windowwidth)) / windowwidth;
    if windowavgforward(i) > 1.2 * windowavgnow(i)
        Guess22(i) = Guess22(i) + (windowavgforward(i) / windowavgnow(i) - 1) * 8.5;
        Guess22(i) = min(meanline(i), max(Guess22(i), Lowerbound(i)+1));
    end
end
Guess22 = Guess22(1:3600/dt:end)';

Guess23 = Lowerbound + 1;
for i = 1:length(simdaycost) - (windowwidth + Timeforward)
    windowavgnow(i) = sum(simdaycost(i:i+windowwidth/5)) / (windowwidth / 5);
        windowavgforward(i) = sum(simdaycost(i+Timeforward:i+Timeforward+windowwidth)) / windowwidth;
    if windowavgforward(i) > 1.2 * windowavgnow(i)
        Guess23(i) = Guess23(i) + (windowavgforward(i) / windowavgnow(i) - 1) * 5;
        Guess23(i) = min(meanline(i), max(Guess23(i), Lowerbound(i)+1));
    end
end
Guess23 = Guess23(1:3600/dt:end)';

windowwidth = 40;
Timeforward = 40;
windowavgnow = zeros(1, length(simdaycost));
windowavgforward = zeros(1, length(simdaycost));

Guess24 = Lowerbound + 1;
for i = 1:length(simdaycost) - (windowwidth + Timeforward)
    windowavgnow(i) = sum(simdaycost(i:i+windowwidth/2)) / (windowwidth / 2);
        windowavgforward(i) = sum(simdaycost(i+Timeforward:i+Timeforward+windowwidth)) / windowwidth;
    if windowavgforward(i) > 1.2 * windowavgnow(i)
        Guess24(i) = Guess24(i) + (windowavgforward(i) / windowavgnow(i) - 1) * 8;
        Guess24(i) = min(meanline(i), max(Guess24(i), Lowerbound(i)+1));
    end
end
Guess24 = Guess24(1:3600/dt:end)';


Guess25 = Lowerbound + 1;
for i = 1:length(simdaycost) - (windowwidth + Timeforward)
    windowavgnow(i) = sum(simdaycost(i:i+windowwidth/4)) / (windowwidth / 4);
        windowavgforward(i) = sum(simdaycost(i+Timeforward:i+Timeforward+windowwidth)) / windowwidth;
    if windowavgforward(i) > 1.2 * windowavgnow(i)
        Guess25(i) = Guess25(i) + (windowavgforward(i) / windowavgnow(i) - 1) * 8;
        Guess25(i) = min(meanline(i), max(Guess25(i), Lowerbound(i)+1));
    end
end
Guess25 = Guess25(1:3600/dt:end)';

windowwidth = 40;
Timeforward = 55;
windowavgnow = zeros(1, length(simdaycost));
windowavgforward = zeros(1, length(simdaycost));

Guesses = [Guess1, Guess2, Guess3, Guess4, Guess5, Guess6, Guess7, Guess8,... 
    Guess9, Guess10, Guess11, Guess12, Guess13, Guess14, Guess15, Guess16,... 
    Guess17, Guess18, Guess19, Guess20, Guess21, Guess22, Guess23, Guess24,...
    Guess25];


