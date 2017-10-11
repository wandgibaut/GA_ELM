function plotData(bestScoresFile, meanScoresFile)
%options = optimset(@ga, 'Vectorized','on');

load(bestScoresFile);
load(meanScoresFile);

figure();
plot((1:length(bestScores)), bestScores);
xlabel('Generation'), ylabel('bestFitness')
title('Evolution of the best fitness')



figure();
plot((1:length(meanScores)), meanScores);
xlabel('Generation'), ylabel('meanFitness')
title('Evolution of the mean fitness')
end

