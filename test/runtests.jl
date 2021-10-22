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

#=     @testset "Parsing Pluto Notebook" begin =#
#=         nb = extractnotebook("./notebooktest.jl") =#
#=             outputs  = collectoutputs(nb, path) =#
#=         println(outputs) =#
#=         @test outputs[1] == (:nothing, "") =#
#=         @test outputs[2] == (:plot, "notebooktest_figure1.png") =#
#=         @test isfile(path * "/figures/notebooktest_figure1.png") =#
#=     end =#

#=     @testset "Pluto to Latex" begin =#
#=         notebooktolatex("./pluto/notebooktest.jl", template=:book, =#
#=                         fontpath="/home/davibarreira/.local/share/fonts/Unknown Vendor/TrueType/JuliaMono/") =#
#=         #= @test isfile("./build_latex/notebooks/") =# =#
#=     end =#

    @testset "Jupyter to Latex" begin
        jupyterpath = "./jupyter/build_latex/"
        notebooktolatex("./jupyter/jupyternotebook.ipynb", jupyterpath, template=:mathbook)
        @test isfile(jupyterpath * "main.tex")
        @test isfile(jupyterpath * "preface.tex")
        @test isfile(jupyterpath * "frontmatter/copyright.tex")
        @test isfile(jupyterpath * "frontmatter/titlepage.tex")
        @test isfile(jupyterpath * "julia_font.tex")
        @test isfile(jupyterpath * "julia_listings.tex")
        @test isfile(jupyterpath * "julia_listings_unicode.tex")
        @test isfile(jupyterpath * "/notebooks/jupyternotebook.tex")
        @test isfile(jupyterpath * "/fonts/JuliaMono_Bold.ttf")
        @test isfile(jupyterpath * "/fonts/JuliaMono_Medium.ttf")
        @test isfile(jupyterpath * "/fonts/JuliaMono_Regular.ttf")
        @test isfile(jupyterpath * "/figures/figure.pdf")
        @test isfile(jupyterpath * "/figures/jupyternotebook_figure1.pdf")
        @test isfile(jupyterpath * "/figures/jupyternotebook_figure1.svg")
        @test isfile(jupyterpath * "/figures/jupyternotebook_figure2.png")
        @test isfile(jupyterpath * "/figures/plotexample.png")

    end

    rm(path, recursive=true)
    #= rm(jupyterpath, recursive=true) =#
    #= rm("./build_latex/", recursive=true) =#
end
