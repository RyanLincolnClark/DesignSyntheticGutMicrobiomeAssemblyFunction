function cost = objectiveFunction_L2_monoweight_RLC(P,lam,w)

    global nspecies tmax complexities initialconditions timepoints abundances
    
	Pmat= [];
	for i=1:nspecies
		Pmat=[Pmat P(1+26*(i-1):26*i)];
	end
	disp(Pmat);
	%LOOP OVER ALL COMMUNITIES
	MSE=0;
	for i=1:size(complexities,1)
		[t,x]=ode45(@(t,x) gLV_RLC(t,x,Pmat),[0 tmax],initialconditions(i,:)');
		for ii=2:size(timepoints{i},2) %Skip the first time point, because that is the initial condition
			[d,ix]=min(abs(t-timepoints{i}(ii)));
			if size(timepoints{i},2)>2
				MSE=MSE+w*norm(x(ix,:)'-abundances{i}(:,ii));
			else
				MSE=MSE+norm(x(ix,:)'-abundances{i}(:,ii));
			end
		end
	end

	%COMPUTE COST
	cost = MSE + lam*(norm(P)^2); %L^2 regularization
	
	disp(cost);
end
