for i = 1:length(t) - 1
    %Variable parameter functies

    %Q function
    q_rad_out(:,i) = Fq_rad_out();
    Q_rad_in(:,i) = FQ_rad_in();
    Q_solar(:,1) = FQ_solar();

    %Totale heat transfer
    Q_tot(:,i) = Q_rad_in(:,i) + Q_solar(:,i) - Area .* q_rad_out(:,i)

    %Temperatuur verandering
    T(:,i + 1) = T(:,i) + Q_tot(:,i) ./ Cap * dt
end