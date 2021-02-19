# Call Libraries
using JLD

dict = Dict()
dict["invcov"]=readdlm("2019_08_16_invcovmat_RLC2.csv",',',Float64,'\n')
dict["means"]=readdlm("2019_08_16_priormeans_RLC2.csv",',',Float64,'\n')
dict["perturbations"]=readdlm("2019_08_16_priorperturbations_RLC2.csv",',',Float64,'\n')
save("2019_08_20_RLC2_posteriordata.jld",dict)
