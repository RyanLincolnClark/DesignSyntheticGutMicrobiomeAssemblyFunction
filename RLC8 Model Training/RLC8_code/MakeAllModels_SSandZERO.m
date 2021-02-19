clear all, close all
bpbsets={'ER','ER-FP','ER-FP-AC','ER-FP-AC-CC','ER-FP-AC-RI','ER-FP-CC','ER-FP-CC-RI','ER-FP-RI','ER-AC','ER-AC-CC','ER-AC-CC-RI','ER-AC-RI','ER-CC','ER-CC-RI','ER-RI','FP','FP-AC','FP-AC-CC','FP-AC-CC-RI','FP-AC-RI','FP-CC','FP-CC-RI','FP-RI','AC','AC-CC','AC-CC-RI','AC-RI','CC','CC-RI','RI','ER-FP-AC-CC-RI'};
for k=1:length(bpbsets)
    bpbset=bpbsets{k}
    GenerateModel(strcat('trainingDFs/2019_05_31_TrainingDF_',bpbset,'.csv'),bpbset,10);
end