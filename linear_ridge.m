% Ridge regression
clear all;
close all;
filename = input('Filename root of the folds (use single quotes): ');
% User defined parameters
k = input('Number of folds: k = ');

expoente = linspace(-24,25,50);
lambda = 2.^expoente;
for fold=1:k,
   disp(sprintf('Fold = %d',fold));
   Xacc = [];Sacc = [];
   for i=1:k,
        if i~=fold,
            load(strcat(filename,sprintf('%d',i)));
            Xacc = [Xacc;X];Sacc = [Sacc;S];
        else
            load(strcat(filename,sprintf('%d',i)));
            Xv = X;
            Sv = S;
        end
   end
   
   betha = ridge(Sacc,Xacc,lambda); %por pra cada 1 dos preditores ja
%    betha = ridge(Sacc,Xacc,lambda,0); %por pra cada 1 dos preditores ja
   S_pred_validation = Xv*betha;
   

% seleciona os vetores 'betha' q minimizam o erro de validacao
    for i=1:length(lambda)
        verro(:,i) = Sv-S_pred_validation(:,i);
        eqm(i) = sqrt((1/(length(verro)))*(verro(:,i)'*verro(:,i)));
    end
    
    [eqm_min, I] = min(eqm);
    betha_final_fold(:,fold) = betha(:,I);
    eqm_fold(fold) = eqm_min;
   
end









