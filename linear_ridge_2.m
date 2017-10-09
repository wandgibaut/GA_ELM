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


% load('test.mat');
load('train.mat');
N = length(X(:,1));

%media do comite
r=1;
S_ens_mean = zeros(N,r);
for fold=1:k,
    S_pred_validation = X*betha_final_fold(:,fold);
    
    verro_ens = reshape(S-S_pred_validation,N*r,1);
    eqm_ens = sqrt((1/(N*r))*(verro_ens'*verro_ens));
    disp(sprintf('Mean squared error for weigth in test.mat = %.12g',eqm_ens));
    
    S_ens_mean = S_ens_mean+S_pred_validation;
end
S_ens_mean = S_ens_mean./k;

S_ens_mean = sqrt(S_ens_mean.^2);
S_ens_mean = normalize_var(S_ens_mean,0,1);
S = normalize_var(S,0,1);

verro_ens = reshape(S-S_ens_mean,N*r,1);
eqm_ens = sqrt((1/(N*r))*(verro_ens'*verro_ens));
disp(sprintf('Ensemble: Mean squared error in test.mat = %.12g',eqm_ens));
figure(k+2);
plot(S,'k');hold on;plot(S_ens_mean,'r');hold off;
title('Desired output (black) X Prediction of the ensemble (red)');

r=1;
%%%%%%%%%%%%%% ols %%%%%%%%%
load('selec.mat'); %obter os pesos da combinacao ols dos preditores
N = length(X(:,1));
for fold=1:k,
    S_pred = X*betha_final_fold(:,fold);
    verro_ens = reshape(S-S_pred,N*r,1);
    eqm_ens = sqrt((1/(N*r))*(verro_ens'*verro_ens));
    disp(sprintf('Mean squared error for ols in selec.mat = %.12g',eqm_ens));
    
    H(:,fold) = S_pred';
end

theta = (pinv(H'*H))*H'*S;
theta = normalize_var(theta,1,-1);
% 
% load('test.mat');
load('train.mat');
N = length(X(:,1));
for fold=1:k,
    S_pred_test = X*betha_final_fold(:,fold);
    verro_ens = reshape(S-S_pred_test,N*r,1);
    eqm_ens = sqrt((1/(N*r))*(verro_ens'*verro_ens));
    disp(sprintf('Mean squared error for ols in test.mat = %.12g',eqm_ens));
    
    Htest(:,fold) = S_pred_test';
end

S_ens_ols = Htest*theta;

S_ens_ols = sqrt(S_ens_ols.^2);
S_ens_ols = normalize_var(S_ens_ols,0,1);
S = normalize_var(S,0,1);
 
verro_ens = reshape(S-S_ens_ols,N*r,1);
eqm_ens = sqrt((1/(N*r))*(verro_ens'*verro_ens));
disp(sprintf('Ensemble: Mean squared error in test.mat = %.12g',eqm_ens));
figure(k+3);
plot(S,'k');hold on;plot(S_ens_ols,'r');hold off;
title('Desired output (black) X Prediction of the ensemble (red)');

%%%%%%%%%%%%%% lasso %%%%%%%%%
load('selec.mat'); %obter os pesos da combinacao ols dos preditores
N = length(X(:,1));
for fold=1:k,
    S_pred = X*betha_final_fold(:,fold);
    verro_ens = reshape(S-S_pred,N*r,1);
    eqm_ens = sqrt((1/(N*r))*(verro_ens'*verro_ens));
    disp(sprintf('Mean squared error for lasso in selec.mat = %.12g',eqm_ens));
    
    Hlasso(:,fold) = S_pred';
end

t=10;
%Hlasso = [reshape(S_pred,N,k)];
[theta, ~,~] = LassoActiveSet(Hlasso,S,t);
%theta = normalize_var(theta,-1,1);

% load('test.mat');
load('train.mat');
N = length(X(:,1));
for fold=1:k,
    S_pred_test = X*betha_final_fold(:,fold);
    verro_ens = reshape(S-S_pred_test,N*r,1);
    eqm_ens = sqrt((1/(N*r))*(verro_ens'*verro_ens));
    disp(sprintf('Mean squared error for lasso in test.mat = %.12g',eqm_ens));
    
    Htest(:,fold) = S_pred_test';
end

S_ens_lasso = Htest*theta;

S_ens_lasso = sqrt(S_ens_lasso.^2);
S_ens_lasso = normalize_var(S_ens_lasso,0,1);
S = normalize_var(S,0,1);
 
verro_ens = reshape(S-S_ens_lasso,N*r,1);
eqm_ens = sqrt((1/(N*r))*(verro_ens'*verro_ens));
disp(sprintf('Ensemble: Mean squared error for lasso in test.mat = %.12g',eqm_ens));
figure(k+4);
plot(S,'k');hold on;plot(S_ens_lasso,'r');hold off;
title('Desired output (black) X Prediction of the ensemble (red)');







