% 05/05/2012
% qmean.m
% Gives the root mean square (quadratic mean) for the elements of
% one vector or one matrix.
%
function [rms] = qmean(w)
[nr,nc] = size(w);
v = reshape(w,nr*nc,1);
n_v = length(v);
rms = sqrt(sum(v.*v)/n_v);
