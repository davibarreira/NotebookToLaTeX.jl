# Inside make.jl
push!(LOAD_PATH,"../src/")
using NotebookToLaTex
using Documenter
makedocs(
         sitename="NotebookToLaTeX.jl",
         modules=[NotebookToLaTex],
         pages=[
                "Home" => "index.md"
               ])
deploydocs(;
    repo="github.com/davibarreira/NotebookToLaTeX.jl",
)

