% 05/05/2012
% function [Ew,dEw,Ewv,eqm,eqmv] = process(X,S,Xv,Sv,w1,w2,n,m,N,Nv)
% Output:  Ew: Squared error for the training dataset
%         dEw: Gradient vector for the training dataset
%         Ewv: Squared error for the validation dataset
% Presentation of input-output patterns: batch mode
% All neurons have bias
%
function [Ew,dEw,Ewv,eqm,eqmv] = process(X,S,Xv,Sv,w1,w2)
[N,n_in] = size(X);
n_hid = length(w1(:,1));
n_out = length(S(1,:));
Nv = length(Xv(:,1));
x1 = [X ones(N,1)];
y1 = tanh(x1*w1');
x2 = [y1 ones(N,1)];
% y2 = tanh(x2*w2');
y2 = x2*w2';
erro = y2-S;
% erro2 = erro.*(1.0-y2.*y2);
erro2 = erro;
dw2 = erro2'*x2;
erro1 = (erro2*w2(:,1:n_hid)).*(1.0-y1.*y1);
dw1 = erro1'*x1;
verro = reshape(erro,N*n_out,1);
Ew = 0.5*(verro'*verro);
eqm = sqrt((1/(N*n_out))*(verro'*verro));
dEw = [reshape(dw1',n_hid*(n_in+1),1);reshape(dw2',n_out*(n_hid+1),1)];
x1v = [Xv ones(Nv,1)];
y1v = tanh(x1v*w1');
x2v = [y1v ones(Nv,1)];
% y2v = tanh(x2v*w2');
y2v = x2v*w2';
errov = y2v-Sv;
verrov = reshape(errov,Nv*n_out,1);
Ewv = 0.5*(verrov'*verrov);
eqmv = sqrt((1/(Nv*n_out))*(verrov'*verrov));
