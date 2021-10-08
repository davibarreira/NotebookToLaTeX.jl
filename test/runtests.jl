using PlutoLatexConverter
using Test

@testset "PlutoLatexConverter.jl" begin
    # Write your tests here.
    nb = extractnotebook("./notebooktest.jl")
    collectoutputs(nb, "./")
end
