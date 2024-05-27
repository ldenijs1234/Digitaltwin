% ff plot

figure("WindowStyle", "docked");
hold on
plot(t(1:end-1)/3600, ControllerOutputWatt)
xlabel("Time (h)")
ylabel("Boiler input (W)")
legend('Heatpipe')
hold off