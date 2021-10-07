module PlutoLatexConverter
using Pluto
using ReadableRegex


"""
    tagcelloutput(cell)
Reads the cell and add a tag for whether the output should
be displayed or not. This is done by checking if there is a `;`
at the end of the cell.
"""
    function tagcelloutput(cell)
        p = findlast(";",cell)
        if p ≢ nothing
            if match(Regex(look_for(";",before=one_or_more(maybe(("\\n","\\t"))))),cell[p[1]:end]) != nothing
                return "hideoutput"
            else
                return "showoutput"
            end
        else
            return "showoutput"
        end
    end

"""
    extractnotebook(notebook)
Reads a Pluto notebook file, extracts the code
and returns a dictionary with the code in organized form.
The output is a dictionary containing
* `codes`    - The cell code of each running cell;
* `cells`    - The raw string in the cell;
* `contents` - Only the Julia code in the cell;
* `view`     - Whether the code is hidden or showing (the "eye" icon in the notebook);
* `outputtag`- Whether the output is hidden or showing (read the `tagcelloutput()` function).
e.g. `extractnotebook("./mynotebook.jl")`
"""
    function extractnotebook(notebook)
        s = read(notebook, String)
        cells = split(s, "# ╔═╡ ");

        # The first cell is always a comment from Pluto
        # and the last 3 are the Project, Manifest and the order
        # hence, we only need the rest, which are the actual code.

        codes = [cell[1:36] for cell in cells[2:end-1]]
        contents = [cell[38:end] for cell in cells[2:end-3]]
        
        r = either("# ╠","# ╟")
        sortedcells = split(cells[end],Regex(r))
        sortedcodes = [cell[4:39] for cell in sortedcells[2:end]]
        order = [findfirst(isequal(scode),codes) for scode in  sortedcodes[1:end]]
        view  = [occursin("═",c) ? "showcode" : "hidecode" for c in sortedcells[2:end]]
        # Matching running order
        view  = view[order]
        outputtag = [tagcelloutput(cell) for cell in cells[2:end-3]]
        
        notebookdata = Dict(:codes => codes[1:end-2], :cells => cells[2:end-2],
            :contents => contents, :order=> order[1:end-2], :view=>view[1:end-2], :outputtag=>outputtag)
        return notebookdata
    end

end
