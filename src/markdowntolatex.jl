function parsesentence(md, targetdir)
    return parsefigures(md, targetdir) |> parselinks |> parsebold |> parseitalics
end

function parsefigures(md, targetdir)
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
            figuresvg = link
            figurename *= basename(figuresvg[1:end - 4])
            figurepdf = targetdir * "/figures/" * figurename * ".pdf"
            rsvg_convert() do cmd
               run(`$cmd $figuresvg -f pdf -o $figurepdf`)
           end
        else
            figurename *= basename(link)
            cp(link, targetdir * "/figures/" * figurename, force=true)
        end

        parsedsentence *= "\n\\begin{figure}[H]\n\t \\centering\n\t\\includegraphics[width=0.8\\textwidth]{./figures/" * figurename * "}\n\t\\caption{" * text * "}\n\t\\label{fig:" * figurename * "}\n\\end{figure}\n"
        #= * text * "}{" * link * "}" =#
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

function parseparagraph(paragraph, targetdir)
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
                    parsedparagraph *= parsesentence(subsentence, targetdir)
                end
            end
        end
    end
    return parsedparagraph
end

function markdowntolatex(md, targetdir)
    tag = false
    component = ""
    parsedtext = ""
    for line in split(md, "\n")
        l = strip(line)

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
            parsedtext *= "\n\\subsubsection{" * l[6:end] * "}\n"
            continue
        elseif startswith(l, "###")
            parsedtext *= "\n\\subsection{" * l[5:end] * "}\n"
            continue
        elseif startswith(l, "##")
            parsedtext *= "\n\\section{" * l[4:end] * "}\n"
            continue
        elseif startswith(l, "#")
            parsedtext *= "\n\\chapter{" * l[3:end] * "}\n"
            continue
    end
        

        if tag
            parsedtext *= "\t" * l * "\n"
        elseif !tag
            #= if !startswith(l, "#") =#
                parsedtext *= parseparagraph(l, targetdir)
            #= end =#
        end
    end
    return parsedtext
end
