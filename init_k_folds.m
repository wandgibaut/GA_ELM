% 05/05/2012
% Random generation of the neural network weights, with
% uniform distribution in the interval [-0.1,+0.1]
% function [w1,w2,eq,eqv,stw1,stw2,rms_w,eqv_min,eqmv_min,niter_v,niter,nitermax] = init_k_folds(n_in,n_hid,n_out,fold,resp)
% n_in = number of inputs
% n_hid = number of neurons at the hidden layer
% n_out = number of neurons at the output layer
% w1, w2: Matrices of weights (one for each layer)
% w1: n_hid x (n_in+1)   w2: n_out x (n_hid+1)
% Type of weight generation:
% Option 1 -> Start the training from a random initial condition
% Option 2 -> Restart the training from the same initial condition
% Option 3 -> Restart the training from the last set of weights obtained
%             after training
%
function [w1,w2,eq,eqv,stw1,stw2,rms_w,eqv_min,eqmv_min,niter_v,niter,nitermax] = init_k_folds(n_in,n_hid,n_out,fold,resp)
if resp == 1;
	w1 = -0.1 + 0.2*rand(n_hid,n_in+1);
	w2 = -0.1 + 0.2*rand(n_out,n_hid+1);
    save(strcat('w10',sprintf('%d',fold)),'w1');
    save(strcat('w20',sprintf('%d',fold)),'w2');
	eq = [];eqv = [];stw1 = [];stw2 = [];rms_w = [];eqv_min = [];eqmv_min = [];niter_v = 0;niter = 1;
    nitermax = input('Maximum number of iterations = ');
elseif resp == 2,
    load(strcat('w10',sprintf('%d',fold)));
    load(strcat('w20',sprintf('%d',fold)));
	eq = [];eqv = [];stw1 = [];stw2 = [];rms_w = [];eqv_min = [];eqmv_min = [];niter_v = 0;niter = 1;
    nitermax = input('Maximum number of iterations = ');
elseif resp == 3,
    load(strcat('w1',sprintf('%d',fold)));
    load(strcat('w2',sprintf('%d',fold)));
    load(strcat('evol',sprintf('%d',fold)));
    niterad = input('Additional number of iterations = ');
    nitermax = niter+niterad;
else
	error('Not a valid option!');
end
