function [CER] = classError(y,S_pred) 
for p=1:10
    vError(:,p) = abs(y(:,p) - S_pred(:,p));
    CER(p) = sum(vError(:,p))/length(vError);
end



end