
function y = bound(min, max, t1, t2, t3, t4, dt, days) %inputs: minimum and maximum, minimum before t1 and after t4, maximum at t2:t3
    time = (0:dt:24*60^2) / 60^2;
    a = min * ones(1,round(length(time) * t1 / 24));
    b = linspace(min, max, round(length(time) * (t2 - t1) / 24));
    c = max * ones(1, round(length(time) * (t3 - t2)/ 24));
    d = linspace(max, min, round(length(time) * (t4 - t3) / 24));
    e = min * ones(1, round(length(time) * (24 - t4) /24));
    y = [a, b, c, d, e];
    y = [min, repmat(y, 1, days)];
end

