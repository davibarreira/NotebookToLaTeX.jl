# NotebookToLatex.jl

## Why this Package?
This package converts your notebook files (Pluto or Jupyter) to beautiful and
simple Latex files, that are easy to modify. Thus, making it ideal
to write reports, articles or books from notebooks.

Although it's already possible to convert both Pluto and Jupyter notebooks
to PDFs, or even to Latex (via Pandoc), the PDFs are not very customizable
and the Latex files are usually very messy.
In contrast, NotebookToLatex.jl focuses less in generality, and
more on opinionated defaults.

The package has it's own implementation to parse Markdown to Latex,
e.g. it turns `# Example` to `\chapter{Example}`. Thus,
one can dive down into the actual Julia code and customize it
for his own preference. Or, submit an issue requesting
the feature. Hopefully, more and more customization will
be possible from the get go as the package evolves.

Another very important point to note is that NotebookToLatex.jl uses
[julia-mono-listing](https://github.com/mossr/julia-mono-listings).
This enables it to produce beautiful Julia code inside the Latex pdf.
Note that *it requires using `lualatex` for compilation*.

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

In case you want a different project folder, you can run the command
with an extra argument providing the target directory for the Latex files, e.g.:
```
`notebooktolatex("mynotebook.jl", "./project/",template=:book)`.
```
This will create a `./project/` folder instead of the `./build_latex`.

### Font - JuliaMono

Note that when you run `notebooktolatex` without providing a `fontpath`,
this will install the `.ttf` files in the project directory. You might instead
run the command with the path to the folder containing the `JuliaMono` fonts (at the moment,
the package requires this specific font in order to properly deal with unicode symbols).
Here is an example:
```
notebooktolatex("mynotebook.jl", template=:book,
        fontpath="/home/davibarreira/.local/share/fonts/Unknown Vendor/TrueType/JuliaMono/")
```
Note that I've used `/home/username` instead of `~/`. This is necessary for Latex to
correctly find your fonts. You can also do this manually by changing the `julia_font.tex` file.

### Templates

At the moment, the available templates are:
* `:book` - The standard Latex book template;
* `:mathbook` - Very similar to `:book`, but with some extra packages already imported.

### Workflow

Once the Latex files are generated, you can modify your notebooks and
run the `notebooktolatex` command again. This will only modify the
notebook Latex file and the figures, while all the other Latex
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


## How this Package Works

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
