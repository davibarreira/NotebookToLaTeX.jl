using PlutoLatexConverter
using Test

@testset "PlutoLatexConverter.jl" begin
    # Write your tests here.
    path = "./project/"
    @testset "Creating Folders and Files" begin
        createfolders(path)
        @test isdir(path * "build_latex")
        @test isdir(path * "build_latex/notebooks")
        @test isdir(path * "build_latex/figures")
        @test isdir(path * "build_latex/frontmatter")

        createtemplate(path, :book)
        @test isfile(path * "build_latex/main.tex")
    end

    @testset "Parsing Notebook" begin
        nb = extractnotebook("./notebooktest.jl")
        outputs  = collectoutputs(nb, path)
        @test outputs[1] === nothing
        @test outputs[2] == (:plot, "notebooktest_figure1.png")
        println(outputs)
        @test isfile("build_latex/figures/notebooktest_figure1.png")
    end

    rm(path, recursive=true)
end
