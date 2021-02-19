function [parameters] = LassoRegression(inputTable, KFolds, predictorNames,filenamebase)
% Extract predictors and response
% This code processes the data into the right shape for training the
% model.
predictors = inputTable(:, predictorNames);
response = inputTable.P;
%isCategoricalPredictor = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false];

A=table2array(predictors);
D=x2fx(A,'interaction');
D(:,1)=[]; %No constant term
D(:,11:50)=[]; %Remove terms for monospecies of non-BPB 
D(:,[11,108,201,290,375,456,533,606,675,740,801,858,911,960,1005,1046,1083,1116,1145,1170,1191,1208,1221,1230,1235])=[];%Remove SSx*ZEROx combinations
    
rng default %for reproducibility
[B,FitInfo]=lasso(D,response,'CV',KFolds);

%lassoPlot(B,FitInfo,'PlotType','CV'), legend('show'), savefig(strcat(filenamebase,'.fig')), print(strcat(filenamebase,'.pdf'),'-dpdf');

index=FitInfo.IndexMinMSE;
parameters=B(:,index);