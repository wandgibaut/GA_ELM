function [options numberOfVariables] = configureGA(lambda)
%options = optimset(@ga, 'Vectorized','on');

numberOfVariables = length(lambda);

%FitnessFunction = @(lamda) calc_error_ELM(ELM,Xv,lambda,s);
% mudar valores: -10000 -- 10000; 10000; 100; 
options = gaoptimset('Vectorized','off','PopInitRange', [-10000; 10000], 'PopulationSize', 1000, 'Generations', 50, 'FitnessLimit', 0.02, 'SelectionFcn',@rankSelection, 'MutationFcn', {@mutationgaussian, 1, 0.8}, 'EliteCount',5);
%options = gaoptimset('Vectorized','off','PopInitRange', [-10000; 10000], 'PopulationSize', 300, 'Generations', 10, 'FitnessLimit', 0.02);

%[x,fval] = ga(FitnessFunction,numberOfVariables,[],[],[],[],[],[],[],options)

end