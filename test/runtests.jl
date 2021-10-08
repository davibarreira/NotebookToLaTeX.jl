using PlutoLatexConverter
using Test

@testset "PlutoLatexConverter.jl" begin
    # Write your tests here.
    @testset "Folder and Files" begin
        createfolders("./test")
        @test isdir("build_latex")
        @test isdir("build_latex/notebooks")
        @test isdir("build_latex/figures")
    end

    @testset "Parsing Notebook" begin
        nb = extractnotebook("./notebooktest.jl")
        outputs  = collectoutputs(nb, "./")
        @test outputs[1] === nothing
        @test outputs[2] == (:plot, "notebooktest_figure1.png")
    end

    #= rm("notebooktest_figure1.png") =#
    #= rm("build_latex", recursive=true) =#
end
