# NotebookToLatex.jl <a href='https://github.com/davibarreira/PlutoLatexConverter.jl/blob/master/src/assets/logo.svg'><img src="src/assets/logo.svg" align="center" height="50." /></a>

[![][bag-dev]][bld-dev]
[![Build Status](https://github.com/davibarreira/PlutoLatexConverter.jl/workflows/CI/badge.svg)](https://github.com/davibarreira/PlutoLatexConverter.jl/actions)
[![Coverage](https://codecov.io/gh/davibarreira/PlutoLatexConverter.jl/branch/master/graph/badge.svg)](https://app.codecov.io/gh/davibarreira/NotebookToLatex.jl
)
**This is an experimental package.**

This package has been tested on Linux and macOS, and might not work properly on Windows.

The goal of this package is generate Latex files from Pluto and Jupyter notebooks.
At the current moment, Pluto.jl allows one to generate pdfs from notebooks,
but these are not customizable. This package turns notebooks into Latex files.

Still in progress...

This package uses [julia-mono-listing](https://github.com/mossr/julia-mono-listings),
hence, *it requires using `lualatex` for compilation*.

## Converting a Pluto Notebook to Latex

Once the files are created, the `./build_latex/julia_font.tex` file
contains information related to `Julia-Mono`, which is the font
used. Note that the user should define the path to the fonts location.

## Options

One can add a custom folder by passing the command
`cover = "cover.pdf"`. This will add the cover in the Latex template.

## Tips on Use

Note that there are some limitations on the parser from Markdown to Latex.
For example, it's advised to write links without white spaces,
e.g. `[mylink](www.github.com)`.

## For Developers
The information here is mostly for people who want to better understand what is
going on under the hood.

### Code Structure

## Saving Plots as Images

For plots to be saved as a figure to be used
on Latex, you must use either `Plots.jl`
or `Makie.jl`.


### Important Details
Here are some minor details that might go unnoticed, but that might be essential
for the proper working of the package.

A first thing to note is that inside the `book.tex` file there is a comment
line with `%! TeX program = lualatex`. This is necessary for people
using `vimtex` plugin for Vim. This line will tell the plugin to compile using
luatex, which is necessary.


#### To remember
```julia
const _notebook_header = "### A Pluto.jl notebook ###"
# We use a creative delimiter to avoid accidental use in code
# so don't get inspired to suddenly use these in your code!
const _cell_id_delimiter = "# ╔═╡ "
const _order_delimiter = "# ╠═"
const _order_delimiter_folded = "# ╟─"
const _cell_suffix = "\n\n"
```

TODO
* Enable customizing parser, for example, removing numbering in sections;
* Enable to pass a caption in the code listings (e.g.
`\begin{lstlisting}[language=JuliaLocal, style=julia, caption=SOR Algorithm, numbers=left]`);
* Add `\vline` before code (?);
* Add other color schemes;
* Add Jupyter Converter;

[bag-dev]: https://img.shields.io/badge/docs-dev-blue.svg
[bld-dev]: https://davibarreira.github.io/NotebookToLatex.jl/dev
