
function [h_insidewall,h_ceiling] = inside_convection(GH, T_wall,T_ceiling,T_in)
    W = GH.p.GHWidth; % width of the building in meters
    L = GH.p.GHLength; % length of the building in meters
    H = GH.p.GHHeight; % height of the building in meters
    g = 9.81; % gravitational constant

    humidity = 0.012;
    co_2 = 0.000464;
    T = T_in; % air temperature in celsius
    p = 1084; % air pressure in hpa
    h_abs = humidity*1000; % absolute humidity of the outside air in g/m^3
    C = 2.16679; % constant in gK/J
    CO2 = co_2*1000; % CO2 in the outside air in g/m^3



    %% calculted inputs for the funtion
    mol_air = (p.*100./((T+273.15).*GH.p.GasConstantR)); % using the ideal gas law to find the amount of mol in air
    mol_co2 = CO2/44.01;
    co2 = mol_co2/mol_air;
    P_w = h_abs.*(T+273.15)/C; % water vapour pressure
    P_ws = 6.116441*10^(7.591386*(T)/(T+240.7263));  % saturation vapour pressure
    h = max(0,min(100,P_w/P_ws)); % relative humidity for range -20 to +50 celsius
    dT = T-T_wall; % temperature difference between wall and air
    dT_c = T-T_ceiling;
    mu = AirProperties(T,p,h,'xCO2',co2,'mu'); % dynamic viscosity of the air
    rho = AirProperties(T,p,h,'xCO2',co2,'rho'); % density of the air
    k = AirProperties(T,p,h,'xCO2',co2,'k'); % thermal conductivity 
    alpha = AirProperties(T,p,h,'xCO2',co2,'alpha'); % thermal diffusivity


    % beta is the derivative of the volume to temperature change and then
    % devided by the volume
    T2 = T + 0.001; % small temperature change
    rho_2 = AirProperties(T2,p,h,'xCO2',co2,'rho'); % density for this slightly different temperature
    v_1 = (1./rho).*1000; % volume for 1kg of air with the normal density
    v_2 = (1./rho_2).*1000; % volume for 1kg of air with the alterd density
    beta = ((v_2-v_1)./(T2-T))./v_1; % volumetric coefficient of expansion

    CL_r = W*L/(2*L+2*W); % caracteristic length of the roof
    x_tr = (10.^9 .* (mu./rho).^2 ./ (beta.*abs(dT).*g)).^(1/3); % transition point from laminar to turbulent flow
    Ra = g.*beta.*abs(dT_c).*CL_r^3 ./((mu/rho).*alpha); % Raleigh number 
    
    if H > x_tr
        h_insidewall = (1/H)*(1.07*4*abs(dT).^0.25 * x_tr.^(1/3) /3 + 1.3*(H-x_tr).*abs(dT).^(1/3));
    elseif H <= x_tr
        h_insidewall = (1/H)*(1.07*4*abs(dT).^0.25 * H^(1/3)) /3;
    end

    if T_ceiling < T
        if Ra <= 10^7
            h_ceiling = k.*0.54.*Ra.^0.25 ./CL_r;
        elseif Ra > 10^7
            h_ceiling = k.*0.15.*Ra.^(1/3) ./CL_r;
        end
    elseif T_ceiling >= T
        h_ceiling = k.*0.27.*Ra.^0.25 ./ CL_r;
    end
end