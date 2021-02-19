function [] = GenerateModel(trainingDF_filename,prefix,Kfolds)
mkdir('models',prefix)
predictorNames = {'ZEROER', 'SSER', 'ZEROFP', 'SSFP', 'ZEROAC', 'SSAC', 'ZEROCC', 'SSCC', 'ZERORI', 'SSRI', 'ZEROEL', 'SSEL', 'ZEROCH', 'SSCH', 'ZERODP', 'SSDP', 'ZEROBH', 'SSBH', 'ZEROCA', 'SSCA', 'ZEROPC', 'SSPC', 'ZEROPJ', 'SSPJ', 'ZERODL', 'SSDL', 'ZEROCG', 'SSCG', 'ZEROBF', 'SSBF', 'ZEROBO', 'SSBO', 'ZEROBT', 'SSBT', 'ZEROBU', 'SSBU', 'ZEROBV', 'SSBV', 'ZEROBC', 'SSBC', 'ZEROBY', 'SSBY', 'ZERODF', 'SSDF', 'ZEROBL', 'SSBL', 'ZEROBP', 'SSBP', 'ZEROBA', 'SSBA'};
trainingData=readtable(trainingDF_filename);

%Find the best fit model
parameters=LassoRegression(trainingData, Kfolds, predictorNames,strcat(strcat('models/',prefix,'/',prefix,'_Lasso')));

%Document the model results
modelorder={'ZEROER', 'SSER', 'ZEROFP', 'SSFP', 'ZEROAC', 'SSAC', 'ZEROCC', 'SSCC', 'ZERORI', 'SSRI'};
T = triu(ones(length(predictorNames))); %a mask for cross terms to keep
for i = 1:length(predictorNames)
    for j = 1:length(predictorNames)        
        if T(i,j) && (i ~= j)
            modelorder=horzcat(modelorder, strcat(predictorNames{i},'*',predictorNames{j}));
        end
    end
end
modelorder([11,108,201,290,375,456,533,606,675,740,801,858,911,960,1005,1046,1083,1116,1145,1170,1191,1208,1221,1230,1235])=[];

modelform='';
nonzeroparams={};
nonzeropredictors={};
for parameter=1:length(parameters)
    if abs(parameters(parameter))>0.01
        modelform=strcat(modelform,'+','(',string(parameters(parameter)),')',modelorder(parameter));
        nonzeroparams=vertcat(nonzeroparams, parameters(parameter));
        nonzeropredictors=vertcat(nonzeropredictors,modelorder(parameter));
    end
end

M=horzcat(nonzeroparams,nonzeropredictors);
T = cell2table(M,'VariableNames',{'Parameter','Factor'});
writetable(T,strcat('models/',prefix,'/',prefix,'_modeloutput.csv'));

%Make a Prediction of the original data (Goodness of Fit)
MakePrediction(trainingData,parameters,predictorNames,strcat(strcat('models/',prefix,'/',prefix,'_GOF')));

%Save the model for later use
csvwrite(strcat('models/',prefix,'/',prefix,'_model.csv'),parameters);