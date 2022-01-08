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

function dispatch_output(command_eval::Plots.Plot, notebookname, path, figureindex)
    figureindex[:i]+=1
    Plots.savefig(command_eval,path*"/figures/"*notebookname*"_"*"figure"*string(figureindex[:i])*".png")
    return command_eval
end

function dispatch_output(command_eval::Makie.FigureAxisPlot, notebookname, path, figureindex)
    figureindex[:i]+=1
    CairoMakie.save(path*"/figures/"*notebookname*"_"*"figure"*string(figureindex[:i])*".pdf", command_eval)
    return command_eval
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
                    parsed = markdowntolatex(strip(nb[:contents][i])[7:end-3],
                        targetdir, nb[:notebookdir], template=template)*"\n\n"
                elseif startswith(strip(nb[:contents][i]), "md\"")
                    parsed = markdowntolatex(strip(nb[:contents][i])[4:end-1],
                        targetdir, nb[:notebookdir], template=template)*"\n\n"
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
