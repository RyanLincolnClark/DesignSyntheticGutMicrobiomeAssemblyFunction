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
lam=0.01; %Regularization coefficient, lambda
reg='W2'; %L1 for sparse parameter set, L2 for more continuous parameter set, W2 for L2 with wieghted monospecies growth curves
w=2; %If you are wieghting the monospecies measurements, this is the weight
directory='RLC9Dataset/'; %Location of experimental data files. NOTE: Your data should be stored as CSV files in the same format we used for making the Julia databases, but all files in one folder. One file per treatment.
paramfilename=strcat('W2_lambda1_weight2_params_G2.csv'); %Filename of initial guess for parameters, same order as Julia output

%DON'T CHANGE ANYTHING BELOW HERE UNLESS YOU KNOW WHAT YOU ARE DOING

%LOAD INITIAL GUESS FOR PARAMETERS
Po=csvread(paramfilename);
%Po=zeros((nspecies+1)*nspecies,1); %Uncomment this line if you want to use 0 as initial guess for all parameters

%SET UPPER AND LOWER BOUNDS FOR EACH PARAMETER
lbx = [minr repmat(minaij,1,nspecies)]; %lower bound
lb = repmat(lbx,nspecies,1)';
ubx = [maxr repmat(maxaij,1,nspecies)]; %upper bound
ub = repmat(ubx,nspecies,1)';
for i=1:nspecies
	ub(i+1,i)=maxaii;
end

A = [];
b = [];
Aeq = [];
beq = [];

%LOAD DATA
[complexities, initialconditions, timepoints, abundances] = LOAD_DATA_RLC(directory);

%OPTIONS FOR FMINCON
options = optimoptions('fmincon','MaxFunctionEvaluations',Inf,'MaxIterations',Inf);
tic
if reg=='L1'
	[pX,fval,exitflag,output] = fmincon(@(x)objectiveFunction_RLC(x,lam),Po,A,b,Aeq,beq,lb(:),ub(:),[],options);
	name=strcat(reg,'_lambda',num2str(lam,2));
elseif reg=='L2' 
	[pX,fval,exitflag,output] = fmincon(@(x)objectiveFunction_L2_RLC(x,lam),Po,A,b,Aeq,beq,lb(:),ub(:),[],options);
	name=strcat(reg,'_lambda',num2str(lam,2));
elseif reg=='W2'
	[pX,fval,exitflag,output] = fmincon(@(x)objectiveFunction_L2_monoweight_RLC(x,lam,w),Po,A,b,Aeq,beq,lb(:),ub(:),[],options);
	name=strcat(reg,'_lambda',num2str(lam,2),'_weight',num2str(w,2));
end
toc

%SAVE OUTPUT FILES
fid=fopen(strcat(name,'_output_G2.txt'),'wt');
fprintf(fid,'%i iterations \n %i funcCount \n message: %s \n fval: %f',output.iterations,output.funcCount,output.message,fval);
fclose(fid);
csvwrite(strcat(name,'_params_G2.csv'),pX);