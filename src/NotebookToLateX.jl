module NotebookToLaTeX

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

export nestedget

"""
    Runner is a module for controling the scope
    when running the notebook files, avoinding that any
    command interferes with the "outside" script.
"""
module Runner
end

"""
    extractnotebook(notebook)
Reads a Pluto notebook file, extracts the code
and returns a dictionary with the code in organized form.
The output is a dictionary containing
* `codes`        - The cell code of each running cell;
* `notebookname` - Name of the notebook;
* `notebookdir`  - Directory location of the notebook file;
* `contents`     - Only the Julia code in the cell;
* `outputtag`    - Whether the output is hidden or showing (read the `tagcelloutput()` function);
* `celltype`     - Whether cell contains code or markdown;
* `order`        - Order that the cells are displayed in the notebook;
* `view`         - Whether the code is hidden or showing (the "eye" icon in the notebook);

e.g. `extractnotebook("./mynotebook.jl")`
notebookdata = Dict(:codes => codes, :notebookname => notebookname, :notebookdir => notebookdir,
                        :contents => contents, :outputtag=>outputtag,
                        :celltype => celltype,:order=> order,:view=>view)
"""
function extractnotebook(notebook)
    s = read(notebook, String)
    cells = split(s, "# ╔═╡ ");
    # The first cell and the final 3 are not used
    codes, contents, outputtag, celltype = [],[],[],[]
    for cell in cells[2:end-3]
        push!(codes, cell[1:36])
        push!(contents, cell[38:end])
        push!(outputtag, endswith(rstrip(cell),";") ? "hideoutput" : "showoutput")
        #= if length(cell) < 42 =#
        #=     push!(celltype, "code") =#
        #= else =#
        push!(celltype, startswith(strip(cell[38:end]),"md\"") ? "markdown" : "code")
    end
    
    # Get order and view type
    r = either("# ╠","# ╟")
    sortedcells = split(cells[end],Regex(r))
    sortedcodes = [cell[4:39] for cell in sortedcells[2:end-2]]
    order = [findfirst(isequal(scode),codes) for scode in  sortedcodes[1:end]]
    view  = [occursin("═",c) ? "showcode" : "hidecode" for c in sortedcells[2:end-2]]
    # Matching running order
    view  = view[[findfirst(isequal(scode),sortedcodes) for scode in  codes]]

    # inferring the notebook name
    # base on the notebook file path.
    notebookname = split(notebook,"/")[end]
    if endswith(notebookname,".jl")
        # removes the ".jl" in the end
        notebookname = notebookname[1:end-3]
    end
    notebookdir = dirname(notebook) == "" ? "./" : dirname(notebook)
    
    notebookdata = Dict(:codes => codes, :notebookname => notebookname, :notebookdir => notebookdir,
                        :contents => contents, :outputtag=>outputtag,
                        :celltype => celltype,:order=> order,:view=>view)
    return notebookdata
end

"""
    collectoutputs(notebookdata, path)
Runs the Pluto notebook and saves the outputs of
each cell into a list.
"""
function collectoutputs(notebookdata, path)
    figureindex = Dict(:i => 0)
    runpath = pwd()
    cd(notebookdata[:notebookdir])
    outputs = []
    for (i, content) ∈ enumerate(notebookdata[:contents])
        if notebookdata[:celltype][i] == "code"
            if startswith(lstrip(content),"begin") && endswith(rstrip(content),"end")
                ex = :($(Meta.parse(strip(content))))
            else
                ex = :($(Meta.parse("begin\n"*content*"\n end")))
            end
            
            s = string(ex.args[end])
            if contains(s, Regex(either("PlutoUI.LocalResource","LocalResource")))
                if findfirst(Regex(look_for(one_or_more(ANY),after="(\"",before="\")")),s) === nothing
                    Core.eval(Runner, ex)
                    pathvariable = s[findfirst(Regex(look_for(one_or_more(ANY),after="(",before=")")),s)]
                    imagepath = Core.eval(Runner,Meta.parse(pathvariable))
                else
                    imagepath = s[findfirst(Regex(look_for(one_or_more(ANY),after="(\"",before="\")")),s)]
                end
                push!(outputs,(:image,pwd()*"/"*imagepath))
            else
                io = IOBuffer();
                cd(runpath)

                Base.invokelatest(show,
                    IOContext(io, :limit => true),"text/plain",
                    dispatch_output(Core.eval(Runner,ex), notebookdata[:notebookname], path, figureindex));
                cd(notebookdata[:notebookdir])

                celloutput = String(take!(io))
                if celloutput == "nothing"
                    push!(outputs,(:nothing, ""))
                elseif startswith(celloutput, "Plot{Plots.")
                    push!(outputs,
                    (:plot,notebookdata[:notebookname]*"_"*"figure"*string(figureindex[:i])*".png"))
                elseif startswith(celloutput, "FigureAxisPlot()")
                    push!(outputs,
                    (:plot,notebookdata[:notebookname]*"_"*"figure"*string(figureindex[:i])*".pdf"))
                else
                    push!(outputs,(:text, celloutput))
                end
            end
        else
            push!(outputs,nothing)
        end
    end
    cd(runpath)
    return outputs
end

function dispatch_output(command_eval::Makie.FigureAxisPlot, notebookname, path, figureindex)
    figureindex[:i]+=1
    save(path*"/figures/"*notebookname*"_"*"figure"*string(figureindex[:i])*".pdf", command_eval)
    return command_eval
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

"""
    plutotolatex(notebookname, targetdir="./build_latex"; template=:book, fontpath=nothing)
Function to convert Pluto notebooks. The arguments are the same as the ones in
`notebooktolatex`.
"""
function plutotolatex(notebookname, targetdir="./build_latex"; template=:book, fontpath=nothing)

    createproject(targetdir, template, fontpath)
    nb = extractnotebook(notebookname)
    texfile = read(targetdir*"/main.tex", String)
    lineinsert = 1
    for (i,line) in enumerate(split(texfile, "\n"))
            lineinsert = i
            if startswith(line, "% INCLUDE NOTEBOOKS")
            break
        end
    end
    
    if !occursin("\\include{./notebooks/"*nb[:notebookname]*"}",read(targetdir*"/main.tex", String))

        insertlinebelow(targetdir*"/main.tex",
            "\\include{./notebooks/"*nb[:notebookname]*"}", lineinsert)
    end

    outputs = collectoutputs(nb,targetdir);
    notebook = targetdir*"/notebooks/"*nb[:notebookname]*".tex"
    open(notebook, "w") do f
        write(f,"\\newpage\n")
        for i in nb[:order]
            if nb[:celltype][i] == "markdown"
                if startswith(strip(nb[:contents][i]), "md\"\"\"")
                    parsed = markdowntolatex(strip(nb[:contents][i])[7:end-3], targetdir, nb[:notebookdir])*"\n\n"
                elseif startswith(strip(nb[:contents][i]), "md\"")
                    parsed = markdowntolatex(strip(nb[:contents][i])[4:end-1], targetdir, nb[:notebookdir])*"\n\n"
                else
                    throw(DomainError("Markdown cell must start with either md\"\"\" or md\"."))
                end
                write(f,parsed)
            elseif nb[:celltype][i] == "code" && nb[:view][i] == "showcode"
                write(f,"\n\\begin{lstlisting}[language=JuliaLocal, style=julia]\n")
                write(f, strip(nb[:contents][i]))
                write(f,"\n\\end{lstlisting}\n")
            end
            if nb[:celltype][i] == "code" && nb[:outputtag][i] == "showoutput"
                if outputs[i][1] == :text
                    write(f,"\n\\begin{verbatim}\n")
                    write(f, outputs[i][2])
                    write(f,"\n\\end{verbatim}\n")
                elseif outputs[i][1] == :plot
                    write(f,"\n\\begin{figure}[H]\n")
                    write(f,"\t\\centering\n")
                    write(f,"\t\\includegraphics[width=0.8\\textwidth]{./figures/"*outputs[i][2]*"}\n")
                    write(f,"\t\\label{fig:"*outputs[i][2]*"}\n")
                    write(f,"\n\\end{figure}\n")
                elseif outputs[i][1] == :image
                    figurename = ""
                    if outputs[i][2][end-3:end] == ".svg"
                        figuresvg = outputs[i][2]
                        figurename *= basename(figuresvg[1:end-4])
                        figurepdf = targetdir*"/figures/"*figurename*".pdf"
                        rsvg_convert() do cmd
                           run(`$cmd $figuresvg -f pdf -o $figurepdf`)
                        end
                    else
                        figurename *= basename(outputs[i][2])
                        cp(outputs[i][2],targetdir*"/figures/"*figurename, force=true)
                    end
                    write(f,"\n\\begin{figure}[H]\n")
                    write(f,"\t\\centering\n")
                    write(f,"\t\\includegraphics[width=0.8\\textwidth]{./figures/"*figurename*"}\n")
                    #= write(f,"\t\\includegraphics[width=0.8\\textwidth]{"*outputs[i][2]*"}\n") =#
                    write(f,"\t\\label{fig:"*outputs[i][2]*"}\n")
                    write(f,"\n\\end{figure}\n")
                end
            end
        end
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
                parsed = markdowntolatex(strip(join(cell["source"])), targetdir, notebookdir)
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
                        elseif nestedget(output,["data","image/png"], nothing) !== nothing
                            png = base64decode(output["data"]["image/png"])
                            
                            figureindex[:i]+=1
                            figurename = notebookname*"_figure"*string(figureindex[:i])*".png"
                            write(targetdir*"/figures/"*figurename, png)
                            write(f,"\n\\begin{figure}[H]\n")
                            write(f,"\t\\centering\n")
                            write(f,"\t\\includegraphics[width=0.8\\textwidth]{./figures/"*figurename*"}\n")
                            write(f,"\t\\label{fig:"*figurename*"}\n")
                            write(f,"\n\\end{figure}\n")
                        elseif nestedget(output,["data","image/svg+xml"], nothing) !== nothing
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