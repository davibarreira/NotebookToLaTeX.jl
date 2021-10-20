# Contains helper functions
# Functions for inserting text are based on
# https://discourse.julialang.org/t/write-to-a-particular-line-in-a-file/50179



############# Project Structure Helper Function ###############
# Collection of functions creating the latex files and
# directories. Inside the "target directory" which is equivalent
# the `path` varible, there are some files:
# `main.tex` - Main file to run build the pdf;
# `julia_font.tex` - Font information;
# `julia_listings.tex` - Listings configurations;
# `julia_listings_unicode.tex` - Listings unicodes;
# `preface.tex` - Preface when using a book latex template.
# There are four folders:
# `figures/` - Location where plots are saved;
# `fonts/` - Location of the `.ttf` files for the Julia-Mono font;
# `frontmatter/`- Files used in the book latex template;
# `notebooks/`  - Contains the latex files for each converted notebook.


"""
    createfolders(targetdir="./")
Creates the directories for the latex project.
"""
function createfolders(targetdir="./")
    if !isdir(targetdir)
        mkpath(targetdir * "/notebooks")
        mkpath(targetdir * "/figures")
        mkpath(targetdir * "/frontmatter")
    else
        if !isdir(targetdir * "/notebooks")
            mkpath(targetdir * "/notebooks")
        end
        if !isdir(targetdir * "/figures")
            mkpath(targetdir * "/figures")
        end
        if !isdir(targetdir * "/frontmatter")
            mkpath(targetdir * "/frontmatter")
        end
    end
end

"""
    downloadfonts(targetdir="./"; fontpath=nothing)
Downloads the Julia-Mono fonts necessary. If the user already
has the fonts installed, he can provide `fontpath` to
be used, instead of downloading `.ttf` files.
Note that in such case, the `fonts/` dictory will be empty.
If you use a font manager, the Julia-Mono font might
be found in a path such as the one below:
```
fontpath = "/home/username/.local/share/fonts/Unknown Vendor/TrueType/JuliaMono/"
```
"""
function downloadfonts(targetdir="./"; fontpath=nothing)
    if fontpath === nothing
        if !isdir(targetdir * "/fonts")
            mkpath(targetdir * "/fonts")
            fontsourcepath = joinpath(@__DIR__, "../templates/fonts/")
            for font in readdir(fontsourcepath)
                cp(joinpath(fontsourcepath, font),
                   joinpath(targetdir * "/fonts/", font))
            end
        end
        # the code below sets font path in the julia_font.tex file
        julia_font_tex = targetdir * "/julia_font.tex"
        writetext(julia_font_tex, "./fonts/,", 6)
    else
        julia_font_tex = targetdir * "/julia_font.tex"
        writetext(julia_font_tex, fontpath * "/,", 6)
    end
end

"""
    createproject(targetdir="./", template=:book, fontpath=nothing)
This function just call all the other auxiliary functions
in order to create the proper files and directories.
Note that first the folders must be created, then
the main latex template files, followed by the auxiliary
latex listings, and finally, the fonts.
"""
function createproject(targetdir="./", template=:book, fontpath=nothing)
    createfolders(targetdir)
    createtemplate(targetdir, template)
    createauxiliarytex(targetdir)
    downloadfonts(targetdir, fontpath=fontpath)
end


############# Text Helper Function ###############
# Collection of functions for inserting text in
# specific locations of a file

"""
    skiplines(io::IO, n)
Helper function for skipping lines when reading a file.
"""
function skiplines(io::IO, n)
    i = 1
    while i <= n
        eof(io) && error("File contains less than $n lines")
        i += read(io, Char) === '\n'
    end
end

"""
    writetext(file::String, text::String, linenumber::Integer, endline=true)
Writes a `text` to a `file` in an specific `linenumber`. By default,
the text is appended at the end of the line (`endline = true`). If
`endline` is set to false, then the text is actually written in
the beggining of the line. The text is appended, and does not overwrite
what is already written in the file.
"""
function writetext(file::String, text::String, linenumber::Integer, endline=true)
    f = open(file, "r+");
    if endline
        skiplines(f, linenumber);
        skip(f, -1)
    else
        skiplines(f, linenumber - 1);
    end
    mark(f)
    buf = IOBuffer()
    write(buf, f)
    seekstart(buf)
    reset(f)
    print(f, text);
    write(f, buf)
    close(f)
end

"""
    insertlineabove(file::String, text::String, linenumber::Integer)
Inserts a line of `text` in a `file` above the `linenumber`.
"""
function insertlineabove(file::String, text::String, linenumber::Integer)
    if linenumber == 1
        writetext(file, text * "\n", linenumber, false)
    else
        writetext(file, "\n" * text, linenumber - 1)
    end
end

"""
    insertlinebelow(file::String, text::String, linenumber::Integer)
Inserts a line of `text` in a `file` below the `linenumber`.
"""
function insertlinebelow(file::String, text::String, linenumber::Integer)
    writetext(file, "\n" * text, linenumber)
end

################ Parsing Nested Dictionary #####################
"""
    nestedget(dict::Dict, keys::AbstractVector, default = nothing)
Checks whether `dict["key1"]["key2"]...["keyn"]` exists,
returing it's value or the `default`.
"""
function nestedget(dict::Dict, keys::AbstractVector, default=nothing)
    if isempty(keys)
        return dict
    end
    key = popfirst!(keys)
    if haskey(dict, key)
        return nestedget(dict[key], keys)
    end
    return default
end

"""
    nestedget(non_dict, keys::AbstractVector, default = nothing)
This function is an auxiliary used by `nestedget` above
in order to extrac the value from the last key.
"""
function nestedget(non_dict, keys::AbstractVector, default = nothing)
    if isempty(keys)
        return non_dict
    end
    return default
end

function jupytertolatex(notebook, targetdir="./build_latex"; template=:book, fontpath=nothing)

    createproject(targetdir, template)
    
    notebookname = basename(notebook)
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

    notebook = targetdir*"/notebooks/"*notebookname*".tex"
    open(notebook, "w") do f
        write(f,"\\newpage\n")
        for cell in jsonnb["cells"]
            
            # Checks whether the cell has markdown
            if get(cell,"cell_type", false) == "markdown"
                parsed = markdowntolatex(strip(join(cell["source"])))
                write(f,parsed)
                
            # Checks whether the cell has code and whether the code is hidden
            elseif get(cell,"cell_type", false) == "code" && nestedget(cell,["metadata","jupyter", "source_hidden"],false)
                write(f,"\n\\begin{lstlisting}[language=JuliaLocal, style=julia]\n")
                write(f, strip(join(cell["source"])))
                write(f,"\n\\end{lstlisting}\n")
            end
            
            
            ## Collecting outputs
            
            # Checks if the output is an empty array or if the outputs_hidden is true
            check_output_hidden = get(cell, "output",[]) == [] || nestedget(cell, ["metadata","jupyter","outputs_hidden"], false) == true
            
            # Collect the output if the cell has code and the output is not hidden
            #= if get(cell, "cell_type") == "code" && check_output_hidden == false =#
            #=     if outputs[i][1] == :text =#
            #=         write(f,"\n\\begin{verbatim}\n") =#
            #=         write(f, outputs[i][2]) =#
            #=         write(f,"\n\\end{verbatim}\n") =#
            #=     elseif outputs[i][1] == :plot =#
            #=         write(f,"\n\\begin{figure}[H]\n") =#
            #=         write(f,"\t\\centering\n") =#
            #=         write(f,"\t\\includegraphics[width=0.8\\textwidth]{./figures/"*outputs[i][2]*"}\n") =#
            #=         write(f,"\t\\label{fig:"*outputs[i][2]*"}\n") =#
            #=         write(f,"\n\\end{figure}\n") =#
            #=     elseif outputs[i][1] == :image =#
            #=         write(f,"\n\\begin{figure}[H]\n") =#
            #=         write(f,"\t\\centering\n") =#
            #=         write(f,"\t\\includegraphics[width=0.8\\textwidth]{"*outputs[i][2]*"}\n") =#
            #=         write(f,"\t\\label{fig:"*outputs[i][2]*"}\n") =#
            #=         write(f,"\n\\end{figure}\n") =#
            #=     end =#
            #= end =#
        end
    end
end
