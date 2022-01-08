module NotebookToLaTeX

using Requires
using ReadableRegex
using Plots
using Makie
using CairoMakie
using Base64
using JSON
using Librsvg_jll # For converting svg to pdf

export notebooktolatex, jupytertolatex

include("templates.jl")
include("auxiliarytex.jl")
include("markdowntolatex.jl")
include("helperfunctions.jl")
include("plutoconverter.jl")

export nestedget

"""
    Runner is a module for controling the scope
    when running the notebook files, avoinding that any
    command interferes with the "outside" script.
"""
module Runner
end


function __init__()

    @require LaTeXStrings = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f" println("Latex")
    # @require Makie = "ee78f7c6-11fb-53f2-987a-cfe4a2b5a57a" begin
    #     @require CairoMakie = "13f3f980-e62b-5c42-98c6-ff1f3baf88f0" begin
    #         println("Got both")
            # function dispatch_output(command_eval::Makie.FigureAxisPlot, notebookname, path, figureindex)
            #     figureindex[:i]+=1
            #     save(path*"/figures/"*notebookname*"_"*"figure"*string(figureindex[:i])*".pdf", command_eval)
            #     return command_eval
            # end
    #     end
    # end
end


function dispatch_output(command_eval::Plots.Plot, notebookname, path, figureindex)
    figureindex[:i]+=1
    savefig(command_eval,path*"/figures/"*notebookname*"_"*"figure"*string(figureindex[:i])*".png")
    return command_eval
end

function dispatch_output(command_eval, notebookname, path, figureindex)
   return command_eval 
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


function jupytertolatex(notebook, targetdir="./build_latex"; template=:book, fontpath=nothing)

    createproject(targetdir, template, fontpath)
    
    notebookname = basename(notebook)[1:end-6]
    notebookdir  = dirname(notebook)*"/"
    jsonnb = JSON.parse(read(notebook, String))
    texfile = read(targetdir*"/main.tex", String)
    lineinsert = 1
    for (i,line) in enumerate(split(texfile, "\n"))
        if startswith(line, "% INCLUDE NOTEBOOKS")
            lineinsert = i
            break
        end
    end
    
    if !occursin("\\include{./notebooks/"*notebookname*"}",read(targetdir*"/main.tex", String))

        insertlinebelow(targetdir*"/main.tex",
            "\\include{./notebooks/"*notebookname*"}", lineinsert)
    end

    notebook    = targetdir*"/notebooks/"*notebookname*".tex"
    figureindex = Dict(:i=>0)
    open(notebook, "w") do f
        write(f,"\\newpage\n")
        for cell in jsonnb["cells"]
            
            # Checks whether the cell has markdown
            if get(cell,"cell_type", nothing) == "markdown" || get(cell,"cell_type", nothing) == "raw"
                parsed = markdowntolatex(strip(join(cell["source"])), targetdir, notebookdir, template=template)
                write(f,parsed)
                
            # Checks whether the cell has code and whether the code is hidden
            elseif get(cell,"cell_type", nothing) == "code" && nestedget(cell,["metadata","jupyter", "source_hidden"],nothing) === nothing
                if get(cell,"outputs", nothing) != []
                    write(f,"\n\\begin{lstlisting}[language=JuliaLocal, style=julia]\n")
                    write(f, strip(join(cell["source"])))
                    write(f,"\n\\end{lstlisting}\n")
                end
            end
            
            
            ## Collecting outputs
            
            # Checks if the output is an empty array or if the outputs_hidden is true
            check_output_hidden = get(cell, "outputs",[]) == [] || nestedget(cell, ["metadata","jupyter","outputs_hidden"], nothing) !== nothing
            
            # Collect the output if the cell has code and the output is not hidden
            if get(cell, "cell_type", nothing) == "code" && !check_output_hidden
                for output in get(cell, "outputs", nothing)
                    if get(output, "output_type", nothing) == "stream"
                        write(f,"\n\\begin{verbatim}\n")
                        write(f, join(output["text"]))
                        write(f,"\n\\end{verbatim}\n")
                    elseif get(output, "output_type", nothing) == "execute_result"
                        if nestedget(output,["data","text/latex"], nothing) !== nothing
                            write(f, "\n"*join(output["data"]["text/latex"]))
                        elseif nestedget(output,["data","text/plain"], nothing) !== nothing
                            write(f,"\n\\begin{verbatim}\n")
                            write(f, "\n"*join(output["data"]["text/plain"]))
                            write(f,"\n\\end{verbatim}\n")
                        end
                        if nestedget(output,["data","image/png"], nothing) !== nothing
                            png = base64decode(output["data"]["image/png"])
                            
                            figureindex[:i]+=1
                            figurename = notebookname*"_figure"*string(figureindex[:i])*".png"
                            write(targetdir*"/figures/"*figurename, png)
                            write(f,"\n\\begin{figure}[H]\n")
                            write(f,"\t\\centering\n")
                            write(f,"\t\\includegraphics[width=0.8\\textwidth]{./figures/"*figurename*"}\n")
                            write(f,"\t\\label{fig:"*figurename*"}\n")
                            write(f,"\n\\end{figure}\n")
                        end
                        if nestedget(output,["data","image/svg+xml"], nothing) !== nothing
                            svg = join(output["data"]["image/svg+xml"])
                            figureindex[:i]+=1
                            figurename = notebookname*"_figure"*string(figureindex[:i])
                            figuresvg = targetdir*"/figures/"*figurename*".svg"

                            # Save svg figure
                            write(figuresvg, svg)

                            # Convert svg to pdf
                            figurepdf = targetdir*"/figures/"*figurename*".pdf"
                            rsvg_convert() do cmd
                               run(`$cmd $figuresvg -f pdf -o $figurepdf`)
                            end

                            # Parse pdf image to Latex
                            write(f,"\n\\begin{figure}[H]\n")
                            write(f,"\t\\centering\n")
                            write(f,"\t\\includegraphics[width=0.8\\textwidth]{./figures/"*figurename*".pdf}\n")
                            write(f,"\t\\label{fig:"*figurename*"}\n")
                            write(f,"\n\\end{figure}\n")
                        end
                    end
                end
            end
        end
    end
end

end
