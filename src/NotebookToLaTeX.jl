module NotebookToLaTeX

using Requires
using ReadableRegex
# using Plots
# using Makie
# using CairoMakie
using Base64
using JSON
using Librsvg_jll # For converting svg to pdf

export notebooktolatex, jupytertolatex

include("templates.jl")
include("auxiliarytex.jl")
include("markdowntolatex.jl")
include("helperfunctions.jl")
# include("plutoconverter.jl")
include("jupyterconverter.jl")

export nestedget

# """
#     Runner is a module for controling the scope
#     when running the notebook files, avoinding that any
#     command interferes with the "outside" script.
# """
# module Runner
# end


function __init__()

    @require Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80" begin
    @require Makie = "ee78f7c6-11fb-53f2-987a-cfe4a2b5a57a" begin
        @require CairoMakie = "13f3f980-e62b-5c42-98c6-ff1f3baf88f0" include("plutoconverter.jl")
    end
    end
end

"""
    notebooktolatex(notebook, targetdir="./build_latex"; template=:book, fontpath=nothing)
Takes a notebook file, converts it to LaTeX and creates a file structure
with figures, fonts and listing files.
* `targetdir` is the target directory where the LaTeX project will be created.
If the directory does not exist, it is created.
* `template` - The template for the LaTeX file. It's based on LaTeX templates.
Current supported templates are `:book`, `:mathbook`.
* `fontpath` - The output LaTeX files uses JuliaMono fonts in order to support the
unicodes that are also supported in Julia. If the user already has JuliaMono installed,
he can provide the path to where the `.ttf` files are stored. If `nothing` is passed,
then the font files will be downloaded and saved in the `./fonts/` folder.
"""
function notebooktolatex(notebook::String, targetdir="./build_latex"; template=:book, fontpath=nothing)
    if endswith((notebook),".jl")
        plutotolatex(notebook, targetdir, template=template, fontpath=fontpath)
    elseif endswith((notebook),".ipynb")
        jupytertolatex(notebook, targetdir, template=template, fontpath=fontpath)
    else
        throw(ArgumentError(notebook, "extension must be either .jl or .ipynb"))
    end
end

function dispatch_output(command_eval, notebookname, path, figureindex)
   return command_eval 
end


end
