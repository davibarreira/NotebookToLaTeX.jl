# NotebookToLatex.jl

## Why this Package?
This package converts your notebook files (Pluto or Jupyter) to beautiful and
simple Latex files, that are easy to modify. Thus, making it ideal
to write reports, articles or books from notebooks.

Although it's already possible to convert both Pluto and Jupyter notebooks
to PDFs, or even to Latex (via Pandoc), the output Latex files
are usually very messy. In contrast, NotebookToLatex.jl is very
opinionated and specific, producing straightforward latex files.

This package uses [julia-mono-listing](https://github.com/mossr/julia-mono-listings),
to produce beautiful Julia code inside the Latex pdf.
Note that **it requires using `lualatex` for compilation**.

## Getting Started

This package is very simple to use. There is pretty much just one
function to be used, i.e.
```@docs
notebooktolatex
```

### Basic Use
To convert the notebooks just use `notebooktolatex("mynotebook.jl", template=:book)`.
This will produce a directory `./build_latex/` where the Latex files
will be generated. Inside `build_latex/` you will have:
```
build_latex
│   main.tex
│   julia_font.tex
│   julia_listings.tex
│   julia_listings_unicode.tex
│   preface.tex
│
└───figures
│   │   mynotebook_plot1.png
│   └───mynotebook_plot2.png
└───fonts
│   │   JuliaMono_Regular.ttf
│   │   ...
│   
└───frontmatter
│   │   titlepage.tex
│   └───copyright.tex
│
└───notebooks
    └───mynotebook.tex
```
Using `template=:book`, we get the Latex book format, thus, we have a `preface.tex`,
a `titlepage.tex` and a `copyright.tex` page. The notebook will be included
as a chapter. To get your final book pdf, just compile the `main.tex` using `lualatex`.

At the moment, the available templates are:
* `:book` - The standard Latex book template;
* `:mathbook` - Very similar to `:book`, but with some extra packages already imported.

## Function Documentation
```@docs
MyFunction
```
