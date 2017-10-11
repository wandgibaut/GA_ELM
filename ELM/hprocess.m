%
% function [s] = hprocess(X,S,w1,w2,p1,p2)
% s = product H*p (computed exactly)
%
function [s] = hprocess(X,S,w1,w2,p1,p2)
[N,n_in] = size(X);
n_hid = length(w1(:,1));
n_out = length(S(1,:));
x1 = [X ones(N,1)];
rx1 = zeros(N,n_in+1);
y1 = tanh(x1*w1');
ry1 = (x1*p1'+rx1*w1').*(1.0-y1.*y1);
x2 = [y1 ones(N,1)];
rx2 = [ry1 zeros(N,1)];
% y2 = tanh(x2*w2');
y2 = x2*w2';
% ry2 = (x2*p2'+rx2*w2').*(1.0-y2.*y2);
ry2 = x2*p2'+rx2*w2';
erro = y2-S;
% erro2 = erro.*(1.0-y2.*y2);
erro2 = erro;
rerro2 = ry2;
rw2 = erro2'*rx2+rerro2'*x2;
erro1 = (erro2*w2(:,1:n_hid)).*(1.0-y1.*y1);
rerro1 = (rerro2*w2(:,1:n_hid)+erro2*p2(:,1:n_hid)).*(1.0-y1.*y1)+(erro2*w2(:,1:n_hid)).*(-2*y1.*ry1);
rw1 = erro1'*rx1+rerro1'*x1;
rEw = [reshape(rw1',n_hid*(n_in+1),1);reshape(rw2',n_out*(n_hid+1),1)];
s = rEw;
