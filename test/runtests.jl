using PlutoLatexConverter
using Test

@testset "PlutoLatexConverter.jl" begin
    # Write your tests here.
    @show nb = extractnotebook("./notebooktest.jl")
    @show outputs  = collectoutputs(nb, "./")
    @test outputs[1] == ""
end
