module PlutoLatexConverter
using ReadableRegex
export extractnotebook, collectoutputs


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
function extractnotebook(notebook)
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
    
    notebookdata = Dict(:codes => codes,
                        :contents => contents, :outputtag=>outputtag,
                        :celltype => celltype,:order=> order,:view=>view)
    return notebookdata
end

function collectoutputs(notebookdata, notebookfolder="./")
    runpath = pwd()
    cd(notebookfolder)
    io = IOBuffer();
    expressions=[]
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
                imagepath = s[findfirst(Regex(look_for(one_or_more(ANY),after="(",before=")")),s)]
                push!(outputs,("imagepath",imagepath))
            else
                Base.invokelatest(show,IOContext(io, :limit => true), "text/plain", Runner.eval(ex))
                celloutput = String(take!(io))
                if celloutput == "nothing"
                    celloutput = ""
                end
                push!(outputs, celloutput)
                push!(expressions, ex)
            end
        end
    end
    cd(runpath)
    return outputs, expressions
end

end
