function output=runsim(presentvector,problemvector,Tmax, IC, params)
	clear tprev elapsedtime
	output=[];
	if sum(presentvector.*problemvector)==9
		try
			[t,x] = ode23(@(t,x) gLV_errorcatch(t,x,params),[0 Tmax],IC);
			output=x(size(x,1),:);
		catch
			disp(lasterr)
		end
	else
		try
			[t,x] = ode45(@(t,x) gLV_errorcatch(t,x,params),[0 Tmax],IC);
			output=x(size(x,1),:);
		catch
			disp(lasterr)
		end
	end
end