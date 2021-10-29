# NotebookToLatex.jl

## Why this Package?
This package converts your notebook files (Pluto or Jupyter) to beautiful and
simple LaTeX files, that are easy to modify. Thus, making it ideal
to write reports, articles or books from notebooks.

Although it's already possible to convert both Pluto and Jupyter notebooks
to PDFs, or even to LaTeX (via Pandoc), the PDFs are not very customizable
and the LaTeX files are usually very messy.
In contrast, NotebookToLatex.jl focuses less in generality, and
more on opinionated defaults.

The package has it's own implementation to parse Markdown to LaTeX,
e.g. it turns `# Example` to `\chapter{Example}`. Thus,
one can dive down into the actual Julia code and customize it
for his own preference. Or, submit an issue requesting
the feature. Hopefully, more and more customization will
be possible from the get go as the package evolves.

Another very important point to note is that NotebookToLatex.jl uses
[julia-mono-listing](https://github.com/mossr/julia-mono-listings).
This enables it to produce beautiful Julia code inside the LaTeX pdf.
Note that *it requires using `lualatex` for compilation*.

## Getting Started

This package is very simple to use. There is pretty much just one
function to be used, i.e.
```@docs
notebooktolatex
```

### Basic Use
To convert the notebooks just use `notebooktolatex("mynotebook.jl", template=:book)`.
This will produce a directory `./build_latex/` where the LaTeX files
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
Using `template=:book`, we get the LaTeX book format, thus, we have a `preface.tex`,
a `titlepage.tex` and a `copyright.tex` page. The notebook will be included
as a chapter. To get your final book pdf, just compile the `main.tex` using `lualatex`.

In case you want a different project folder, you can run the command
with an extra argument providing the target directory for the LaTeX files, e.g.:
```julia
`notebooktolatex("mynotebook.jl", "./project/",template=:book)`.
```
This will create a `./project/` folder instead of the `./build_latex`.

If instead you just want a simple report containing the Notebook,
you can use the `:article` template.

### Font - JuliaMono

Note that when you run `notebooktolatex` without providing a `fontpath`,
this will install the `.ttf` files in the project directory. You might instead
run the command with the path to the folder containing the `JuliaMono` fonts (at the moment,
the package requires this specific font in order to properly deal with unicode symbols).
Here is an example:
```julia
notebooktolatex("mynotebook.jl", template=:book,
        fontpath="/home/davibarreira/.local/share/fonts/Unknown Vendor/TrueType/JuliaMono/")
```
Note that I've used `/home/username` instead of `~/`. This is necessary for LaTeX to
correctly find your fonts. You can also do this manually by changing the `julia_font.tex` file.

### Templates

At the moment, the available templates are:
* `:book` - The standard LaTeX book template;
* `:mathbook` - Very similar to `:book`, but with some extra packages already imported;
* `:article` - Simple template using the `article` document class.
* `:matharticle` - The `article` template with extra packages for mathematics.

### Plots and Images

At the moment, this package works with either `Makie.jl` (`CairoMakie.jl`)
and/or `Plots.jl`. These packages are actually dependencies, and they are used
to save the plots from Pluto notebooks. This is not necessary for the Jupyter converter.
In a near future, I intend to create a separate package for each converter, and use
`NotebookToLatex.jl` as a main package containing both.

Also important to note is that, while notebooks are good at displaying `svg` images,
this is not the case with LaTeX, which handles `pdf` images better. Hence,
if you have `![Example](figure.svg)`, this figure will be converted to a `pdf`
using `Librsvg_jll`.

### Workflow

Once the LaTeX files are generated, you can modify your notebooks and
run the `notebooktolatex` command again. This will only modify the
notebook LaTeX file and the figures, while all the other LaTeX
files will stay fixed. If you run the command for a new notebook,
it won't overwrite your current files, it will only add an
`include{newnotebook}` to the `main.tex`. Hence,
you can convert each notebook one at a time.

#### Jupyter Vs. Pluto

Jupyter notebooks store the outputs in the notebook file, while Pluto notebooks
are simple Julia scripts. Hence, when converting notebooks, the Jupyter notebooks
will be faster (way faster) to convert, since for the Pluto notebook, the converter
will have to run the actual notebook. Thus, if you intend to constantly modify
and convert your Pluto notebooks, it's advised to have a REPL (or a notebook!) 
with Julia running constantly, in order to avoid precompiling every time.
After converting the Pluto notebook the first time, the next time
should be quite fast.


## For Developers and Forkers

If you want to contribute to this package or if you want to modify it for your own use,
this section is relevant.
Here is a brief description of this package inner working.
At this moment, the `src/` contains five main Julia files:
* `templates.jl` - Contains the `main.tex`, `preface.tex`, and other `.tex` files templates.
If you want to alter the current template, you can just modify this script. Note that there are some
important lines that should be modified with care. For example, the `% INCLUDE NOTEBOOKS HERE %`
is used in the code in order to identify where to include the notebooks;
* `auxiliarytex.jl` - Similar to `templates.jl`, but it's used to generate
the `julia_font.tex`, `julia_listings.tex` and `julia_listings_unicode.tex`;
* `helperfunction.jl` - Contains a collection of small helper functions, such are
functions to add text to files in specific lines, creating folders, etc;
* `markdowntolatex.jl` - Here is where the Markdown parser is;
* `NotebookToLatex` - The functions to convert both Pluto and Jupyter are here.

Another thing to note is that inside the `main.tex` file there is a comment
line with `%! TeX program = lualatex`. This is necessary for people
using `vimtex` plugin for Vim. This line will tell the plugin to compile using
*luatex*, which is necessary.

### TODO

This package is still in it's earlier stages, so here is a list of things
still left to be done:
* Add new templates;
* Enable easier way of customizing parser, for example, removing numbering in sections;
* Enable to pass a caption in the code listings (e.g.
`\begin{lstlisting}[language=JuliaLocal, style=julia, caption=SOR Algorithm, numbers=left]`);
* Add `\vline` before code (?);
* Add other color schemes;
