% 05/05/2012

% Extreme Learning Machine

%Fonte: Kulaif, A.C.P. “Técnicas de regularização para máquinas de aprendizado extremo”, 
%Dissertação de Mestrado, Faculdade de Engenharia Elétrica e de Computação, Unicamp, 2014.
%and tool box from prof Von Zuben

% nn1h.m (Neural network with one hidden layer)
% Required data for supervised learning
% train.mat, with X (input matrix) and S (output matrix)
% valid.mat, with Xv (input matrix) and Sv (output matrix)
%
clear all;format long;format compact;

filename = input('Filename root of the folds (use single quotes): ');
% User defined parameters
k = input('Number of folds: k = ');
n_hid = input('Number of neurons at the hidden layer = ');
disp('(1) Generate w10 and w20, and save');
disp('(2) Copy existing w10 and w20');
disp('(3) Copy existing w1 and w2');
resp = input('Type of weight generation: ');

%for regularization
expoente = linspace(-24,25,50);
c = 2.^expoente;
I = eye(n_hid+1);

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
    X = Xacc;S = Sacc;
    % X (input matrix [N]x[n_in]) and S (output matrix [N]x[n_out])
    % Xv (input matrix [Nv]x[n_in]) and Sv (output matrix [Nv]x[n_out])
    n_in = length(X(1,:));
    n_out = length(S(1,:));
    n_w = n_hid*(n_in+1)+n_out*(n_hid+1);
    if fold == 1,
        disp(sprintf('Number of inputs = %d',n_in));
        disp(sprintf('Number of outputs = %d',n_out));
        disp(sprintf('Number of weights in the neural network = %d',n_w));
    end
    N = length(X(:,1));disp(sprintf('Number of input-output patterns (training) = %d',N));
    Nv = length(Xv(:,1));disp(sprintf('Number of input-output patterns (validation) = %d',Nv));
    
    %because w1 is random
    n_times = 50;
    FinalTrainingAccuracy = 1;
    FinalValidatingAccuracy = 1;
    w2 = [];
    for i=1:n_times,
        
        % Random generation of the neural network weights,
        InputWeight = -0.1 + 0.2*rand(n_hid,n_in+1);
        OutputWeight = -0.1 + 0.2*rand(n_out,n_hid+1);
        % w1:[n_hid] x [n_in+1]  w2:[n_out] x [n_hid+1]

        H = [tanh([X ones(N,1)]*InputWeight') ones(N,1)];

        %%%%%%%%%%% Calculate the randomweight accuracy
        %S_estimado = H*w2';
        %RandomicAccuracy=sqrt(mse(S - S_estimado));               %   Calculate training accuracy (RMSE) for regression case

        % implementation without regularization factor
        %OutputWeight = (pinv(H'*H))*H'*S;                                
        
        %implementation with regularization
        for j=1:length(c),
            
            OutputWeight = (pinv(H'*H+c(i)*I))*H'*S;
            
            %%%%%%%%%%% Calculate the validating accuracy
            Hv = [tanh([Xv ones(Nv,1)]*InputWeight') ones(Nv,1)];
            S_estimado = Hv * OutputWeight;                             %   S_estimado: the actual output of the training data
%             ValidatingAccuracy=sqrt(mse(Sv - S_estimado));               %   Calculate training accuracy (RMSE) for regression case
            ValidatingAccuracy=qmean(Sv - S_estimado);
            if ValidatingAccuracy < FinalValidatingAccuracy,

                %%%%%%%%%%% Calculate the training accuracy
                S_estimado = H * OutputWeight;                             %   S_estimado: the actual output of the training data
%                 TrainingAccuracy=sqrt(mse(S - S_estimado));               %   Calculate training accuracy (RMSE) for regression case
                TrainingAccuracy=qmean(S - S_estimado);
                FinalTrainingAccuracy = TrainingAccuracy;

                FinalValidatingAccuracy = ValidatingAccuracy;
                w2 = OutputWeight';     
                w1 = InputWeight;
            end
        
            
            
        end
        


 
    end
    disp(sprintf('Final mean squared error (training) = %.12g',FinalTrainingAccuracy));
    disp(sprintf('Final mean squared error (validation) = %.12g',FinalValidatingAccuracy));
    save(strcat('w1v',sprintf('%d',fold)),'w1');
    save(strcat('w2v',sprintf('%d',fold)),'w2');
    save(strcat('w1',sprintf('%d',fold)),'w1');
    save(strcat('w2',sprintf('%d',fold)),'w2');
    
end


