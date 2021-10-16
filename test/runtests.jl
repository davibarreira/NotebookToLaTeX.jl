using NotebookToLatex
import NotebookToLatex:dispatch_output
import NotebookToLatex:createfolders
import NotebookToLatex:createtemplate
import NotebookToLatex:extractnotebook
import NotebookToLatex:collectoutputs
using Test

@testset "NotebookToLatex.jl" begin
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
        @test outputs[1] == (:nothing, "")
        @test outputs[2] == (:plot, "notebooktest_figure1.png")
        @test isfile(path * "build_latex/figures/notebooktest_figure1.png")
        #= rm(path, recursive=true) =#
    end

    #= @testset "Pluto to Latex" begin =#
    #=     plutotolatex("./notebooktest.jl") =#
    #= end =#

    rm(path, recursive=true)
end
