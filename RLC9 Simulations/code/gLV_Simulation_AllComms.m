clear all, close all
%Important values to change
Tmax=48;
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

%Load best fit parameters
vector=csvread('W2_lambda8_weight10_params_G2.csv');
params=[];
for q=1:numspecies
	params=[params vector((numspecies+1)*(q-1)+1:(numspecies+1)*q)]; %Input was transposed for fmincon output
end

for communitysize=12
	mkdir(strcat(int2str(communitysize),'MemberComms/'));
	%Generate a matrix containing all possible combinations for a given
	%community size
	comms=nchoosek([1:25],communitysize);
	comms=sort(comms,2);
	finished=dir(strcat(int2str(communitysize),'MemberComms/*.csv'));
	finished={finished.name};
	parfor k=1:size(comms,1)
		presentvector=ismember([1:25],comms(k,:));
		IC=(totalOD/communitysize)*presentvector;
		data=[];
		mystring='';
		for z=1:communitysize
			if size(mystring,1)==''
				mystring=strcat(mystring,int2str(comms(k,z)));
			else
				mystring=strcat(mystring,'_',int2str(comms(k,z)));
			end
		end
		if any(strcmp(finished,strcat(mystring,'.csv')))
			disp(strcat(mystring,' already finished'))
		else
			disp(k)
			tic
			output=runsim(presentvector,problemvector,Tmax,IC,params);
			if size(output)>0
				data=[data; output];
			end
			dlmwrite(strcat(int2str(communitysize),'MemberComms/',mystring,'.csv'),data,'delimiter',',');
		end
	end
end