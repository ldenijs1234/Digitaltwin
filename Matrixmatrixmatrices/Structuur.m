for i = 1:length(t) - 1
    %Variable parameter functies (+ convection rate, ventilation rate...)

    %Q functions (+ convection conduction...)
    q_rad_out(:,i) = Fq_rad_out(EmmitanceArray, T(:,i));
    Q_rad_in(:,i) = FQ_rad_in(AbsorbanceArray, DiffuseArray, AreaArray, ViewArray, q_rad_out(:,i));
    Q_solar(:,1) = FQ_solar(TauGlass, DiffuseArray, AbsorbanceArray, 700);
    Q_HF(:,i) = HeatFlow(:, i) + convection(ConvectionCoefficientsIn, ConvectionCoefficientsOut, T(:,i), OutsideTemperature, AreaArray);
    %Totale heat transfer
    Q_tot(:,i) = Q_rad_in(:,i) + Q_solar(:,i) - Area .* q_rad_out(:,i) + Q_HF(:,i);

    %Temperatuur verandering
    T(:,i + 1) = T(:,i) + Q_tot(:,i) ./ Cap * dt;
end

plot(t,T)
legend('T air', 'T cover', 'T floor', 'T plant')