function parsesentence(sentence)
    return sentence |> parsefigures |> parselinks |> parsebold |> parseitalics
end

function parsefigures(md)
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
        parsedsentence *= "\\href{" * text * "}{" * link * "}"
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
        parsedsentence *= "\\href{" * link * "}{" * text * "}"
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

function parseparagraph(paragraph)
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
                    parsedparagraph *= parsesentence(subsentence)
                end
            end
        end
    end
    return parsedparagraph
end

function markdowntolatex(md)
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
                parsedtext *= parseparagraph(l)
            #= end =#
        end
    end
    return parsedtext
end
