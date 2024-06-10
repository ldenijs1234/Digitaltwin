function T_sky = SkyTemperatureCalc(OutsideTemperature, CloudCover)
    sigma =  5.670374419e-8 ;

    cloud = CloudCover./100 ; % 0-1 cloud cover
    LdClear = 213+5.5*OutsideTemperature;                      % Equation 5.26 [Katzin, 2021]
    epsClear = LdClear./(sigma*(OutsideTemperature+273.15).^4);   % Equation 5.22 [Katzin, 2021]
    epsCloud = (1-0.84*cloud).*epsClear+0.84*cloud;             % Equation 5.32 [Katzin, 2021]
    LdCloud = epsCloud.*sigma.*(OutsideTemperature+273.15).^4;    % Equation 5.22 [Katzin, 2021]

    T_sky = (LdCloud/sigma).^(0.25)-273.15 ; % [Katzin, 2021]
end