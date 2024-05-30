%% All values for the lamp from Katzin 2021, table 3.2
emmisivity_LED = 0.88; % Unitless
A_Lamp = 0.05*GH.p.GHFloorArea; % m^2
Q_in = 116*GH.p.GHFloorArea; % W
eta_LampPAR = 0.31; % Fraction of electrical input converted to PAR in J J^-1
eta_LampNIR = 0.02; % Fraction of electrical input converted to NIR in J J^-1
cap_Lamp = 10; % Heat capacity of the lamp in J K^-1 m^-2
conv_air = 2.3; % Heat exchange coefficient between air and the lamp
zeta_LampPAR = 5.2; %Photons per Joule in PAR emitted by the lamp in micromol J^-1
efficacy_Lamp = eta_LampPAR*zeta_LampPAR; % efficacy in photons of PAR emitted per joule of input
PPFD = efficacy_Lamp*Q_in; % Photosynthetic photon flux density(PPFD) of the lamps in micromol(PAR) s^-1