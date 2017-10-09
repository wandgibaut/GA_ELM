function options = configureGA(lambda)
%options = optimset(@ga, 'Vectorized','on');

numberOfVariables = length(lambda);

options = optimset(@ga,'Vectorized','on','PopInitRange', [2^(-24); 2^(25)], 'PopulationSize', 1000, 'Generations', 1000, 'FitnessLimit', 0);

%[x,fval] = ga(FitnessFunction,numberOfVariables,[],[],[],[],[],[],[],options)

end