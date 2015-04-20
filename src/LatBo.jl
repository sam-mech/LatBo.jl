module LatBo

export SandBox, run!, geometry, index, gridcoords, LB, Playground, Units


# Type defining the feature of the simulation playground
abstract Simulation{T <: FloatingPoint, I <: Int}

include("indexing.jl")
include("playground.jl")
include("units.jl")

include("geometry.jl")
include("lb/lb.jl")

importall .Indices
using .LB
using .Units

include("sandbox.jl")

# Runs lattice boltzmann for single step
function run!(observer::Function, sim::Simulation; doinit::Bool=true, nsteps::Integer=1)
    # First initializes lattice
    if doinit
        LB.initialize(sim)
    end
    # Then run for N steps
    for step in 1:nsteps
        # run local kernel for each site
        LB.local_kernel(sim)
        # swap populations
        sim.populations, sim.next_populations = sim.next_populations, sim.populations
        # run observer at each step
        observer()
    end
end

# Run simulation for N numbers of steps without observing
run!(sim::Simulation; kwargs...) = run!(()->nothing, sim; kwargs...)

include("setups.jl")

end # module
