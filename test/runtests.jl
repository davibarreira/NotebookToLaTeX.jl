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
        @test isdir(path)
        @test isdir(path * "/notebooks")
        @test isdir(path * "/figures")
        @test isdir(path * "/frontmatter")

        createtemplate(path, :book)
        @test isfile(path * "/main.tex")
    end

    @testset "Parsing Notebook" begin
        nb = extractnotebook("./notebooktest.jl")
        outputs  = collectoutputs(nb, path)
        println(outputs)
        @test outputs[1] == (:nothing, "")
        @test outputs[2] == (:plot, "notebooktest_figure1.png")
        @test isfile(path * "/figures/notebooktest_figure1.png")
        #= rm(path, recursive=true) =#
    end

    @testset "Pluto to Latex" begin
        notebooktolatex("./notebooktest.jl", template=:mathbook,
                        fontpath="/home/davibarreira/.local/share/fonts/Unknown Vendor/TrueType/JuliaMono/")
    end

    rm(path, recursive=true)
    rm("./build_latex/", recursive=true)
end
