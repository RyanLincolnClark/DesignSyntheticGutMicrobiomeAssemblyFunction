# Sungho Shin (sungho.shin@wisc.edu) and Victor Zavala (zavalatejeda@wisc.edu)

# Call Libraries
using Plasmo, JuMP, Ipopt, JLD
include("param_v9.jl")

#First fit to monospecies data to generate initial guess
# Load data file
datasets = load("2019_08_13_rlc_data_mean.jld")
data = datasets["RLC2"]

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
            args[:maxr][string(i)][string(j)]=-0.05
        else
            args[:maxr][string(i)][string(j)]=args[:absr]
        end
        args[:minr][string(i)][string(j)]=-args[:absr]
    end
end

l=10.0

# Options --------------------
outputpath="placeholder"
opts = Dict(:save_y => true,
            :save_e => true,
            :outputpath => outputpath,
            :solver => IpoptSolver(output_file=outputpath*"io.out",linear_solver="ma57"))

# Add discretization information to the data dictionary
add_discretize_info!(data,args)

# Prior means, starting values, scaling factors
args[:r_prior]=Dict((i,j)=>0.0 for i=1:args[:n_total_species] for j=0:args[:n_total_species])
args[:r_scale]=1
args[:y_scale]=Dict(exp=>[Dict((ii,j,k)=>1
for ii =1:length(data[exp][i]) for j in 1:data[exp][i][ii][:n_species] for k in 1:data[exp][i][ii][:n_disc_time])
for i=1:length(data[exp])]  for exp in keys(data))
# Absolute measurement error
args[:y_sig_abs]=Dict((exp,i,ii,j,k) => max(data[exp][i][ii][:yerr][j][k],args[:MinErr])
#args[:y_sig_abs]=Dict((exp,i,ii,j,k) => max(args[:y_sig_min],data[exp][i][ii][:y][j][k])
for exp in keys(data) for i in 1:length(data[exp]) for ii in 1:length(data[exp][i]) for j in 1:data[exp][i][ii][:n_species] for k in 1:data[exp][i][ii][:n_time])

outputpath = "../2019_08_13_output_RLC2/lambda"*string(l)*"/"
opts[:outputpath]=outputpath
mkpath(opts[:outputpath])
opts[:solver]=IpoptSolver(output_file=outputpath*"io.out",linear_solver="ma57",max_cpu_time=3e+03,max_iter=500)
args[:r_start]=Dict((i,j)=>0.0 for i=1:args[:n_total_species] for j=0:args[:n_total_species])
args[:y_start]=Dict((exp,i,ii,j,k)=>0.0 for exp in keys(data) for i in 1:length(data[exp]) for ii in 1:length(data[exp][i]) for j in 1:data[exp][i][ii][:n_species] for k in 1:data[exp][i][ii][:n_disc_time])
args[:lambda]=l
opts[:guesspath]="../2019_08_13_output_RLC2/lambda10.0/guess1/lambda10.0_guess1_"

#Load the best guess
load_param_guess(opts,args)

# Save the output ----------------
inference_analysis(data,args,opts,700)