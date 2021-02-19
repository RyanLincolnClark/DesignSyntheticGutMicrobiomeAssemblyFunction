clear all, close all
rng shuffle
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
            if ismember(l-1,bpbindices) || ismember (k,bpbindices) || l==1 || k==l-1
                ensemble((numspecies+1)*k+(l-1)-numspecies,j)=ensemble((numspecies+1)*k+(l-1)-numspecies,j);
            else
                ensemble((numspecies+1)*k+(l-1)-numspecies,j)=0;
            end
        end
    end
end
ensemble=transpose(ensemble);
variances=var(ensemble);
%ensemble is now a matrix where each column represents a randome variable
%and each row represents a different observation
meanparams=mean(ensemble);
covmat=zeros(numspecies^2+numspecies);
for i=1:numspecies^2+numspecies
    for j=1:numspecies^2+numspecies
        if i==j
            covmat(i,j)=variances(i);
        end
    end
end
perturbations=mvnrnd(meanparams,covmat,5000);
for i=1:numspecies^2+numspecies
    for j=1:numspecies^2+numspecies
        if i==j && covmat(i,j)==0
                covmat(i,j)=1;
        end
    end
end
invcovmat=inv(covmat);
csvwrite("2020_04_16_ensemble_RLC8.csv",ensemble);
csvwrite("2020_04_16_covmat_diagonal_RLC8.csv",covmat);
csvwrite("2020_04_16_invcovmat_diagonal_RLC8.csv",invcovmat);
csvwrite("2020_04_16_priormeans_RLC8.csv",meanparams);
csvwrite("2020_04_16_priorperturbations_diagonal_RLC8.csv",perturbations);