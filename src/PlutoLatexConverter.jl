module PlutoLatexConverter
using ReadableRegex
using Plots
using Makie
using CairoMakie
export extractnotebook, collectoutputs, createfolders


figureindex = 0

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
* `codes`    - The cell code of each running cell;
* `contents` - Only the Julia code in the cell;
* `outputtag`- Whether the output is hidden or showing (read the `tagcelloutput()` function);
* `celltype` - Whether cell contains code or markdown;
* `view`     - Whether the code is hidden or showing (the "eye" icon in the notebook);
* `order`    - Order that the cells are displayed in the notebook;
e.g. `extractnotebook("./mynotebook.jl")`
"""
function extractnotebook(notebook, notebookname=nothing)
    s = read(notebook, String)
    cells = split(s, "# ╔═╡ ");
    # The first cell and the final 3 are not used
    codes, contents, outputtag, celltype = [],[],[],[]
    for cell in cells[2:end-3]
        push!(codes, cell[1:36])
        push!(contents, cell[38:end])
        push!(outputtag, endswith(rstrip(cell),";") ? "hideoutput" : "showoutput")
        push!(celltype, cell[38:42] == "md\"\"\"" ? "markdown" : "code")
    end
    
    # Get order and view type
    r = either("# ╠","# ╟")
    sortedcells = split(cells[end],Regex(r))
    sortedcodes = [cell[4:39] for cell in sortedcells[2:end-2]]
    order = [findfirst(isequal(scode),codes) for scode in  sortedcodes[1:end]]
    view  = [occursin("═",c) ? "showcode" : "hidecode" for c in sortedcells[2:end-2]]
    # Matching running order
    view  = view[order]

    # inferring the notebook name
    # base on the notebook file path.
    if notebookname === nothing
        notebookname = split(notebook,"/")[end]
        if endswith(notebookname,".jl")
            # removes the ".jl" in the end
            notebookname = notebookname[1:end-3]
        end
    end
    
    notebookdata = Dict(:codes => codes, :notebookname => notebookname,
                        :contents => contents, :outputtag=>outputtag,
                        :celltype => celltype,:order=> order,:view=>view)
    return notebookdata
end

function collectoutputs(notebookdata, notebookfolder="./")
    runpath = pwd()
    cd(notebookfolder)
    outputs = []
    for (i, content) ∈ enumerate(notebookdata[:contents])
        if notebookdata[:celltype][i] == "code"
            if startswith(lstrip(content),"begin") && endswith(rstrip(content),"end")
                ex = :($(Meta.parse(strip(content))))
            else
                ex = :($(Meta.parse("begin\n"*content*"\nend")))
            end
            
            s = string(ex.args[end])
            if contains(s, Regex(either("PlutoUI.LocalResource","LocalResource")))
                if findfirst(Regex(look_for(one_or_more(ANY),after="(\"",before="\")")),s) === nothing
                    Runner.eval(ex)
                    pathvariable = s[findfirst(Regex(look_for(one_or_more(ANY),after="(",before=")")),s)]
                    imagepath = Runner.eval(Meta.parse(pathvariable))
                else
                    imagepath = s[findfirst(Regex(look_for(one_or_more(ANY),after="(\"",before="\")")),s)]
                end
                push!(outputs,(:image,imagepath))
            else
                io = IOBuffer();
                Base.invokelatest(show,
                    IOContext(io, :limit => true),"text/plain",
                    dispatch_output(Runner.eval(ex), notebookdata[:notebookname], runpath));
                celloutput = String(take!(io))
                if celloutput == "nothing"
                    push!(outputs,nothing)
                elseif startswith(celloutput, "Plot{Plots.")
                    push!(outputs,
                    (:plot,notebookdata[:notebookname]*"_"*"figure"*string(figureindex)*".png"))
                elseif startswith(celloutput, "FigureAxisPlot()")
                    push!(outputs,
                    (:plot,notebookdata[:notebookname]*"_"*"figure"*string(figureindex)*".png"))
                else
                    push!(outputs,(:text, celloutput))
                end
            end
        end
    end
    cd(runpath)
    return outputs
end

function dispatch_output(command_eval::Makie.FigureAxisPlot, notebookname, runpath)
    global figureindex+=1
    save(runpath*"/build_latex/notebooks/"*notebookname*"_"*"figure"*string(figureindex)*".png", command_eval)
    return command_eval
end

function dispatch_output(command_eval::Plots.Plot, notebookname, runpath)
    global figureindex+=1
    println(runpath)
    savefig(command_eval,runpath*"/build_latex/notebooks/"*notebookname*"_"*"figure"*string(figureindex)*".png")
    return command_eval
end

function dispatch_output(command_eval, notebookname, runpath)
   return command_eval 
end

function createfolders(path="./")
    folder = path*"/build_latex/"
    if !isdir(folder)
    mkpath(folder*"notebooks")
    mkpath(folder*"figures")
    else
        if !isdir(folder*"notebooks")
            mkpath(folder*"notebooks")
        end
        if !isdir(folder*"figures")
            mkpath(folder*"figures")
        end
    end
end

end
