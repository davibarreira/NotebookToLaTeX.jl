function parsesentence(sentence)
    parsedsentence = ""
    for word in split(sentence, " ")
        if findfirst(Regex(look_for(one_or_more(ANY), after="[", before="](")), word) != nothing && findfirst(Regex(look_for(one_or_more(ANY), after="](", before=")")), word) != nothing
            linktext = word[findfirst(Regex(look_for(one_or_more(ANY), after="[", before="]")), word)]
            linkref  = word[findfirst(Regex(look_for(one_or_more(ANY), after="(", before=")")), word)]
            parsedsentence *= "\\href{" * linkref * "}{" * linktext * "}" * word[findfirst(Regex(look_for(one_or_more(ANY), after="(", before=")")), word)[end] + 2:end] * " "
        elseif findfirst(Regex(look_for(one_or_more(ANY), after="**", before="**")), word) != nothing
            bword = word[findfirst(Regex(look_for(one_or_more(ANY), after="**", before="**")), word)]
            parsedsentence *= "\\textbf{" * bword * "}" * word[findfirst(Regex(look_for(one_or_more(ANY), after="**", before="**")), word)[end] + 3:end] * " "
        elseif findfirst(Regex(look_for(one_or_more(ANY), after="*", before="*")), word) != nothing
            iword = word[findfirst(Regex(look_for(one_or_more(ANY), after="*", before="*")), word)]
            parsedsentence *= "\\textbf{" * iword * "}" * word[findfirst(Regex(look_for(one_or_more(ANY), after="*", before="*")), word)[end] + 2:end] * " "
        else
            parsedsentence *= word * " "
        end
    end
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
                    parsedparagraph *= "\\lstinline{" * subsentence * "}"
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
