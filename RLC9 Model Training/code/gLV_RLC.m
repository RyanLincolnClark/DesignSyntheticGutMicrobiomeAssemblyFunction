function dxdt = gLV(t,x,Pmat)
	global nspecies
    r=Pmat(1,:)'; %This pulls the growth rates out of the first row of the parameter matrix
    a=Pmat(2:nspecies+1,:); %This pulls the aij matrix out of the parameter matrix
	dxdt=(r+a*x).*x;
end