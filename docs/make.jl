# Inside make.jl
push!(LOAD_PATH,"../src/")
using NotebookToLaTeX
using Documenter
makedocs(
         sitename="NotebookToLaTeX.jl",
         modules=[NotebookToLaTeX],
         pages=[
                "Home" => "index.md"
               ])
deploydocs(;
    repo="github.com/davibarreira/NotebookToLaTeX.jl",
)

