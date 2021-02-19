clear all, close all
%Important values to change
Tmax=48;
numspecies=25;
totalOD=0.0066;
bpbindices=[16,18,21,22,23];
bpborder=[21,16,18,23,22];
names={'PC','PJ','BV','BF','BO','BT','BC','BY','BU','DP','BL','BA','BP','CA','EL','FP','CH','AC','BH','CG','ER','RI','CC','DL','DF'};

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
paramfiles=dir('2019_09_04_RLC3_posterior_KNN/param*');
ensemblesize=length(paramfiles);
ensemble(numspecies*(numspecies+1),ensemblesize)=0;
z=1;
for j=1:ensemblesize
    %Read in Parameters and store in ensemble matrix
    ensemble(:,j)=csvread(strcat('2019_09_04_RLC3_posterior_KNN/',paramfiles(j).name));
	z=z+1;
end

for i=1:size(bpbindices,2)
	if i==1
		bpbsets=bpbindices';
	else
		bpbsets=nchoosek(bpbindices,i);
	end
	for ii=1:size(bpbsets,1)
		bpbset=bpbsets(ii,:)
		first='T';
		for sp=1:size(bpborder,2)
			if ismember(bpborder(sp),bpbset)
				if first=='T'
					name=names(bpborder(sp));
					modelstring=strcat([name{:}]);
					first='F';
				else
					name=names(bpborder(sp));
					modelstring=strcat(modelstring,'-',[name{:}]);
				end
			end
		end
		filename=strcat('RLC3_regressionmodels_10fcv_SSandZERO/',modelstring,'/',modelstring,'_model.csv')
		but_parameters=csvread(filename);
		for communitysize=4
			mkdir(strcat(int2str(communitysize),'MemberComms/'));
			%Generate a matrix containing all possible combinations for a given
			%community size
			if (communitysize-size(bpbset,2)>-1)&&(communitysize-size(bpbset,2)<21)
				comms=nchoosek([1:15,17,19,20,24,25],communitysize-size(bpbset,2));
				for sp=1:size(bpbset,2)
					comms=[comms bpbset(sp)*ones(size(comms,1),1)];
				end
				comms=sort(comms,2);
				finished=dir(strcat(int2str(communitysize),'MemberComms/*.csv'));
				finished={finished.name};
				parfor k=1:size(comms,1)
					presentvector=ismember([1:25],comms(k,:));
					IC=(totalOD/communitysize)*presentvector;
					data=[]
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
						for j=1:ensemblesize
							%Read in Parameters
							vector=ensemble(:,j);
							params=[];
							for q=1:numspecies
								params=[params vector((numspecies+1)*(q-1)+1:(numspecies+1)*q)];
							end
							output=runsim(presentvector,problemvector,Tmax, IC, params);
							if size(output)>0
								data=[data; output];
							end
						end
						[butyrate]=MakePrediction(data, but_parameters, presentvector);
						data=[data butyrate];
						data=data(data(:,25)<100,:); %Remove really large Butyrate values
						for i=1:25
							data=data(data(:,i)<5,:); %Remove really large species abundances
						end
						dlmwrite(strcat(int2str(communitysize),'MemberComms/',mystring,'.csv'),[mean(data) median(data) std(data) prctile(data,20) prctile(data,80)],'delimiter',',');
						toc
					end
				end
			end
		end
	end
end