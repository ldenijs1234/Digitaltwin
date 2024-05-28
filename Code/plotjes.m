% ff plot

% figure("WindowStyle", "docked");
% hold on
% plot(t(1:end-1), Q_vent(1,:)) 
% plot(t(1:end-1), Q_sky(1,:)) 
% plot(t(1:end-1), Q_conv(1,:))
% plot(t(1:end-1), Q_solar(1,:))
% plot(t(1:end-1), Q_rad_in(1,:) - AreaArrayRad(1) * q_rad_out(1,:))
% plot(t(1:end-1), Q_ground(1,:)) 
% plot(t(1:end-1), Q_tot(1,:))
% legend('vent', 'sky', 'convection', 'solar','radiation','ground', 'total')
% title('Air Heat Flows')
% hold off

% figure("WindowStyle", "docked");
% hold on
% plot(t(1:end-1), Q_vent(3,:)) 
% plot(t(1:end-1), Q_sky(3,:)) 
% plot(t(1:end-1), Q_conv(3,:))
% plot(t(1:end-1), Q_solar(3,:))
% plot(t(1:end-1), Q_rad_in(3,:) - AreaArrayRad(3) * q_rad_out(3,:))
% plot(t(1:end-1), Q_ground(3,:)) 
% plot(t(1:end-1), Q_tot(3,:))
% legend('vent', 'sky', 'convection', 'solar','radiation','ground', 'total')
% title('Wall Heat Flows')
% hold off

figure("WindowStyle", "docked");
hold on
plot(t(1:end-1), Q_vent(5,:)) 
plot(t(1:end-1), Q_sky(5,:)) 
plot(t(1:end-1), Q_conv(5,:))
plot(t(1:end-1), Q_solar(5,:))
plot(t(1:end-1), Q_rad_in(5,:) - AreaArrayRad(5) * q_rad_out(5,:))
plot(t(1:end-1), Q_ground(5,:)) 
plot(t(1:end-1), Q_tot(5,:))
legend('vent', 'sky', 'convection', 'solar','radiation','ground', 'total')
title('Plant Heat Flows')
hold off

figure("WindowStyle", "docked");
hold on
plot(t/3600, T(:,:))
plot(t/3600, OutsideTemperature, 'b--')
plot(t/3600, setpoint, 'r--') 
title("Temperatures in the greenhouse")
xlabel("Time (h)")
ylabel("Temperature (°C)")
legend('Air', 'Cover', 'Walls', 'Floor', 'Plant', 'Heatpipe','Outside', 'Setpoint')
hold off

figure("WindowStyle", "docked");
hold on
plot(t(1:end-1)/3600, ControllerOutputWatt)
xlabel("Time (h)")
ylabel("Boiler input (W)")
legend('Heatpipe')
hold off