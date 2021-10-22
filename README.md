# NotebookToLatex.jl <a href='https://github.com/davibarreira/NotebookToLatex.jl/blob/master/src/assets/logo.svg'><img src="src/assets/logo.svg" align="center" height="50." /></a>

[![][bag-dev]][bld-dev]
[![Build Status](https://github.com/davibarreira/NotebookToLatex.jl/workflows/CI/badge.svg)](https://github.com/davibarreira/NotebookToLatex.jl/actions)
[![Coverage](https://codecov.io/gh/davibarreira/NotebookToLatex.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/davibarreira/NotebookToLatex.jl)

![NotebookToLatex Example](./src/assets/notebooktolatexexample.png)

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

*This package has been tested on Linux and macOS, and might not work properly on Windows.*

## TL;DR
If you are too lazy to read the documentation (which is already quite brief),
then all you need to know is
to convert the notebooks just use `notebooktolatex("mynotebook.jl")`.
This will produce a directory `./build_latex/` where the Latex files
will be generated.

This package has two very similar templates at the moment (`:book`, `:mathbook`),
but another one will come very soon (`:article`). Since the output are simple
Latex files, you can just modify them to your needs.


[bag-dev]: https://img.shields.io/badge/docs-dev-blue.svg
[bld-dev]: https://davibarreira.github.io/NotebookToLatex.jl/dev
