function [complexities, initialconditions, timepoints, abundances] = LOAD_DATA_RLC(directory)
	global nspecies
	
	files=dir(directory);
	files=files(~ismember({files.name},{'.','..'}));
	complexities=zeros(size(files,1),1);
	initialconditions=zeros(size(files,1),nspecies);
	timepoints={};
	abundances={};
	errors={};
	
	for i=1:size(files,1)
		fid=fopen(strcat(directory,files(i).name));
		timepoints{i}=str2num(fgetl(fid));
		complexities(i)=str2num(fgetl(fid));
		specieslist=str2num(fgetl(fid));
		abundance=[];
		error=[];
		for ii=1:complexities(i)
			abundance=[abundance; str2num(fgetl(fid))];
			initialconditions(i,specieslist(ii))=abundance(ii,1);
			error=[error; str2num(fgetl(fid))];
		end
		newabundance=zeros(nspecies,size(timepoints{i},2));
		for j=1:size(timepoints{i},2)
			for ii=1:complexities(i)
				newabundance(specieslist(ii),j)=abundance(ii,j);
			end
		end
		abundances{i}=newabundance;
		errors{i}=error;
		fclose(fid);
	end
end