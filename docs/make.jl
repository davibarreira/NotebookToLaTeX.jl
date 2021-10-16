# Inside make.jl
push!(LOAD_PATH,"../src/")
using NotebookToLatex
using Documenter
makedocs(
         sitename="NotebookToLatex.jl",
         modules=[NotebookToLatex],
         pages=[
                "Home" => "index.md"
               ])
deploydocs(;
    repo="github.com/davibarreira/NotebookToLatex.jl",
)
