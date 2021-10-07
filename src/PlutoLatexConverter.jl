module PlutoLatexConverter
using Pluto
using ReadableRegex

function tagcells(codes)
    
end

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
        order = [findfirst(isequal(scode),codes) for scode in  sortedcodes]
        view  = [occursin("═",c) for c in sortedcells[2:end]]
        notebookdata = Dict(:codes => codes, :cells => cells, :contents => contents, :order=> order, :view=>view)

        return notebookdata
    end
end
