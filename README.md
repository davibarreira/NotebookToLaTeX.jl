# PlutoLatexConverter.jl

[![Build Status](https://github.com/davibarreira/PlutoLatexConverter.jl/workflows/CI/badge.svg)](https://github.com/davibarreira/PlutoLatexConverter.jl/actions)
[![Coverage](https://codecov.io/gh/davibarreira/PlutoLatexConverter.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/davibarreira/PlutoLatexConverter.jl)

**This is an experimental package.**

The goal of this package is generate Latex files from Pluto notebooks.
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
