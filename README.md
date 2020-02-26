# compilerexplorer.vim

This is a proof-of-concept vim plugin for local Compiler Explorer 
functionality, similar to https://godbolt.org/. Press `<F6>` to open a new tab 
which opens the files `ce.cpp`, `ce.asm`, and `ce.mca` in the CWD. On top, the 
invocations of the C++ compiler and llvm-mca can be configured.

After editing `ce.cpp`, press `<F6>` again to update `ce.asm` and `ce.mca`. If 
any diagnostic output was produced, a QuickFix window opens at the bottom and a 
new window on the left jumps to the first error.

At this point, this plugin is a quick solution for supporting my work: Inspect 
the codegen of certain C++ library calls, while developing the library.
If you find this plugin useful but need more features, please contribute your 
ideas or even better PRs.

## Installation

    mkdir -p ~/.vim/pack/mattkretz/start
    cd ~/.vim/pack/mattkretz/start
    git clone https://github.com/mattkretz/vim-compilerexplorer

## License

Copyright © Matthias Kretz.  Distributed under the same terms as Vim itself.
See `:help license`.
