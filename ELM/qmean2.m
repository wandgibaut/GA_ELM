% 05/05/2012
% qmean2.m
% Gives a kind of root mean square (quadratic mean) for the elements of
% two matrices, taken together.
%
function [rms] = qmean2(w1,w2)
[nr1,nc1] = size(w1);
v1 = reshape(w1,nr1*nc1,1);
[nr2,nc2] = size(w2);
v2 = reshape(w2,nr2*nc2,1);
v = [v1;v2];
n_v = length(v);
rms = sqrt(sum(v.*v)/n_v);
