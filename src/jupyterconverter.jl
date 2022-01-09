"""
    jupytertolatex(notebook, targetdir="./build_latex"; template=:book, fontpath=nothing)
Function to convert Jupyter notebooks. The arguments are the same as the ones in
`notebooktolatex`.
"""
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
                    # The textcl=true option is for using words with accent in the comments. Useful for non-english.
                    write(f,"\n\\begin{lstlisting}[language=JuliaLocal, style=julia, texcl=true]\n")
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
                        write(f,"\n\\begingroup\n")
                        write(f,"\n\\fontsize{10pt}{12pt}\\selectfont\n")
                        write(f,"\n\\begin{verbatim}\n")
                        write(f, join(output["text"]))
                        write(f,"\n\\end{verbatim}\n")
                        write(f,"\n\\endgroup\n")
                    elseif get(output, "output_type", nothing) == "execute_result"
                        if nestedget(output,["data","text/latex"], nothing) !== nothing
                            write(f, "\n"*join(output["data"]["text/latex"]))
                        elseif nestedget(output,["data","text/plain"], nothing) !== nothing
                            write(f,"\n\\begingroup\n")
                            write(f,"\n\\fontsize{10pt}{12pt}\\selectfont\n")
                            write(f,"\n\\begin{verbatim}\n")
                            write(f, "\n"*join(output["data"]["text/plain"]))
                            write(f,"\n\\end{verbatim}\n")
                            write(f,"\n\\endgroup\n")
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
