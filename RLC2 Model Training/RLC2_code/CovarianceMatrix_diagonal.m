clear all, close all
%Inputs
numspecies=25;
bpbindices=[16,18,21,22,23];
%Create a matrix with the ensemble of parameters (each column is a
%different parameter set)
paramfiles=dir('posterior/param*');
ensemblesize=length(paramfiles);
ensemble(numspecies*(numspecies+1),ensemblesize)=0;
for j=1:ensemblesize
    %Read in Parameters and store in ensemble matrix
    ensemble(:,j)=csvread(strcat('posterior/',paramfiles(j).name));
    for k=1:numspecies
        for l=1:numspecies+1
            if l~=1 && k~=l-1
                ensemble((numspecies+1)*k+(l-1)-numspecies,j)=0;
            end
        end
    end
end
ensemble=transpose(ensemble);
%ensemble is now a matrix where each column represents a randome variable
%and each row represents a different observation
meanparams=mean(ensemble);
covmat=cov(ensemble);
for i=1:numspecies^2+numspecies
    if covmat(i,i)==0
        covmat(i,i)=1;
    end
    for j=1:numspecies^2+numspecies
        if i~=j
            covmat(i,j)=0;
        end
    end
end
invcovmat=inv(covmat);
perturbations=mvnrnd(meanparams,covmat,5000);
csvwrite("2019_08_20_ensemble_RLC2.csv",ensemble);
csvwrite("2019_08_20_covmat_diagonal_RLC2.csv",covmat);
csvwrite("2019_08_20_invcovmat_diagonal_RLC2.csv",invcovmat);
csvwrite("2019_08_20_priormeans_RLC2.csv",meanparams);
csvwrite("2019_08_20_priorperturbations_diagonal_RLC2.csv",perturbations);