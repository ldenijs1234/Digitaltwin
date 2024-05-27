
%Testin script

Simstart = time_steps*1 + 1 ;
Simend = time_steps *2 ;


OutsideTemperatureT = OutsideTemperatureF(Simstart:Simend) ; OutsideRelhumidity = OutsideRelhumidityF(Simstart:Simend) ;
SolarRadiation = SolarRadiationF(Simstart:Simend) ; WindSpeed = WindspeedF(Simstart:Simend) ; Winddirection = WinddirectionF(Simstart:Simend) ;
Sealevelpressure = SealevelpressureF(Simstart:Simend) ; CloudCover = CloudCoverF(Simstart:Simend) ; DewPoint = DewPointF(Simstart:Simend) ;