

    function [h_top, h_wall] = ConvCoefficients(GH, T_wall, T_out, Windspeed, H_out, C_out, W_angle, p)
    %inputs from outside this code block

    W = GH.p.GHWidth; % width of the building in meters
    L = GH.p.GHLength; % length of the building in meters
    H = GH.p.GHHeight; % height of the building in meters
    g = 9.81; % gravitational constant

    T_wall = T_wall; % temperature of the outside wall
    T = T_out; % air temperature in celsius
    %p = 1084; % air pressure in hpa
    V = Windspeed; % wind speed in m/s
    h_abs = H_out*1000; % absolute humidity of the outside air in g/m^3
    C = 2.16679; % constant in gK/J
    CO2 = C_out*1000; % CO2 in the outside air in g/m^3



    %% calculted inputs for the funtion
    mol_air = (p.*100./((T+273.15).*GH.p.GasConstantR)); % using the ideal gas law to find the amount of mol in air
    mol_co2 = CO2/44.01;
    co2 = mol_co2/mol_air;
    P_w = h_abs.*(T+273.15)/C; % water vapour pressure
    P_ws = 6.116441*10^(7.591386*(T)/(T+240.7263));  % saturation vapour pressure
    h = max(0, min(100, P_w/P_ws)); % relative humidity for range -20 to +50 celsius
    dT = T-T_wall; % temperature difference
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

    CL = W*L*H/(2*W*H+2*W*L+2*L*H); % caracteristic length of the greenhouse in meters
    CL_r = W*L/(2*L+2*W); % caracteristic length of the roof
    Re = V.*CL.*rho./mu; %reynolds number for the building
    Gr = beta.*abs(dT).*g.*CL^3 / (mu/rho).^2; %grashoff number for the building
    x_tr = (10.^9 .* (mu./rho).^2 ./ (beta.*abs(dT).*g)).^(1/3); % transition point from laminar to turbulent flow
    Ra = g.*beta.*abs(dT).*CL_r^3 ./((mu/rho).*alpha); % Raleigh number 

    %%deciding which wall(s) are in the wind and which are not.
    switch true
        case 0 <= W_angle && W_angle <= 45
            w_angle = W_angle;
            A_13 = W*H; % area of wall 1 and 3
            A_24 = L*H; % area of wall 2 and 4

        case 45 < W_angle && W_angle <= 90
            w_angle = -1*(W_angle-90);
            A_13 = L*H; % area of wall 1 and 3
            A_24 = W*H; % area of wall 2 and 4

        case 90 < W_angle && W_angle <= 135
            w_angle = W_angle-90;
            A_13 = L*H; % area of wall 1 and 3
            A_24 = W*H; % area of wall 2 and 4

        case 135 < W_angle && W_angle <= 180
            w_angle = -1*(W_angle-180);
            A_13 = W*H; % area of wall 1 and 3
            A_24 = L*H; % area of wall 2 and 4

        case 180 < W_angle && W_angle <= 225
            w_angle = W_angle-180;
            A_13 = W*H; % area of wall 1 and 3
            A_24 = L*H; % area of wall 2 and 4

        case 225 < W_angle && W_angle <= 270
            w_angle = -1*(W_angle-270);
            A_13 = L*H; % area of wall 1 and 3
            A_24 = W*H; % area of wall 2 and 4

        case 270 < W_angle && W_angle <= 315
            w_angle = W_angle-270;
            A_13 = L*H; % area of wall 1 and 3
            A_24 = W*H; % area of wall 2 and 4

        case 315 < W_angle && W_angle <= 360
            w_angle = -1*(W_angle-360);
            A_13 = W*H; % area of wall 1 and 3
            A_24 = L*H; % area of wall 2 and 4
    end

    %% calculating convection coeifficient in case of forced convection
    if V ~= 0
        switch true

            case w_angle == 0 
                lnNU_ww = 6.222 - 0.3110 .* log(Re) + 0.00007340 .* log(Gr) + 0.02304 .* (log(Re)).^2 .* - 0.000007894 .* log(Re) .* log(Gr); % all found by RSM fitting, wind ward side
                lnNU_lw = 13.52 - 2.102.*log(Re) - 0.003229.*log(Gr) + 0.1308*(log(Re)).^2 + 0.0004581.*log(Re).*log(Gr); % the leeward side
                lnNU_t_s = 7.463 - 0.5098*log(Re) + 0.008807*log(Gr)+ 0.03375*(log(Re)).^2 - 0.001067.*log(Re).*log(Gr); % here the top side and the sides parralel to the wind have the same value

                wall_1 = lnNU_ww; % wall directly out the wind
                wall_2 = lnNU_t_s; % wall on clockwise succession of wall_1
                wall_3 = lnNU_lw; % wall directly opposing wall_1
                wall_4 = lnNU_t_s; % wall on the counter clockwise succession of wall_1
                top = lnNU_t_s; % top of the building

            case 30 <= w_angle && w_angle <= 45
                lnNU_ww = 8.809 - 1.037*log(Re) + 0.03020*log(Gr) + 0.07366*(log(Re)).^2 - 0.003685*log(Re).*log(Gr); % The 2 walls that are in the wind 
                lnNU_lw1 = 7.954 - 0.7279*log(Re) + 0.02842*log(Gr)+ 0.04606*(log(Re)).^2 - 0.003473*log(Re).*log(Gr); % side out of the wind but most parralel to the wind from the 2 sides out of the wind
                lnNU_lw2 = 6.255 - 0.3253*log(Re) + 0.02174*log(Gr) + 0.02311*(log(Re)).^2 - 0.002593*log(Re).*log(Gr); % side out of the wind that is not lw1
                lnNU_t = 7.463 - 0.5098*log(Re) + 0.008807*log(Gr)+ 0.03375*(log(Re)).^2 - 0.001067*log(Re).*log(Gr); % top side, this is the same for the 0 degree case

                wall_1 = lnNU_ww; % wall directly in the wind
                wall_2 = lnNU_lw1; % wall on clockwise succession of wall_1
                wall_3 = lnNU_lw2; % wall directly opposing wall_1
                wall_4 = lnNU_ww; % wall on the counter clockwise succession of wall_1
                top = lnNU_t; % top of the building
        
            case 0 < w_angle && w_angle < 30 
                lnNU_ww1 = 6.222 - 0.3110 * log(Re) + 0.00007340 * log(Gr) + 0.02304 * (log(Re)).^2 * - 0.000007894 .* log(Re) .* log(Gr);
                lnNU_lw11 = 13.52 - 2.102*log(Re) - 0.003229*log(Gr) + 0.1308*(log(Re)).^2 + 0.0004581*log(Re).*log(Gr); 
                lnNU_t_s = 7.463 - 0.5098*log(Re) + 0.008807*log(Gr)+ 0.03375*(log(Re)).^2 - 0.001067*log(Re).*log(Gr); 
                lnNU_ww22 = 8.809 - 1.037*log(Re) + 0.03020*log(Gr) + 0.07366*(log(Re)).^2 - 0.003685*log(Re).*log(Gr);
                lnNU_lw12 = 7.954 - 0.7279*log(Re) + 0.02842*log(Gr)+ 0.04606*(log(Re)).^2 - 0.003473*log(Re).*log(Gr); 
                lnNU_lw22 = 6.255 - 0.3253*log(Re) + 0.02174*log(Gr) + 0.02311*(log(Re)).^2 - 0.002593*log(Re).*log(Gr); 
                lnNU_t = 7.463 - 0.5098*log(Re) + 0.008807*log(Gr)+ 0.03375*(log(Re)).^2 - 0.001067*log(Re).*log(Gr); 

                wall_1 = lnNU_ww1 + (lnNU_ww22 - lnNU_ww1).*(w_angle/30); % wall directly out the wind
                wall_2 = lnNU_lw11 + (lnNU_lw22-lnNU_lw11).*(w_angle/30); % wall on clockwise succession of wall_1
                wall_3 = lnNU_t_s + (lnNU_lw12 - lnNU_t_s).*(w_angle/30); % wall directly opposing wall_1
                wall_4 = lnNU_t_s + (lnNU_ww22- lnNU_t_s).*(w_angle/30); % wall on the counter clockwise succession of wall_1
                top = lnNU_t; % top of the building
        end


        %%outputs of this code block
        h_wall_1 = exp(wall_1).*k/CL; % convective heating coefficients of the different walls
        h_wall_2 = exp(wall_2).*k/CL;
        h_wall_3 = exp(wall_3).*k/CL;
        h_wall_4 = exp(wall_4).*k/CL;
        h_top = exp(top).*k/CL;

        A = 2*L*H+2*W*H;% total area of the walls
        h_wall = (A_13*h_wall_1+A_24*h_wall_2+A_13*h_wall_3+A_24*h_wall_4)/A; % average convective heat transfer coefficient of the walls
    end

    %% Calculating convection coefficient in case of natural convection
    if V == 0 
        if H > x_tr
            h_wall = (1/H)*(1.07*4*abs(dT).^0.25 * x_tr.^(1/3) /3 + 1.3*(H-x_tr).*abs(dT).^(1/3));
        end
        if H <= x_tr
            h_wall = (1/H)*(1.07*4*abs(dT).^0.25 * H^(1/3)) /3;
        end
        if T_wall > T
            if Ra <= 10^7
                h_top = k.*0.54.*Ra.^0.25 ./CL_r;
            end
            if Ra > 10^7
                h_top = k.*0.15.*Ra.^(1/3) ./CL_r;
            end
        end
        if T_wall <= T
            h_top = k.*0.27.*Ra.^0.25 ./ CL_r;
        end
    end
end


