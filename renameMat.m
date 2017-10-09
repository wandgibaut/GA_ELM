function renameMat(fold)
%options = optimset(@ga, 'Vectorized','on');
% Get all PDF files in the current folder

files = dir('*.mat');
% Loop through each
for id = 1:length(files)
  file = files(id);
  if strcmp(file.name,'bestScore_evol.mat')
    %[~, f] = fileparts(file.name);
    newName = strcat('bestScore_evol_',num2str(fold),'_.mat');
    movefile(file.name, newName);
    
  elseif strcmp(file.name,'meanScore_evol.mat')
    %[~, f] = fileparts(file.name);
    newName = strcat('meanScore_evol_',num2str(fold),'_.mat');
    movefile(file.name, newName);

  elseif strncmp(file.name,'pop_at_generation_',18)
    [~, f] = fileparts(file.name);
    newName = strcat(f,'_',num2str(fold),'_.mat');
    movefile(file.name, newName);

  end
  
end

end