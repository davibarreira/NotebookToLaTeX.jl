"""
    createtemplate(path=".", template=:book)
Creates the latex files such as `main.tex`,
`preface.tex`, `frontmatter/titlepage.tex` and
`frontmatter/copyright.tex`. The `.tex` files depend on the template used.
At the moment, the available templates are `:book` and
`:mathbook`, which are pretty much the same, but `:mathbook`
imports some more packages specific for mathematics.
"""
function createtemplate(path=".", template=:book)

    if template == :book
        tex = read(String(@__DIR__)*"/../templates/book.tex", String)

    elseif template == :mathbook
        tex = read(String(@__DIR__)*"/../templates/mathbook.tex", String)


    elseif template == :article
        tex = read(String(@__DIR__)*"/../templates/article.tex", String)

    elseif template == :matharticle
        tex = read(String(@__DIR__)*"/../templates/matharticle.tex", String)
    end

    maintex = path * "/main.tex"
    if !isfile(maintex)
        open(maintex, "w") do f
            write(f, tex)
        end
    end


    if template == :book || template == :mathbook
        preface = "\\newpage\n\\chapter*{Preface}\n\\addcontentsline{toc}{chapter}{Preface}\n"
        prefacetex = path * "/preface.tex"

        if !isfile(prefacetex)
            open(prefacetex, "w") do f
                write(f, preface)
            end
        end

        titlepage = read(String(@__DIR__)*"/../templates/frontmatter/titlepage.tex", String)

        titlepagetex = path * "/frontmatter/titlepage.tex"
        if !isfile(titlepagetex)
            open(titlepagetex, "w") do f
                write(f, titlepage)
            end
        end

        copyright = read(String(@__DIR__)*"/../templates/frontmatter/copyright.tex", String)

        copyrighttex = path * "/frontmatter/copyright.tex"
        if !isfile(copyrighttex)
            open(copyrighttex, "w") do f
                write(f, copyright)
            end
        end
    end
end

