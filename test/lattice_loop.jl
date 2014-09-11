using FactCheck: facts, @fact, roughly, context
using LatBo: SingleRelaxationTime, lattice_loop

facts("Single relaxation time initialization") do
    context("2D") do
        sim = SingleRelaxationTime(1.5, 1.6, 0.5, :D2Q9, (5, 5))
        sim.populations = rand(size(sim.populations)...)
        populations = copy(sim.populations)
        sim.playground = rand(size(sim.playground)...)
        lattice_loop(sim) do indices, fᵢ, feature
            @fact fᵢ => roughly(sim.populations[:, indices...])
            @fact feature => roughly(sim.playground[indices...])
            populations[:, indices...] = 0
            ones(size(fᵢ))
        end
        @fact populations => roughly(zeros(size(populations)...))
        @fact sim.populations => roughly(ones(size(populations)...))
    end
    context("3D") do
        sim = SingleRelaxationTime(1.5, 1.6, 0.5, :D3Q3, (3, 3, 3))
        sim.populations = rand(size(sim.populations)...)
        populations = copy(sim.populations)
        sim.playground = rand(size(sim.playground)...)
        lattice_loop(sim) do indices, fᵢ, feature
            @fact fᵢ => roughly(sim.populations[:, indices...])
            @fact feature => roughly(sim.playground[indices...])
            populations[:, indices...] = 0
            ones(size(fᵢ))
        end
        @fact populations => roughly(zeros(size(populations)...))
        @fact sim.populations => roughly(ones(size(populations)...))
    end
end