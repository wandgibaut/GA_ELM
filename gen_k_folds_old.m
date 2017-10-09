% 06/04/2016
% gen_k_folds.m
% Generation of k+2 folds from a single dataset containing X and S
% The (k+1)-th fold is for selection and the (k+2)-th fold is for test
% The test set is composed of samples uniformly distributed along the time series history
%

clear all;
filename = input('Filename of the original dataset (use single quotes): ');
% filename should contain matrices X and S
load(filename);
N = length(X(:,1));
disp(sprintf('Size of the original dataset = %d',N));
k = input('Number of folds: k = ');
% Generating the test fold
perct = input('Pencentual of the dataset to be associated with the test dataset = ');
Nt = round((perct/100)*N);
order = randperm(N);
Xt = [];St = [];
for i=1:Nt,
    Xt = [Xt;X(order(i),:)];
    St = [St;S(order(i),:)];
end
X(order(1:Nt),:) = [];
S(order(1:Nt),:) = [];
X1 = X;S1 = S;
X = Xt;S = St;
save test X S;
disp(sprintf('Size of the test fold = %d',Nt));
% The remaining samples will compose the selection fold and the k folds
X = X1;S = S1;
perc = input('Pencentual of the remaining dataset to be associated with the selection dataset = ');
N = length(X(:,1));
Ns = round((perc/100)*N);
disp(sprintf('Size of the selection fold = %d',Ns));
n_elem = floor((N-Ns)/k);
excess = mod((N-Ns),k);
order = randperm(N);
Xs = [];Ss = [];
for i=1:Ns,
    Xs = [Xs;X(order(i),:)];
    Ss = [Ss;S(order(i),:)];
end
X = Xs;S = Ss;
save selec X S;
X = X1;S = S1;
ind = Ns+1;
excess1 = excess;
Nelem = [];
for i=1:k,
    for j=1:n_elem,
        Xfold(j,:,i) = X(order(ind),:);
        Sfold(j,:,i) = S(order(ind),:);
        ind = ind+1;
    end
    if excess1 > 0,
        Xfold(n_elem+1,:,i) = X(order(ind),:);
        Sfold(n_elem+1,:,i) = S(order(ind),:);
        ind = ind+1;
        excess1 = excess1-1;
        Nelem = [Nelem;n_elem+1];
    else
        Nelem = [Nelem;n_elem];
    end
end
excess1 = excess;
if ~isempty(findstr(filename,'.mat')),
    filename = strrep(filename,'.mat','');
end
for i=1:k,
    if excess1 > 0,
        X = Xfold(1:(n_elem+1),:,i);
        S = Sfold(1:(n_elem+1),:,i);
        save(strcat(filename,sprintf('%d',i)),'X','S');
        excess1 = excess1-1;
    else
        X = Xfold(1:(n_elem),:,i);
        S = Sfold(1:(n_elem),:,i);
        save(strcat(filename,sprintf('%d',i)),'X','S');
    end
end
disp(sprintf('Size of the %d folds:',k));
disp(Nelem);
