"""
    createauxiliarytex(path="./")
Creates the `julia_font.tex`, `julia_listings.tex` and
`julia_listings_unicode.tex` files.
"""
function createauxiliarytex(path="./")
    
    juliafont = read("../templates/julia_font.tex", String)

    julialistings = read("../templates/julia_listings.tex", String)

    julialistingsunicode = read("../templates/julia_listings_unicode.tex", String)

    julia_font_tex = path * "/julia_font.tex"
    open(julia_font_tex, "w") do f
        write(f, juliafont)
    end

    julia_listings_tex = path * "/julia_listings.tex"
    open(julia_listings_tex, "w") do f
        write(f, julialistings)
    end

    julia_listings_unicode_tex = path * "/julia_listings_unicode.tex"
    open(julia_listings_unicode_tex, "w") do f
        write(f, julialistingsunicode)
    end
end
