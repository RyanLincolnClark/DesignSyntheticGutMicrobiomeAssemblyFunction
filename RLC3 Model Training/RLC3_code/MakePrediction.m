function [] = MakePrediction(trainingData, parameters, predictorNames,filenamebase)
predictors = trainingData(:, predictorNames);
response = trainingData.P;

A=table2array(predictors);
D=x2fx(A,'interaction');
D(:,1)=[]; %Remove constant term
D(:,11:50)=[]; %Remove terms for monospecies of non-BPB
D(:,[11,108,201,290,375,456,533,606,675,740,801,858,911,960,1005,1046,1083,1116,1145,1170,1191,1208,1221,1230,1235])=[];%Remove SSx*ZEROx combinations
prediction=D*parameters;
H=plotregression(prediction,response);
savefig(strcat(filenamebase,'.fig')), print(strcat(filenamebase,'.pdf'),'-dpdf');