% ff plot

% figure("WindowStyle", "docked");
% hold on
% plot(t/3600, T(:,:))
% plot(t/3600, OutsideTemperature, 'b--')
% plot(t/3600, heatingline, 'r--')
% plot(t/3600, coolingline, 'r--') 
% % plot(t(1:end-1)/3600, error)
% title("Temperatures in the greenhouse")
% xlabel("Time (h)")
% ylabel("Temperature (°C)")
% legend('Air', 'Cover', 'Walls', 'Floor', 'Plant', 'Heatpipe','Outside', 'Setpoint', 'error')
% hold off

figure("WindowStyle", "docked");
hold on
plot(t(1:end-1), Q_vent(1,:)) 
plot(t(1:end-1), Q_conv(1,:))
plot(t(1:end-1), Q_solar(1,:))
plot(t(1:end-1), Q_rad_in(1,:) - Q_rad_out(1,:))
plot(t(1:end-1), Q_latent(1,:))
plot(t(1:end-1), Q_tot(1,:))
legend('vent', 'convection', 'solar','radiation', 'latent', 'total')
title('Air Heat Flows')
hold off

% figure("WindowStyle", "docked");
% hold on
% plot(t(1:end-1), Q_sky(2,:)) 
% plot(t(1:end-1), Q_conv(2,:))
% plot(t(1:end-1), Q_solar(2,:))
% plot(t(1:end-1), Q_rad_in(2,:) - Q_rad_out(2,:))
% plot(t(1:end-1), Q_tot(2,:))
% legend('sky', 'convection', 'solar','radiation', 'total')
% title('Cover Heat Flows')
% hold off

% figure("WindowStyle", "docked");
% hold on
% plot(t(1:end-1), Q_sky(3,:)) 
% plot(t(1:end-1), Q_conv(3,:))
% plot(t(1:end-1), Q_solar(3,:))
% plot(t(1:end-1), Q_rad_in(3,:) - Q_rad_out(3,:))
% plot(t(1:end-1), Q_tot(3,:))
% legend('sky', 'convection', 'solar','radiation', 'total')
% title('Wall Heat Flows')
% hold off

% figure("WindowStyle", "docked");
% hold on
% plot(t(1:end-1), Q_conv(4,:))
% plot(t(1:end-1), Q_solar(4,:))
% plot(t(1:end-1), Q_rad_in(4,:) - Q_rad_out(4,:))
% plot(t(1:end-1), Q_ground(4,:)) 
% plot(t(1:end-1), Q_tot(4,:))
% legend('convection', 'solar','radiation','ground', 'total')
% title('Floor Heat Flows')
% hold off

% figure("WindowStyle", "docked");
% hold on
% plot(t(1:end-1), Q_conv(5,:))
% plot(t(1:end-1), Q_solar(5,:))
% plot(t(1:end-1), Q_rad_in(5,:) - Q_rad_out(5,:))
% plot(t(1:end-1), Q_latent(5,:))
% plot(t(1:end-1), Q_tot(5,:))
% legend('convection', 'solar','radiation', 'latent', 'total')
% title('Plant Heat Flows')
% hold off

figure("WindowStyle", "docked");
hold on 
plot(t(1:end-1), Q_conv(6,:))
plot(t(1:end-1), Q_solar(6,:))
plot(t(1:end-1), Q_rad_in(6,:) - Q_rad_out(6,:))
plot(t(1:end-1), Q_heat(6, :))
plot(t(1:end-1), Q_tot(6,:))
legend( 'convection', 'solar','radiation','heat', 'total')
title('Pipe Heat Flows')
hold off

figure("WindowStyle", "docked");
hold on 
plot(t, T_WaterIn)
plot(t(1:end-1), T_WaterOut)
legend('In', 'Out')
title("Temperature water into heating pipe")
hold off

% figure("WindowStyle", "docked");
% hold on
% plot(t/3600, T(:,:))
% plot(t/3600, OutsideTemperature, 'b--')
% plot(t/3600, setpoint, 'r--') 
% title("Temperatures in the greenhouse")
% xlabel("Time (h)")
% ylabel("Temperature (°C)")
% legend('Air', 'Cover', 'Walls', 'Floor', 'Plant', 'Heatpipe','Outside', 'Setpoint')
% hold off

figure("WindowStyle", "docked");
hold on
plot(t(1:end-1)/3600, ControllerOutputWatt)
plot(t/3600, heatingerror)
xlabel("Time (h)")
ylabel("Boiler input (W)")
legend('Controller Boiler')
hold off

figure("WindowStyle", "docked");
hold on
plot(t(1:end-1)/3600, OpenWindowAngle)
plot(t(1:end-1)/3600, coolingerror)
xlabel("Time (h)")
ylabel("OpenWindowAngle")
legend('Controller Window', 'error')
hold off

% figure("WindowStyle", "docked")
% hold on
% plot(t/3600, AddStates(1,:))
% plot(t/3600, OutsideHumidity)
% legend("Indoor Humidity", "Outside Humdity")
% title("Humidity")
% hold off

% figure("WindowStyle", "docked")
% hold on
% plot(t/3600, AddStates(3,:))
% % plot(t/3600, AddStates(4,:))
% legend("DryWeight")
% hold off

figure("WindowStyle", "docked")
hold on
plot(t(1:end-1)/3600, RelHumidity)
legend("RelHumidity")
hold off

figure("WindowStyle", "docked")
hold on
plot(t/3600, W_trans)
plot(t/3600, W_cond)
plot(t/3600, W_vent)
plot(t/3600, W_fog)
legend("trans", "cond", "vent", "fog")
title("Humidity flows")
hold off

% figure("WindowStyle", "docked")
% hold on
% plot(t/3600, SolarIntensity)
% plot(t/3600, SolarRadiation)
% title("Solar Intensity")
% hold off