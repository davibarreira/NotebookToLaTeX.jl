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
        tex = "%! TeX program = lualatex\n\\documentclass[12pt, oneside]{book}\n\n\\usepackage{listings}\n\n\\pagestyle{plain}\n\\usepackage{pdfpages}\n\\usepackage{titlesec}\n\n\\usepackage[square,numbers]{natbib}\n\\usepackage[pdftex,bookmarks=true,bookmarksopen=false,bookmarksnumbered=true,colorlinks=true,linkcolor=blue]{hyperref}\n\\usepackage[utf8]{inputenc}\n\\usepackage{float}\n\\usepackage{enumerate}\n\n%%%%%%% JULIA %%%%%%%%%%\n\\input{julia_font}\n\\input{julia_listings}\n\\input{julia_listings}\n\\input{julia_listings_unicode}\n\n\\lstdefinelanguage{JuliaLocal}{\n    language = Julia, % inherit Julia lang. to add keywords\n    morekeywords = [3]{thompson_sampling}, % define more functions\n    morekeywords = [2]{Beta, Distributions}, % define more types and modules\n}\n%%%%%%%%%%%%%%%%%%%%%%%%\n\n\n%%%%%%%%%% BOOK INFORMATION %%%%%%%%%%\n\\newcommand{\\authorname}{Name}\n\\newcommand{\\booktitle}{Title}\n\\newcommand{\\subtitle}{Subtitle}\n\\newcommand{\\publisher}{TBD}\n\\newcommand{\\editionyear}{2021}\n\\newcommand{\\isbn}{XYZ}   % replace this with your own ISBN\n\n\\title{\\booktitle}\n\\author{\\authorname}\n\n%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n\n\n\\begin{document}\n\n% \\includepdf{cover.pdf}\n\n\\frontmatter\n\\input{frontmatter/titlepage}\n\\input{frontmatter/copyright}\n% \\include{preface}\n\n\\newpage\n\\tableofcontents\n\n\\mainmatter\n\\newpage\n% INCLUDE NOTEBOOKS HERE %\n\n\\bibliography{ref}\n\n\\bibliographystyle{plainnat}\n\n\\include{appendix}\n\n\\end{document}\n"

    elseif template == :mathbook
        tex = "%! TeX program = lualatex\n\\documentclass[12pt, oneside]{book}\n\n\\usepackage{listings}\n\n\\pagestyle{plain}\n\\usepackage{pdfpages}\n\\usepackage{titlesec}\n\n%%%% MATH PACKAGES %%%%\n\n\\usepackage{amsfonts, amsthm,amsmath,amssymb,mathtools}\n\\usepackage{bbm}\n\\usepackage{bm}\n\\usepackage{mathtools}\n\\usepackage{thmtools} % List of Theorems\n\n%%%%%%%%%%%%%%%%%%%%%%%\n\n\\usepackage[square,numbers]{natbib}\n\\usepackage[pdftex,bookmarks=true,bookmarksopen=false,bookmarksnumbered=true,colorlinks=true,linkcolor=blue]{hyperref}\n\\usepackage[utf8]{inputenc}\n\\usepackage{float}\n\\usepackage{enumerate}\n\n%%%%%%% JULIA %%%%%%%%%%\n\\input{julia_font}\n\\input{julia_listings}\n\\input{julia_listings_unicode}\n\n\\lstdefinelanguage{JuliaLocal}{\n    language = Julia, % inherit Julia lang. to add keywords\n    morekeywords = [3]{thompson_sampling}, % define more functions\n    morekeywords = [2]{Beta, Distributions}, % define more types and modules\n}\n%%%%%%%%%%%%%%%%%%%%%%%%\n\n\n%%%%%%%%%% BOOK INFORMATION %%%%%%%%%%\n\\newcommand{\\authorname}{Name}\n\\newcommand{\\booktitle}{Title}\n\\newcommand{\\subtitle}{Subtitle}\n\\newcommand{\\publisher}{TBD}\n\\newcommand{\\editionyear}{2021}\n\\newcommand{\\isbn}{XYZ}   % replace this with your own ISBN\n\n\\title{\\booktitle}\n\\author{\\authorname}\n\n%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n\n%%%%%%%%%%%% MATH STYLE  %%%%%%%%%%%%%\n\\newtheoremstyle{bfnote}%\n  {}{}\n  {}{}\n  {\\bfseries}{.}\n  { }{\\thmname{#1}\\thmnumber{ #2}\\thmnote{ (#3)}}\n\\theoremstyle{bfnote}\n\\newenvironment{prf}[1][Proof]{\\textbf{#1.} }{\\qed}\n\\newtheorem{theorem}{Theorem}[section]\n\\newtheorem{definition}[theorem]{Definition}\n\\newtheorem{exer}{Exercise}[section]\n\\newtheorem{lemma}[theorem]{Lemma}\n\\newtheorem{corollary}[theorem]{Corollary}\n\\newtheorem{proposition}[theorem]{Proposition}\n\n\\newtheorem{note}{Note}[section]\n\\newtheorem{example}{Example}[section]\n%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n\n\\begin{document}\n\n% \\includepdf{cover.pdf}\n\n\\frontmatter\n\\input{frontmatter/titlepage}\n\\input{frontmatter/copyright}\n% \\include{preface}\n\n\\newpage\n\\tableofcontents\n\n%\\listoftheorems[onlynamed]\n\n\\mainmatter\n\\newpage\n% INCLUDE NOTEBOOKS HERE %\n\n\\bibliography{ref}\n\n\\bibliographystyle{plainnat}\n\n\\include{appendix}\n\n\\end{document}\n\n"
    end
    maintex = path * "/main.tex"
    if !isfile(maintex)
        open(maintex, "w") do f
            write(f, tex)
        end
    end

    preface = "\\newpage\n\\chapter*{Preface}\n\\addcontentsline{toc}{chapter}{Preface}\n"
    prefacetex = path * "/preface.tex"

    if !isfile(prefacetex)
        open(prefacetex, "w") do f
            write(f, preface)
        end
    end

    titlepage = "% \\pagestyle{empty}\n\n% % Half title page\n% {\n% \\centering\n\n% ~\n\n% \\vspace{24pt}\n% {\\scshape\\Huge \\booktitle \\par}\n% }\n% \\cleardoublepage\n\n% Title page\n\\begin{titlepage}\n\t\\centering\n\n\t~\n\n\t\\vspace{24pt}\n\t{\\scshape\\Huge \\booktitle\\par}\n\t\\vspace{6pt}\n\t{\\scshape\\large \\subtitle\\par}\n\t\\vspace{\\stretch{1.25}}\n\t{\\itshape\\large by\\par}\n\t\\vspace{6pt}\n\t{\\itshape\\Large \\authorname\\par}\n\t\\vspace{\\stretch{6}}\n\t{\\large \\publisher\\par}\n\\end{titlepage}\n"

    titlepagetex = path * "/frontmatter/titlepage.tex"
    if !isfile(titlepagetex)
        open(titlepagetex, "w") do f
            write(f, titlepage)
        end
    end

    copyright = "% Copyright page\n\n{\\small\n\\setlength{\\parindent}{0em}\\setlength{\\parskip}{1em}\n\n~\n\n\\vfill\n\nCopyright \\copyright{} 2021 \\authorname\n\nAll rights reserved. No part of this publication may be reproduced, stored or transmitted in any form or by any means, electronic, mechanical, photocopying, recording, scanning, or otherwise without written permission from the publisher. It is illegal to copy this book, post it to a website, or distribute it by any other means without permission.\n\nFirst edition, \\editionyear{}\n\nISBN \\isbn{}  % see main.tex\n\nPublished by \\publisher{}\n}\n"

    copyrighttex = path * "/frontmatter/copyright.tex"
    if !isfile(copyrighttex)
        open(copyrighttex, "w") do f
            write(f, copyright)
        end
    end
end

