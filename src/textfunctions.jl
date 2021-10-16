# Contains helper functions for inserting text in files
# Functions based on https://discourse.julialang.org/t/write-to-a-particular-line-in-a-file/50179


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
