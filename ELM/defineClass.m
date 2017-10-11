function [S_pred_validation] = defineClass(S_pred_validation)
 for n=1:length(S_pred_validation)
           [~ , I] = max(S_pred_validation(n,:));
           S_pred_validation(n,I) = 1;
           temp = S_pred_validation(n,:);
           temp(temp <0)=0;
           S_pred_validation(n,:) = temp;
           S_pred_validation(n,:) = floor(S_pred_validation(n,:));
       end
end