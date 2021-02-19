close all
clear all
clc

%DEFINE SYSTEM
global nspecies tmax complexities initialconditions timepoints abundances

%DON'T CHANGE ANYTHING ABOVE HERE UNLESS YOU KNOW WHAT YOU ARE DOING

nspecies=25; %Total number of species in your system
maxr=2; %Upper bound for growth rates ri
minr=0.001; %Lower bound for growth rates ri
maxaii=-0.01; %Upper bound for aij when i==j
maxaij=10; %Upper bound for aij when i!=j
minaij=-10; %Lower bound for aij
tmax=48; %Latest time point for experimental data
lam=32; %Regularization coefficient, lambda
reg='W2_weight10_G2'; %L1 for sparse parameter set, L2 for more continuous parameter set
directory='RLC9TestData/'; %Location of experimental data files. NOTE: Your data should be stored as CSV files in the same format we used for making the Julia databases, but all files in one folder. One file per treatment.
datasetname='RLC9TestData';
paramfilename=strcat('W2_lambda',num2str(lam),'_weight10_params_G2.csv'); %Filename of initial guess for parameters, same order as Julia output

%DON'T CHANGE ANYTHING BELOW HERE UNLESS YOU KNOW WHAT YOU ARE DOING

%LOAD INITIAL GUESS FOR PARAMETERS
P=csvread(paramfilename);
%Po=zeros((nspecies+1)*nspecies,1); %Uncomment this line if you want to use 0 as initial guess for all parameters

%LOAD DATA
[complexities, initialconditions, timepoints, abundances] = LOAD_DATA_RLC(directory);

%OPTIONS FOR FMINCON
[predictions,measurements] = evaluate_fit(P);
H=plotregression(predictions,measurements);
savefig(strcat(reg,'_lambda',num2str(lam),'_',datasetname,'.fig')), print(strcat(reg,'_lambda',num2str(lam),'_',datasetname,'.pdf'),'-dpdf');