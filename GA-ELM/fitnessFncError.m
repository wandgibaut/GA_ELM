function fitness = fitnessFncError(H,lambda,S,Xv,Nv,InputWeight,Sv)

	
	%jeito 2

	L = eye(size(H,2));

	for i=1:length(lambda)
		L+= lambda(i)*eye(size(H,2));
	end
	
	OutputWeight = (pinv(H'*H+L))*H'*S;

	

	%jeito 1
	%OutputWeight = (pinv(H'*H+diag(lambda)))*H'*S;


            %%%%%%%%%%% Calculate the validating accuracy
    Hv = [tanh([Xv ones(Nv,1)]*InputWeight') ones(Nv,1)];
    S_estimado = Hv * OutputWeight;                             %   S_estimado: the actual output of the training data
%             ValidatingAccuracy=sqrt(mse(Sv - S_estimado));               %   Calculate training accuracy (RMSE) for regression case
    ValidatingAccuracy=qmean(Sv - S_estimado);

    fitness = ValidatingAccuracy;

end