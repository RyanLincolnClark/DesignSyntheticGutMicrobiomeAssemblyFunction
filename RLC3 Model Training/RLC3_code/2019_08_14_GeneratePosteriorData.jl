# Call Libraries
using JLD

dict = Dict()
dict["invcov"]=readdlm("2019_08_21_invcovmat_diagonal_RLC3.csv",',',Float64,'\n')
dict["means"]=readdlm("2019_08_21_priormeans_RLC3.csv",',',Float64,'\n')
dict["perturbations"]=readdlm("2019_08_21_priorperturbations_diagonal_RLC3.csv",',',Float64,'\n')
save("2019_08_21_RLC3_posteriordata.jld",dict)
