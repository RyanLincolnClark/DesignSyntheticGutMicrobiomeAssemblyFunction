function [predictions,measurements,MSE] = evaluate_fit(P)

    global nspecies tmax complexities initialconditions timepoints abundances
    
	Pmat= [];
	for i=1:nspecies
		Pmat=[Pmat P(1+(nspecies+1)*(i-1):(nspecies+1)*i)];
	end
	predictions=[];
	measurements=[];
	%LOOP OVER ALL COMMUNITIES
	for i=1:size(complexities,1)
		[t,x]=ode45(@(t,x) gLV_RLC(t,x,Pmat),[0 tmax],initialconditions(i,:)');
		for ii=2:size(timepoints{i},2) %Skip the first time point, because that is the initial condition
			species=find(initialconditions(i,:)');
			[d,ix]=min(abs(t-timepoints{i}(ii)));
			predictions=[predictions x(ix,species)];
			measurements=[measurements abundances{i}(species,ii)'];
		end
	end
	MSE=norm(predictions-measurements)
end
