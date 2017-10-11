% 31/05/2017 - FEEC/Unicamp
% gen_k_folds.m
% Generation of k folds from a single dataset containing X and S
%
function [] = gen_k_folds(filename,k)
load(filename);
N = length(X(:,1));
n_elem = floor(N/k);
excess = mod(N,k);
order = randperm(N);
ind = 1;
excess1 = excess;
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
