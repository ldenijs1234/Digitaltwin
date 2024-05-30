%Verassing

function HardPush()
    figure()
    hold on
    th = 0:pi/50:2*pi;
    xunit = 1 * cos(th) + -1;
    yunit = 1 * sin(th) + 0;
    h = plot(xunit, yunit);

    xunit = 1 * cos(th) + 1;
    yunit = 1 * sin(th) + 0;
    h = plot(xunit, yunit);
    xunit = [-1:pi/50:1];

    yunit = -8 * xunit.^2 + 8;
    h = plot(xunit, yunit);
    title('Bergs leutertje')
    hold off
end