function parsesentence(md, targetdir, notebookdir)
    return parsefigures(md, targetdir, notebookdir) |> parselinks |> parsebold |> parseitalics
end

function parsefigures(md, targetdir, notebookdir)
    parsedsentence = ""
    i = 1

    while i < length(md)
        pstart    = findnext("![", md, i)              !== nothing ? findnext("![", md, i)              : break
        pend      = findnext("]", md, pstart[end])    !== nothing ? findnext("]", md, pstart[end])    : break
        linkstart = findnext("(", md, pend[end])       !== nothing ? findnext("(", md, pend[end])       : break
        linkend   = findnext(")", md, linkstart[end]) !== nothing ? findnext(")", md, linkstart[end]) : break

        parsedsentence *= md[i:pstart[1] - 1]
        text = md[pstart[end] + 1:pend[1] - 1]
        link = md[linkstart[end] + 1:linkend[1] - 1]
        figurename = ""
        if link[end - 3:end] == ".svg"
            figuresvg = notebookdir * link
            figurename *= basename(figuresvg[1:end - 4])
            figurepdf = targetdir * "/figures/" * figurename * ".pdf"
            rsvg_convert() do cmd
               run(`$cmd $figuresvg -f pdf -o $figurepdf`)
           end
        else
            figurename *= basename(link)
            cp(notebookdir * link, targetdir * "/figures/" * figurename, force=true)
        end

        parsedsentence *= "\n\\begin{figure}[H]\n\t \\centering\n\t\\includegraphics[width=0.8\\textwidth]{./figures/" * figurename * "}\n\t\\caption{" * text * "}\n\t\\label{fig:" * figurename * "}\n\\end{figure}\n"
        i = linkend[end] + 1

    end
    parsedsentence *= md[i:end]
    return parsedsentence
end

function parselinks(md)
    parsedsentence = ""
    i = 1

    while i < length(md)
        pstart    = findnext("[", md, i)              !== nothing ? findnext("[", md, i)              : break
        pend      = findnext("]", md, pstart[end])    !== nothing ? findnext("]", md, pstart[end])    : break
        linkstart = findnext("(", md, pend[end])       !== nothing ? findnext("(", md, pend[end])       : break
        linkend   = findnext(")", md, linkstart[end]) !== nothing ? findnext(")", md, linkstart[end]) : break

        parsedsentence *= md[i:pstart[1] - 1]
        text = md[pstart[end] + 1:pend[1] - 1]
    link = md[linkstart[end] + 1:linkend[1] - 1]
        parsedsentence *= " \\href{" * link * "}{" * text * "}"
    i = linkend[end] + 1
    end
    parsedsentence *= md[i:end]
    return parsedsentence
end

function parseitalics(md)
    parsedsentence = ""
    i = 1
    while i < length(md)
        pstart    = findnext("*", md, i) !== nothing ? findnext("*", md, i)               : break
        pend      = findnext("*", md, pstart[end] + 1) !== nothing ? findnext("*", md, pstart[end] + 1)    : break
        parsedsentence *= md[i:pstart[1] - 1]
text = md[pstart[end] + 1:pend[1] - 1]
        parsedsentence *= "\\textit{" * text * "}"
        i = pend[end] + 1
    end
    parsedsentence *= md[i:end]
    return parsedsentence
end

function parsebold(md)
    parsedsentence = ""
    i = 1
    while i < length(md)
        pstart    = findnext("**", md, i) !== nothing ? findnext("**", md, i)               : break
        pend      = findnext("**", md, pstart[end]) !== nothing ? findnext("**", md, pstart[end])    : break
        parsedsentence *= md[i:pstart[1] - 1]
        text = md[pstart[end] + 1:pend[1] - 1]
        parsedsentence *= "\\textbf{" * text * "}"
        i = pend[end] + 1
        end
    parsedsentence *= md[i:end]
    return parsedsentence
end

function parseparagraph(paragraph, targetdir, notebookdir)
    parsedparagraph = ""
    for (i, sentence) in enumerate(split(paragraph, "\$"))
        if iseven(i)
            # It's a math sentence, i.e text is between $ $, so nothing should be parsed
            parsedparagraph *= "\$" * sentence * "\$"
                    else
            for (i, subsentence) in enumerate(split(sentence, "`"))
                if iseven(i)
                    # It's a code sentence, i.e text is between ` ` and is not a math sentence.
                    parsedparagraph *= "\\lstinline[style=julia]{" * subsentence * "}"
                else
                    parsedparagraph *= parsesentence(subsentence, targetdir, notebookdir)
                end
            end
        end
    end
    return parsedparagraph
end



"""
    configparser(config=nothing, template=:book)
This function contains the configuration to be used in the
Markdown to LaTeX parser.
"""
# function configparser(config=nothing, template=:book)
    # Note that the order is important! It defines the order
    # for the parser evaluation.
    # parserdictionary = 
# end

function markdowntolatex(md, targetdir, notebookdir; template=:book)
    tag = false
    component = ""
    parsedtext = ""
    for line in split(md, "\n")
        l = strip(line)
        if l == ""
            l = "\n\n"
        end

        if startswith(l, "```math")
            tag = !tag
            parsedtext *= "\n\\begin{displaymath}\n"
            component = "displaymath"
            continue
        elseif startswith(l, "```") && tag
            tag = !tag
            parsedtext *= "\\end{" * component * "}\n"
            continue

        elseif startswith(l, "\$\$")
            if !tag
                tag = !tag
                parsedtext *= "\n\\begin{displaymath}\n"
            else
                tag = !tag
                parsedtext *= "\\end{displaymath}\n"
            end
            continue
        elseif startswith(l, "####")
            if template == :article || template == :matharticle
                parsedtext *= "\n\\textbf{" * l[6:end] * "}\n"
            else
                parsedtext *= "\n\\subsubsection{" * l[6:end] * "}\n"
            end
            continue
        elseif startswith(l, "###")
            if template == :article || template == :matharticle
                parsedtext *= "\n\\subsubsection{" * l[5:end] * "}\n"
            else
                parsedtext *= "\n\\subsection{" * l[5:end] * "}\n"
            end
            continue
        elseif startswith(l, "##")
            if template == :article || template == :matharticle
                parsedtext *= "\n\\subsection{" * l[4:end] * "}\n"
            else
                parsedtext *= "\n\\section{" * l[4:end] * "}\n"
            end
            continue
        elseif startswith(l, "#")
            if template == :article || template == :matharticle
                parsedtext *= "\n\\section{" * l[3:end] * "}\n"
            else
                parsedtext *= "\n\\chapter{" * l[3:end] * "}\n"
            end
            continue
    end
        

        if tag
            parsedtext *= "\t" * l * "\n"
        elseif !tag
            parsedtext *= parseparagraph(l, targetdir, notebookdir)
        end
    end
    return parsedtext
end
