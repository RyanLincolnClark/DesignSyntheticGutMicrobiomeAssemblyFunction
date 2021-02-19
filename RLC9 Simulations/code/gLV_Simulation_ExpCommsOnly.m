clear all, close all
%Important values to change
name='RLC9_LOOs'
Tmax=48;
mkdir(strcat(name,'/'));
numspecies=25;
totalOD=0.0066;
bpbindices=[16,18,21,22,23];
bpbvector(1:numspecies)=0;
for k=1:length(bpbindices)
    bpbvector(bpbindices(k))=1;
end
problemindices=[1,13,14,16,18,21,22,23,25]
problemvector(1:numspecies)=0;
for k=1:length(problemindices)
    problemvector(problemindices(k))=1;
end

%Create a matrix with the ensemble of parameters (each column is a
%different parameter set)
paramfiles=dir('RLC9_posterior_fixedprior/param*');
ensemblesize=length(paramfiles);
ensemble(numspecies*(numspecies+1),ensemblesize)=0;
z=1;
for j=1:ensemblesize
    %Read in Parameters and store in ensemble matrix
    ensemble(:,j)=csvread(strcat('RLC9_posterior_fixedprior/',paramfiles(j).name));
	z=z+1;
end

file=fopen(strcat(name,'.txt'));
for k=1:500
	comm=str2num(fgetl(file));
	communitysize=size(comm,2);
	presentvector=ismember([1:25],comm);
	IC=(totalOD/communitysize)*presentvector;
	data=[];
	parfor j=1:ensemblesize
		%Read in Parameters
		vector=ensemble(:,j);
		params=[];
		for q=1:numspecies
			params=[params vector((numspecies+1)*(q-1)+1:(numspecies+1)*q)];
		end
		output=runsim(presentvector,problemvector,Tmax,IC,params);
		if size(output)>0
			data=[data; output];
		end
	end
	mystring='';
	for z=1:communitysize
		if size(mystring,1)==''
			mystring=strcat(mystring,int2str(comm(z)));
		else
			mystring=strcat(mystring,'_',int2str(comm(z)));
		end
	end
	dlmwrite(strcat(name,'/',mystring,'.csv'),data,'delimiter',',');
end