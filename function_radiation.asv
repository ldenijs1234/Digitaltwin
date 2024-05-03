function q = Fq_rad_out(emissivity, T)                          %imput: n, emissivity array and T(:,i)
    q = 5.670374419*10^-8 * emissivity .* ((T + 273.15).^4);    %emittance of components
end                                                             %q(:,i) = F


function Q = FQ_rad_in(absorbance, diffuse, Area, Viewf, qrad)    %imput: parameter arrays, viewfactor matrix and q radiance array(:,i)
    Q = absorbance .* (Area .* Viewf * qrad);                  %how much each object absorbs
    Q(1,:) = sum(diffuse .* Area .* Viewf * qrad);               %inside air recieves diffused radiation
end


function Q = FQ_solar(transmission, diffuse, absorbance, Areasun, Isun)    %input: transmission of the cover, parameter arrays and I_sun(i)
    Q = [0; transmission; 1; transmission] .* absorbance .* Areasun * Isun;%absorbed sun radiation by each object
    Q(1,:) = sum(diffuse(3:end,:) .* Areasun(3:end,:) * Isun)              %inside air recieves diffused sun radiation of everything except cover
end