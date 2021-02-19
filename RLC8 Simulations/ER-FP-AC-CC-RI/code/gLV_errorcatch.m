function output = gLV(t,x,params)
    n=size(x,1); %This is the number of species included in the simulation
    r=params(1,:); %This pulls the growth rates out of the first row of the parameter matrix
    a=params(2:n+1,:)'; %This pulls the aij matrix out of the parameter matrix
    for i=1:n
        dydt(i)=x(i)*r(i); %basal growth rate
        for j=1:n
            dydt(i)=dydt(i)+a(i,j)*x(i)*x(j); %interaction terms
        end
    end
    output=dydt';
    % Below is where we check for stopping conditions
    MINSTEP = 1e-10; %Minimum step
    persistent tprev
    if isempty(tprev)
        tprev = -inf;
    end
    timestep = t - tprev;
    tprev = t;
    if (t>0.01) && (timestep > 0) && (timestep < MINSTEP)
        error(['Stopped. Time step is too small: ' num2str(timestep)])
    end
end
