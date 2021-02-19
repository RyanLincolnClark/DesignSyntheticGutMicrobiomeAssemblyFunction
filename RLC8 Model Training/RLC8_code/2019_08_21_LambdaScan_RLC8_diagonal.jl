# Sungho Shin (sungho.shin@wisc.edu) and Victor Zavala (zavalatejeda@wisc.edu)

# Call Libraries
using Plasmo, JuMP, Ipopt, JLD
include("param_v10.jl")

#First fit to monospecies data to generate initial guess
# Load data file
datasets = load("2019_08_19_rlc_data_mean.jld")
data = datasets["RLC8"]
posterior = load("2019_08_21_RLC3_posteriordata.jld")
posterior["scale"]=1

# Arguments ------------------
args = Dict(
    :min_norm=>:L1,             # Prediction error formulation (L1 or CVaR)
    :reg_norm=>:L2,            # Prior formulation (none, L1, or L2)
    :model =>:LV,               # Dynamic model (LV or Saturable)
    :dilution_rate => 1/20,     # Diluting medium by 1/20
    :y_sig_rel=>1,            # Make this 1
    #:y_sig_min=>.122,             # Absolute measurement error (this isn't used anymore)
    :MinErr=>0.05,           #Minimum allowable absolut error
    :n_total_species=>25,       # Total number of species
    :n_disc=>Dict(:M=>2,:M1=>10,:P=>10,:MID=>10,:C6=>10), # Order of discretization
    :eps=>1e-2,                     # Small number
    :absr=>3,                       #Default absolute value of parameters
    :maxr=>Dict(),                    # Maximum value of parameters
    :minr=>Dict(),               #Minimum value of parameters
    :beta=>0.9)                 # Beta value for CVaR formulation

#populate the :maxr and :minr dictionaries
for i=1:args[:n_total_species]
    args[:maxr][string(i)]=Dict()
    args[:minr][string(i)]=Dict()
    for j=0:args[:n_total_species]
        if i==j
            args[:maxr][string(i)][string(j)]=-0.0001
        else
            args[:maxr][string(i)][string(j)]=args[:absr]
        end
        args[:minr][string(i)][string(j)]=-args[:absr]
    end
end

lambdas=[10000,9000,8000,7000,6000,5000,4000,3000]

# Options --------------------
outputpath="placeholder"
opts = Dict(:save_y => true,
            :save_e => true,
            :outputpath => outputpath,
            :solver => IpoptSolver(output_file=outputpath*"io.out",linear_solver="ma57"))

# Add discretization information to the data dictionary
add_discretize_info!(data,args)

# Prior means, starting values, scaling factors
args[:r_prior]=Dict((i,j)=>posterior["means"][(args[:n_total_species]+1)*i+j-args[:n_total_species]] for i=1:args[:n_total_species] for j=0:args[:n_total_species])
args[:r_scale]=1
args[:y_scale]=Dict(exp=>[Dict((ii,j,k)=>1
for ii =1:length(data[exp][i]) for j in 1:data[exp][i][ii][:n_species] for k in 1:data[exp][i][ii][:n_disc_time])
for i=1:length(data[exp])]  for exp in keys(data))
# Absolute measurement error
args[:y_sig_abs]=Dict((exp,i,ii,j,k) => max(data[exp][i][ii][:yerr][j][k],args[:MinErr])
#args[:y_sig_abs]=Dict((exp,i,ii,j,k) => max(args[:y_sig_min],data[exp][i][ii][:y][j][k])
for exp in keys(data) for i in 1:length(data[exp]) for ii in 1:length(data[exp][i]) for j in 1:data[exp][i][ii][:n_species] for k in 1:data[exp][i][ii][:n_time])

for initialguess=200:250

for l in lambdas
outputpath = "../2019_08_21_output_RLC8_diagonal/lambda"*string(l)*"/guess"*string(initialguess)*"/lambda"*string(l)*"_guess"*string(initialguess)*"_"
opts[:outputpath]=outputpath
mkpath(opts[:outputpath])
opts[:solver]=IpoptSolver(output_file=outputpath*"io.out",linear_solver="ma57",max_cpu_time=9e+02,max_iter=500)
args[:r_start]=Dict((i,j)=>0.0 for i=1:args[:n_total_species] for j=0:args[:n_total_species])
args[:y_start]=Dict((exp,i,ii,j,k)=>rand() for exp in keys(data) for i in 1:length(data[exp]) for ii in 1:length(data[exp][i]) for j in 1:data[exp][i][ii][:n_species] for k in 1:data[exp][i][ii][:n_disc_time])
args[:lambda]=l
#opts[:guesspath]="../2019_08_18_output_RLC10/lambda0.1/guess3/lambda0.1_guess3_"

#load_param_guess(opts,args)

# Solve the problem --------------
outs = Dict()
(outs[:graph],outs[:m_parent],outs[:m_children],
 outs[:node_parent],outs[:node_children]) = param_posterior(data,args,posterior)
outs[:graph].solver=opts[:solver]
t0=time_ns()
outs[:status]=Plasmo.solve(outs[:graph])
outs[:time_elapsed]=time_ns()-t0

# Save the output ----------------
output(data,args,opts,outs)

end

end
