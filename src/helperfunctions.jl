# Contains helper functions
# Functions for inserting text are based on
# https://discourse.julialang.org/t/write-to-a-particular-line-in-a-file/50179


function createfolders(path="./")
    folder = path
    if !isdir(folder)
        mkpath(folder * "/notebooks")
        mkpath(folder * "/figures")
        mkpath(folder * "/frontmatter")
    else
        if !isdir(folder * "/notebooks")
            mkpath(folder * "/notebooks")
        end
        if !isdir(folder * "/figures")
            mkpath(folder * "/figures")
        end
        if !isdir(folder * "/frontmatter")
            mkpath(folder * "/frontmatter")
        end
    end
end

function downloadfonts(path="./"; fontpath=nothing)
    if fontpath === nothing
        if !isdir(path * "/fonts")
            mkpath(path * "/fonts")
            fontsourcepath = joinpath(@__DIR__, "../templates/fonts/")
            for font in readdir(fontsourcepath)
                cp(joinpath(fontsourcepath, font),
                   joinpath(path * "/fonts/", font))
            end
        end
        julia_font_tex = path * "/julia_font.tex"
        writetext(julia_font_tex, "./fonts/,", 6)
    else
        julia_font_tex = path * "/julia_font.tex"
        writetext(julia_font_tex, fontpath * "/,", 6)
    end
end

function createproject(path="./", template=:book, fontpath=nothing)
    createfolders(path)
    createtemplate(path, template)
    createauxiliarytex(path)
    downloadfonts(path, fontpath=fontpath)
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
